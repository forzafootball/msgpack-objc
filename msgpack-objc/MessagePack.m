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
