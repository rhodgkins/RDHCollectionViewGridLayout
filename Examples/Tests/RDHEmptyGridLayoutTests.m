//
//  RDHEmptyGridLayoutTests.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 22/06/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <XCTest/XCTest.h>

@import RDHCollectionViewGridLayout;

#import "Tests-Swift.h"

@interface RDHEmptyGridLayoutTests : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RDHCollectionViewGridLayout *layout;
@property (nonatomic, strong) EmptyTestDataSource *dataSource;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation RDHEmptyGridLayoutTests

-(void)setUp
{
    [super setUp];
    
    self.dataSource = [EmptyTestDataSource new];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    [self.window makeKeyAndVisible];
    self.layout = [RDHCollectionViewGridLayout new];
    UICollectionViewController *controller = [[UICollectionViewController alloc] initWithCollectionViewLayout:self.layout];
    controller.edgesForExtendedLayout = UIRectEdgeNone;
    controller.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView = controller.collectionView;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[TestDataSource CellID]];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = nil;
    self.window.rootViewController = controller;
}

-(void)testParameters
{
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    XCTAssertEqual(self.layout.scrollDirection, UICollectionViewScrollDirectionHorizontal, @"Scroll direction should be horiztonal");
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    XCTAssertFalse([[self.layout valueForKeyPath:@"verticalScrolling"] boolValue]);
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    XCTAssertTrue([[self.layout valueForKeyPath:@"verticalScrolling"] boolValue]);
    
    [self.layout setValue:@YES forKey:@"verticalScrolling"];
    XCTAssertEqual(self.layout.scrollDirection, UICollectionViewScrollDirectionVertical, @"Scroll direction should be vertical");
    [self.layout setValue:@NO forKey:@"verticalScrolling"];
    XCTAssertEqual(self.layout.scrollDirection, UICollectionViewScrollDirectionHorizontal, @"Scroll direction should be horiztonal");
    
    self.layout.lineSize = 123;
    XCTAssertEqual(self.layout.lineSize, 123, @"Line size is incorrect");
    XCTAssertEqual(self.layout.lineMultiplier, 1, @"Line multiplier should be default");
    XCTAssertEqual(self.layout.lineExtension, 0, @"Line extension should be default");
    
    self.layout.lineMultiplier = 2;
    XCTAssertEqual(self.layout.lineSize, 0, @"Line size should be default");
    XCTAssertEqual(self.layout.lineMultiplier, 2, @"Line multiplier is incorrect");
    XCTAssertEqual(self.layout.lineExtension, 0, @"Line extension should be default");
    
    self.layout.lineExtension = 200;
    XCTAssertEqual(self.layout.lineSize, 0, @"Line size should be default");
    XCTAssertEqual(self.layout.lineMultiplier, 1, @"Line multiplier should be default");
    XCTAssertEqual(self.layout.lineExtension, 200, @"Line extension is incorrect");
    
    self.layout.lineExtension = 0;
    XCTAssertEqual(self.layout.lineSize, 0, @"Line size should be default");
    XCTAssertEqual(self.layout.lineMultiplier, 1, @"Line multiplier should be default");
    XCTAssertEqual(self.layout.lineExtension, 0, @"Line extension should be default");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.layout.lineDimension = 123;
#pragma clang diagnostic pop
    XCTAssertEqual(self.layout.lineSize, 123, @"Line size is incorrect");
    XCTAssertEqual(self.layout.lineMultiplier, 1, @"Line multiplier should be default");
    XCTAssertEqual(self.layout.lineExtension, 0, @"Line extension should be default");
    
    self.layout.lineItemCount = 7;
    XCTAssertEqual(self.layout.lineItemCount, 7, @"Line item count should be 7");
    
    self.layout.itemSpacing = 23;
    XCTAssertEqual(self.layout.itemSpacing, 23, @"Line spacing should be 23");
    
    self.layout.sectionsStartOnNewLine = YES;
    XCTAssertTrue(self.layout.sectionsStartOnNewLine, @"Sections should start on new lines");
}

-(void)testInvalidParameters
{
    XCTAssertThrowsSpecificNamed(self.layout.scrollDirection = 5, NSException, NSInternalInconsistencyException, @"Setting an unknown scroll direction should throw an exception");
    
    XCTAssertThrowsSpecificNamed(self.layout.lineSize = -10, NSException, NSInternalInconsistencyException, @"Setting a negative line size should throw an exception");
    XCTAssertThrowsSpecificNamed(self.layout.lineMultiplier = -10, NSException, NSInternalInconsistencyException, @"Setting a negative line multiplier should throw an exception");
    XCTAssertThrowsSpecificNamed(self.layout.lineMultiplier = 0, NSException, NSInternalInconsistencyException, @"Setting a zero line multiplier should throw an exception");
    XCTAssertThrowsSpecificNamed(self.layout.lineExtension = -10, NSException, NSInternalInconsistencyException, @"Setting a negative line extension should throw an exception");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    XCTAssertThrowsSpecificNamed(self.layout.lineDimension = -10, NSException, NSInternalInconsistencyException, @"Setting a negative line dimension should throw an exception");
#pragma clang diagnostic pop
    
    XCTAssertThrowsSpecificNamed(self.layout.lineItemCount = 0, NSException, NSInternalInconsistencyException, @"Setting a zero line item count should throw an exception");
}

-(void)updateWindowFrame
{
    CGRect frame = CGRectZero;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        frame.size.width = 640;
        frame.size.height = 2000;
    } else {
        frame.size.width = 2000;
        frame.size.height = 640;
    }
    self.window.frame = frame;
    [self.window layoutIfNeeded];
    self.collectionView.frame = frame;
    [self.collectionView layoutIfNeeded];
}

-(void)testSizeLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];

    [self checkFrames];
}

-(void)testSizeLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testExtensionDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testExtensionWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testAutomaticDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testAutomaticWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testDirtyPixelCalculationsVerticalScrolling
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testDirtyPixelCalculationsHorizontalScrolling
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testItemSpacingWithVerticalScrolling
{
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testItemSpacingWithHorizontalScrolling
{
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testLineSpacingVerticalScrolling
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testLineSpacingHorizontalScrolling
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testItemAndLineSpacingVerticalScrolling
{
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)testItemAndLineSpacingHorizontalScrolling
{
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames];
}

-(void)checkFrames
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Frame checking"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect frame = CGRectZero;
        CGSize size = CGSizeZero;
        if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame.size.width = 640;
            frame.size.height = 2000;
            size.width = frame.size.width;
        } else {
            frame.size.width = 2000;
            frame.size.height = 640;
            size.height = frame.size.height;
        }
        XCTAssertEqualRect(self.window.frame, frame, @"Incorrect window frame (%@)", TestName());
        XCTAssertEqualSize(self.collectionView.contentSize, size, @"Incorrect content size (%@)", TestName());
        
        [expectation fulfill];
        
    });
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end

