//
//  XCTestCase+Extensions.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 18/09/2016.
//  Copyright © 2016 Rich H. All rights reserved.
//

#import "XCTestCase+Extensions.h"

@implementation XCTestCase (TestCaseName)

-(NSString *_Nonnull)testCaseName
{
    NSString *className = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Tests." withString:@""];
    return [[self.name stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"-[%@ ", className] withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
}

@end
