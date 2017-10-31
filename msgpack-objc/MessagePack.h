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

@end
