//
//  msgpack_objc.m
//  msgpack-objc
//
//  Created by Joel Ekström on 2017-10-30.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import "MessagePack.h"
#import <msgpack.h>

@interface MessagePackExtension()

- (instancetype)initWithType:(uint8_t)type bytes:(const void *)bytes length:(NSUInteger)length;

@end

@implementation MessagePack

+ (id)unpackData:(NSData *)data
{
    msgpack_zone mempool;
    msgpack_zone_init(&mempool, 2048);
    msgpack_object deserialized;
    msgpack_unpack(data.bytes, data.length, NULL, &mempool, &deserialized);
    id object = nil;
    @autoreleasepool {
        object = objcObjectFromMsgPackObject(deserialized);
    }
    msgpack_zone_destroy(&mempool);
    return object;
}

+ (NSData *)packObject:(id)object
{
    msgpack_sbuffer buffer;
    msgpack_packer packer;
    msgpack_sbuffer_init(&buffer);
    msgpack_packer_init(&packer, &buffer, msgpack_sbuffer_write);
    packObjcObject(object, &packer);
    NSData *data = [NSData dataWithBytes:buffer.data length:buffer.size];
    msgpack_sbuffer_destroy(&buffer);
    return data;
}

void packObjcObject(id object, msgpack_packer *packer) {
    if ([object isKindOfClass:[NSArray class]]) {
        msgpack_pack_array(packer, [(NSArray *)object count]);
        for (id child in object) {
            packObjcObject(child, packer);
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        msgpack_pack_map(packer, [(NSDictionary *)object count]);
        [object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            packObjcObject(key, packer);
            packObjcObject(obj, packer);
        }];
    } else if ([object isKindOfClass:[NSString class]]) {
        const char *UTF8String = [(NSString *)object UTF8String];
        unsigned long length = strlen(UTF8String);
        msgpack_pack_str(packer, length);
        msgpack_pack_str_body(packer, UTF8String, length);
    } else if ([object isKindOfClass:[NSNumber class]]) {
        packNSNumber(object, packer);
    } else if ([object isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)object;
        msgpack_pack_bin(packer, data.length);
        msgpack_pack_bin_body(packer, data.bytes, data.length);
    } else if ([object isKindOfClass:[NSDate class]]) {
        packNSDate(object, packer);
    } else if ([object isKindOfClass:[MessagePackExtension class]]) {
        MessagePackExtension *extension = (MessagePackExtension *)object;
        msgpack_pack_ext(packer, extension.data.length, extension.type);
        msgpack_pack_ext_body(packer, extension.data.bytes, extension.data.length);
    } else {
        NSLog(@"msgpack-objc: Skipping object of unkown type: %@", object);
    }
}

void packNSNumber(NSNumber *number, msgpack_packer *packer) {
    // Booleans are singletons, so we can check for those explicitly
    if (number == (id)kCFBooleanTrue) {
        msgpack_pack_true(packer);
        return;
    } else if (number == (id)kCFBooleanFalse) {
        msgpack_pack_false(packer);
        return;
    }

#define pack_primitive(TYPE) {TYPE value; [number getValue:&value]; msgpack_pack_##TYPE(packer, value); break;}
#define pack_primitive_t(TYPE) {TYPE##_t value; [number getValue:&value]; msgpack_pack_##TYPE(packer, value); break;}
    CFNumberType numberType = CFNumberGetType((CFNumberRef)number);
    switch (numberType) {
        case kCFNumberSInt8Type:
            pack_primitive_t(int8);
        case kCFNumberSInt16Type:
            pack_primitive_t(int16);
        case kCFNumberSInt32Type:
            pack_primitive_t(int32);
        case kCFNumberSInt64Type:
            pack_primitive_t(int64);
        case kCFNumberFloatType:
        case kCFNumberFloat32Type:
            pack_primitive(float);
        case kCFNumberCGFloatType:
        case kCFNumberDoubleType:
        case kCFNumberFloat64Type:
            pack_primitive(double);
        case kCFNumberCharType:
            pack_primitive(char);
        case kCFNumberShortType:
            pack_primitive(short);
        case kCFNumberIntType:
            pack_primitive(int);
        case kCFNumberLongType:
        case kCFNumberNSIntegerType:
            pack_primitive(long);
        case kCFNumberLongLongType: {
            long long value; [number getValue:&value];
            msgpack_pack_long_long(packer, value);
            break;
        }
        default:
            NSLog(@"msgpack-objc: Skipping NSNumber of unknown type: %@", number);
            break;
    }
#undef pack_primitive
#undef pack_primitive_t
}

