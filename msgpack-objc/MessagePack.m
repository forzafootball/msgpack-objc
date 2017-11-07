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

        case MSGPACK_OBJECT_EXT:
            return [[MessagePackExtension alloc] initWithType:object.via.ext.type bytes:object.via.ext.ptr length:object.via.ext.size];

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

@end
