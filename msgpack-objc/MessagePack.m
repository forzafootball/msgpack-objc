//
//  msgpack_objc.m
//  msgpack-objc
//
//  Created by Joel Ekström on 2017-10-30.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import "MessagePack.h"
#import <msgpack.h>

@interface TimestampExtension : MessagePackExtension

- (instancetype)initWithDate:(NSDate *)date;
- (NSDate *)date;

@end

@implementation MessagePack

#pragma mark - Public

+ (id)unpackData:(NSData *)data
{
    msgpack_zone mempool;
    msgpack_zone_init(&mempool, 2048);
    msgpack_object deserialized;
    msgpack_unpack_return result = msgpack_unpack(data.bytes, data.length, NULL, &mempool, &deserialized);
    id object = nil;
    if (result == MSGPACK_UNPACK_SUCCESS) {
        object = objectForMessagePackObject(deserialized);
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"%@", [self errorDescriptionForResult:result]];
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
    packObject(object, &packer);
    NSData *data = [NSData dataWithBytes:buffer.data length:buffer.size];
    msgpack_sbuffer_destroy(&buffer);
    return data;
}

+ (NSString *)errorDescriptionForResult:(msgpack_unpack_return)result
{
    switch (result) {
        case MSGPACK_UNPACK_PARSE_ERROR:
            return @"Couldn't parse MessagePack-data.";
        case MSGPACK_UNPACK_EXTRA_BYTES:
            return @"MessagePack-data contains extra bytes.";
        case MSGPACK_UNPACK_NOMEM_ERROR:
            return @"Ran out of memory while parsing MessagePack-data";
        default:
            return nil;
    }
}

#pragma mark - Packing

void packObject(id object, msgpack_packer *packer)
{
    if ([object isKindOfClass:[NSArray class]]) {
        msgpack_pack_array(packer, [(NSArray *)object count]);
        for (id child in object) {
            packObject(child, packer);
        }
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        msgpack_pack_map(packer, [(NSDictionary *)object count]);
        [object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            packObject(key, packer);
            packObject(obj, packer);
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
        TimestampExtension *extension = [[TimestampExtension alloc] initWithDate:object];
        packObject(extension, packer);
    } else if ([object isKindOfClass:[MessagePackExtension class]]) {
        MessagePackExtension *extension = (MessagePackExtension *)object;
        msgpack_pack_ext(packer, extension.data.length, extension.type);
        msgpack_pack_ext_body(packer, extension.data.bytes, extension.data.length);
    } else {
        NSLog(@"msgpack-objc: Skipping object of unkown type: %@", object);
    }
}

void packNSNumber(NSNumber *number, msgpack_packer *packer)
{
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

#pragma mark - Unpacking

id objectForMessagePackObject(msgpack_object object)
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
            NSData *data = [NSData dataWithBytes:object.via.ext.ptr length:object.via.ext.size];
            MessagePackExtension *extension = [MessagePackExtension extensionWithType:object.via.ext.type data:data];
            if ([extension isKindOfClass:TimestampExtension.class]) {
                return [(TimestampExtension *)extension date];
            }
            return extension;
        }

        case MSGPACK_OBJECT_ARRAY: {
            int array_length = object.via.array.size;
            if (array_length == 0) {
                return @[];
            }

            id objects[array_length];
            for (int i = 0; i < array_length; ++i) {
                objects[i] = objectForMessagePackObject(object.via.array.ptr[i]);
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
                id key = objectForMessagePackObject(p->key);
                id value = objectForMessagePackObject(p->val);
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

#pragma mark - Extensions
#define ONE_BILLION 1000000000.0

void reverseBytes(uint8_t *start, int size) {
    uint8_t *end = start + size - 1;
    while (start < end) {
        uint8_t temp = *start;
        *start++ = *end;
        *end-- = temp;
    }
}

@end

@implementation MessagePackExtension

+ (instancetype)extensionWithType:(int8_t)type data:(NSData *)data
{
    Class extensionClass = type == -1 ? TimestampExtension.class : self;
    return [[extensionClass alloc] initWithType:type data:data];
}

- (instancetype)initWithType:(int8_t)type data:(NSData *)data
{
    if (self = [super init]) {
        _type = type;
        _data = data;
    }
    return self;
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

@implementation TimestampExtension

- (instancetype)initWithDate:(NSDate *)date
{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    double integral = floor(timeInterval);
    double fractional = timeInterval - integral;
    struct timespec time = {.tv_sec = integral, .tv_nsec = fractional * ONE_BILLION};
    NSData *data = nil;
    if ((time.tv_sec >> 34) == 0) {
        uint64_t data64 = (time.tv_nsec << 34) | time.tv_sec;
        if ((data64 & 0xffffffff00000000L) == 0) {
            // timestamp 32
            uint32_t data32 = CFSwapInt32HostToBig((uint32_t)data64);
            data = [NSData dataWithBytes:&data32 length:sizeof(data32)];
        } else {
            // timestamp 64
            uint64_t bigEndianData64 = CFSwapInt64HostToBig(data64);
            data = [NSData dataWithBytes:&bigEndianData64 length:sizeof(bigEndianData64)];
        }
    } else {
        // timestamp 96
        uint32_t nsec = (uint32_t)time.tv_nsec;
        int64_t sec = (int64_t)time.tv_sec;
        uint8_t bytes[12];

        if (OSHostByteOrder() == OSLittleEndian) {
            memcpy(&bytes[0], (int64_t *)&sec, sizeof(sec));
            memcpy(&bytes[0] + sizeof(sec), (uint32_t *)&nsec, sizeof(nsec));
            reverseBytes((uint8_t *)&bytes, sizeof(bytes));
        } else {
            memcpy(&bytes[0], (uint32_t *)&nsec, sizeof(nsec));
            memcpy(&bytes[0] + sizeof(nsec), (int64_t *)&sec, sizeof(sec));
        }
        data = [NSData dataWithBytes:&bytes[0] length:sizeof(bytes)];
    }
    return [self initWithType:-1 data:data];
}

- (NSDate *)date
{
    struct timespec result;
    switch (self.data.length) {
        case sizeof(uint32_t): {
            uint32_t data32 = CFSwapInt32BigToHost(*(uint32_t *)self.data.bytes);
            result.tv_nsec = 0;
            result.tv_sec = data32;
            break;
        }
        case sizeof(uint64_t): {
            uint64_t data64 = CFSwapInt64BigToHost(*(uint64_t *)self.data.bytes);
            result.tv_nsec = data64 >> 34;
            result.tv_sec = data64 & 0x00000003ffffffffL;
            break;
        }
        case 12: {
            if (OSHostByteOrder() == OSLittleEndian) {
                uint8_t bytes[12];
                [self.data getBytes:&bytes[0] length:self.data.length];
                reverseBytes(&bytes[0], 12);
                result.tv_sec = *(int64_t *)&bytes[0];
                result.tv_nsec = *(uint32_t *)(&bytes[0] + sizeof(int64_t));
            } else {
                result.tv_nsec = *(uint32_t *)self.data.bytes;
                result.tv_sec = *(int64_t *)(self.data.bytes + sizeof(uint32_t));
            }
            break;
        }
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Encountered unsupported TimeStamp format in MessagePack-data. Size is %li bytes but supported sizes are 32, 64 or 96 bits.", self.data.length];
    }

    NSTimeInterval interval = result.tv_sec + (result.tv_nsec / ONE_BILLION);
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
