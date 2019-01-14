//
//  msgpack_objc.h
//  msgpack-objc
//
//  Created by Joel Ekström on 2017-10-30.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessagePackSerializable

@required
- (instancetype)initWithMessagePackData:(NSData *)data extensionType:(int8_t)type;

@optional
- (NSData *)messagePackData;

@end

@interface MessagePack : NSObject

+ (id)unpackData:(NSData *)data;
+ (NSData *)packObject:(id)object;

+ (void)registerClass:(Class)class forExtensionType:(int8_t)extensionType;

@end