void packNSDate(NSDate *date, msgpack_packer *packer)
{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    struct timespec time = {.tv_sec = (long)timeInterval};
    time.tv_nsec = (timeInterval - (double)time.tv_sec) * 1000000000.0;
    if ((time.tv_sec >> 34) == 0) {
        uint64_t data64 = (time.tv_nsec << 34) | time.tv_sec;
        if ((data64 & 0xffffffff00000000L) == 0) {
            // timestamp 32
            uint32_t data32 = (uint32_t)data64;
            msgpack_pack_ext(packer, sizeof(data32), -1);
            msgpack_pack_ext_body(packer, &data32, sizeof(data32));
        }
        else {
            // timestamp 64
            msgpack_pack_ext(packer, sizeof(data64), -1);
            msgpack_pack_ext_body(packer, &data64, sizeof(data64));
        }
    }
    else {
        // timestamp 96
        msgpack_pack_ext(packer, 12, -1);
        uint32_t nsec = (uint32_t)time.tv_nsec;
        int64_t sec = (int64_t)time.tv_sec;
        msgpack_pack_ext_body(packer, &nsec, sizeof(nsec));
        msgpack_pack_ext_body(packer, &sec, sizeof(sec));
    }
}

id objcObjectFromMsgPackObject(msgpack_object object)
{
    switch (object.type) {
        case MSGPACK_OBJECT_NIL:
            return nil;

        case MSGPACK_OBJECT_BOOLEAN:
            return @(object.via.boolean);

        case MSGPACK_OBJECT_POSITIVE_INTEGER:
            return @(object.via.u64);

        case MSGPACK_OBJECT_NEGATIVE_INTEGER:
            return @(object.via.i64);

        case MSGPACK_OBJECT_FLOAT32:
        case MSGPACK_OBJECT_FLOAT64:
            return @(object.via.f64);

        case MSGPACK_OBJECT_STR:
            return [[NSString alloc] initWithBytes:object.via.str.ptr length:object.via.str.size encoding:NSUTF8StringEncoding];

        case MSGPACK_OBJECT_BIN:
            return [[NSData alloc] initWithBytes:object.via.bin.ptr length:object.via.bin.size];

        case MSGPACK_OBJECT_EXT: {
            // -1 is reserved for date objects, so we want to return an NSDate directly
            if (object.via.ext.type == -1) {
                return dateForDateExtension(object);
            }
            return [[MessagePackExtension alloc] initWithType:object.via.ext.type bytes:object.via.ext.ptr length:object.via.ext.size];
        }

        case MSGPACK_OBJECT_ARRAY: {
            int array_length = object.via.array.size;
            if (array_length == 0) {
                return @[];
            }

            id objects[array_length];
            for (int i = 0; i < array_length; ++i) {
                objects[i] = objcObjectFromMsgPackObject(object.via.array.ptr[i]);
            }
            return [[NSArray alloc] initWithObjects:objects count:array_length];
        }

        case MSGPACK_OBJECT_MAP: {
            int map_length = object.via.map.size;
            if (map_length == 0) {
                return @{};
            }

            id keys[map_length];
            id values[map_length];
            int array_index = 0;
            for (int i = 0; i < map_length; ++i) {
                msgpack_object_kv *p = object.via.map.ptr + i;
                id key = objcObjectFromMsgPackObject(p->key);
                id value = objcObjectFromMsgPackObject(p->val);
                if (key && value) {
                    keys[array_index] = key;
                    values[array_index] = value;
                    ++array_index;
                }
            }
            return [NSDictionary dictionaryWithObjects:values forKeys:keys count:array_index];
        }

        default:
            NSLog(@"Warning: Ecountered unexpected type when unpacking msgpack-object");
            return nil;
    }
}

NSDate *dateForDateExtension(msgpack_object object)
{
    struct timespec result;
    switch (object.via.ext.size) {
        case sizeof(uint32_t): {
            uint32_t data32 = *object.via.ext.ptr;
            result.tv_nsec = 0;
            result.tv_sec = data32;
            break;
        }
        case sizeof(uint64_t): {
            uint64_t data64 = *(uint64_t *)object.via.ext.ptr;
            result.tv_nsec = data64 >> 34;
            result.tv_sec = data64 & 0x00000003ffffffffL;
            break;
        }
        case 12: {
            uint32_t data32 = *(uint32_t *)object.via.ext.ptr;
            int64_t data64 = *(int64_t *)(object.via.ext.ptr + sizeof(uint32_t));
            result.tv_nsec = data32;
            result.tv_sec = data64;
            break;
        }
        default:
            NSLog(@"Warning: Encountered unsupported Date format in message pack data. Size is %u bytes but supported sizes are 32, 64 or 96 bits.", object.via.ext.size);
    }

    NSTimeInterval interval = result.tv_sec + (result.tv_nsec / 1000000000.0);
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end

@implementation MessagePackExtension

- (instancetype)initWithType:(uint8_t)type data:(NSData *)data
{
    if (self = [super init]) {
        _type = type;
        _data = data;
    }
    return self;
}

- (instancetype)initWithType:(uint8_t)type bytes:(const void *)bytes length:(NSUInteger)length
{
    return [self initWithType:type data:[NSData dataWithBytes:bytes length:length]];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    return [object isKindOfClass:self.class] &&
    [(MessagePackExtension *)object type] == self.type &&
    [self.data isEqual:[(MessagePackExtension *)object data]];
}

- (NSUInteger)hash
{
    return self.data.hash ^ self.type;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@> (type: %i, length: %lu)", NSStringFromClass(self.class), self.type, self.data.length];
}

@end
