//
//  XCTestCase+Extensions.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 18/09/2016.
//  Copyright © 2016 Rich H. All rights reserved.
//

@import XCTest;

@interface XCTestCase (TestCaseName)

@property (nonatomic, nonnull, readonly) NSString *testCaseName;

@end
