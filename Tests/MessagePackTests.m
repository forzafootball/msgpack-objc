//
//  Tests.m
//  Tests
//
//  Created by Joel Ekström on 2017-11-06.
//  Copyright © 2017 FootballAddicts AB. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MessagePack.h"

@interface MessagePackTests : XCTestCase

@end

@implementation MessagePackTests

- (void)testJSONUnpackPerformance {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"testdata" ofType:@"json" inDirectory:nil];
    NSData *JSONData = [NSData dataWithContentsOfFile:path];
    [self measureBlock:^{
        [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
    }];
}

- (void)testMessagePackUnpackPerformance {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"testdata" ofType:@"msgpack" inDirectory:nil];
    NSData *messagePackData = [NSData dataWithContentsOfFile:path];
    [self measureBlock:^{
        [MessagePack unpackData:messagePackData];
    }];
}

- (void)testStringPacking {
    NSString *testString = @"A string with ovänliga karaktärer 🙈";
    NSData *packed = [MessagePack packObject:testString];
    NSString *unpacked = [MessagePack unpackData:packed];
    XCTAssertEqualObjects(testString, unpacked);
}

- (void)testNumberPacking {
    NSNumber *anInt = [NSNumber numberWithInt:64];
    NSNumber *aFloat = [NSNumber numberWithFloat:10.5];
    NSNumber *aDouble = [NSNumber numberWithDouble:100.1];
    NSNumber *aChar = [NSNumber numberWithChar:8];
    NSNumber *aBool = @YES;
    NSArray *numbers = @[anInt, aFloat, aDouble, aChar, aBool];
    NSData *packed = [MessagePack packObject:numbers];
    NSArray *unpacked = [MessagePack unpackData:packed];
    XCTAssertEqualObjects(numbers, unpacked);
    XCTAssertEqual(unpacked[4], @YES);
}

- (void)testDictionaryPacking {
    NSDictionary *dictionary = @{@"an array": @[@1, @2, @YES, @"hello"],
                                 @"a number": @41241,
                                 @"another dictionary": @{@"a": @1, @"b": @"yes, hello"},
                                 @"a string": @"yes, yes"};
    NSData *packed = [MessagePack packObject:dictionary];
    NSDictionary *unpacked = [MessagePack unpackData:packed];
    XCTAssertEqualObjects(dictionary, unpacked);
}

- (void)testExtensionPacking {
    NSString *testString = @"A string with ovänliga karaktärer 🙈";
    NSData *testData = [testString dataUsingEncoding:NSUnicodeStringEncoding];
    MessagePackExtension *extension = [[MessagePackExtension alloc] initWithType:14 bytes:testData.bytes length:testData.length];
    NSData *packed = [MessagePack packObject:extension];
    MessagePackExtension *unpacked = [MessagePack unpackData:packed];
    XCTAssertEqualObjects(extension, unpacked);
    XCTAssertEqualObjects(testString, [[NSString alloc] initWithData:unpacked.data encoding:NSUnicodeStringEncoding]);
}

- (void)testDatePacking {
    NSDate *date32 = [NSDate dateWithTimeIntervalSince1970:1000000];
    NSDate *date64 = [NSDate dateWithTimeIntervalSince1970:1500000.12345];
    NSDate *date96 = [NSDate dateWithTimeIntervalSince1970:2147483647999.12345789];
    NSDate *negativeDate = [NSDate dateWithTimeIntervalSince1970:-10000.5];
    NSDate *distantPast = [NSDate distantFuture];
    NSDate *distantFuture = [NSDate distantFuture];
    NSDate *currentDate = [NSDate new];

    NSArray *dates = @[date32, date64, date96, negativeDate, distantPast, distantFuture, currentDate];
    NSData *packed = [MessagePack packObject:dates];
    NSArray *unpacked = [MessagePack unpackData:packed];
    XCTAssertEqualObjects(unpacked[0], date32);
    XCTAssertEqualObjects(unpacked[1], date64);
    XCTAssertEqualObjects(unpacked[2], date96);
    XCTAssertEqualObjects(unpacked[3], negativeDate);
    XCTAssertEqualObjects(unpacked[4], distantPast);
    XCTAssertEqualObjects(unpacked[5], distantFuture);

    // We must check the time interval since 1970 on the current date, since that's what is serialized to MessagePack.
    // Comparing with timeIntervalSinceReferenceDate can be false, and that seems to be what isEqual: does for NSDate
    XCTAssertEqual([unpacked[6] timeIntervalSince1970], [currentDate timeIntervalSince1970]);
}

@end
