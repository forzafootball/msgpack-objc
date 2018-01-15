//
//  msgpack_objc.h
//  msgpack-objc
//
//  Created by Joel Ekström on 2017-10-30.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagePack : NSObject

+ (id)unpackData:(NSData *)data;
+ (NSData *)packObject:(id)object;

@end

@interface MessagePackExtension : NSObject

+ (instancetype)extensionWithType:(int8_t)type data:(NSData *)data;

@property (nonatomic, readonly) int8_t type;
@property (nonatomic, readonly) NSData *data;

@end
