//
//  msgpack_objc.m
//  msgpack-objc
//
//  Created by Joel Ekström on 2017-10-30.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import "MessagePack.h"
#import <msgpack-c/msgpack.h>

@implementation MessagePack

static NSDictionary<NSNumber *, Class> *_extensions;

+ (void)initialize
{
    if (self == [MessagePack self]) {
        [self registerClass:NSDate.class forExtensionType:-1];
    }
}

#pragma mark - Public

+ (void)registerClass:(Class)class forExtensionType:(int8_t)extensionType
{
    @synchronized (self) {
        if ([class conformsToProtocol:@protocol(MessagePackSerializable)]) {
            NSMutableDictionary *mutableExtensions = [NSMutableDictionary dictionaryWithDictionary:_extensions];
            mutableExtensions[@(extensionType)] = class;
            _extensions = [mutableExtensions copy];
        }
    }
}

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

#define ONE_BILLION 1000000000.0

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
        NSTimeInterval timeInterval = [(NSDate *)object timeIntervalSince1970];
        double integral = floor(timeInterval);
        double fractional = timeInterval - integral;
        msgpack_timestamp timestamp = {.tv_sec = integral, .tv_nsec = fractional * ONE_BILLION};
        msgpack_pack_timestamp(packer, &timestamp);
    } else {
        // Try to find a registered extension that supports packing of this object
        __block BOOL extensionFound;
        [_extensions enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, Class class, BOOL *stop) {
            if ([object isKindOfClass:class] && [object respondsToSelector:@selector(messagePackData)]) {
                NSData *data = [object messagePackData];
                if (data) {
                    msgpack_pack_ext(packer, data.length, key.intValue);
                    msgpack_pack_ext_body(packer, data.bytes, data.length);
                    extensionFound = YES;
                    *stop = YES;
                }
            }
        }];
        
        if (!extensionFound) {
            NSLog(@"msgpack-objc: Skipping object of unkown type: %@", object);
        }
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
            int8_t type = object.via.ext.type;

            // Timestamp
            if (type == -1) {
                msgpack_timestamp ts;
                msgpack_object_to_timestamp(&object, &ts);
                NSTimeInterval interval = ts.tv_sec + (ts.tv_nsec / ONE_BILLION);
                return [[NSDate alloc] initWithTimeIntervalSince1970:interval];
            }

            Class class = _extensions[@(type)];
            if (class) {
                NSData *data = [NSData dataWithBytes:object.via.ext.ptr length:object.via.ext.size];
                return [[class alloc] initWithMessagePackData:data extensionType:type];
            }
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

@end
