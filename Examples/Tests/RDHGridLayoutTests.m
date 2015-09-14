//
//  RDHGridLayoutTests.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 22/06/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <XCTest/XCTest.h>

@import RDHCollectionViewGridLayout;

#import "Tests-Swift.h"

@interface RDHGridLayoutTests : XCTestCase

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RDHCollectionViewGridLayout *layout;
@property (nonatomic, strong) TestDataSource *dataSource;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation RDHGridLayoutTests

-(void)setUp
{
    [super setUp];
    
    self.dataSource = [TestDataSource new];
    
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
    NSDictionary *frames = @{
         IPF(0, 0, 0, 000, 320, 120), IPF(0, 1, 320, 000, 320, 120),
         IPF(0, 2, 0, 120, 320, 120), IPF(1, 0, 320, 120, 320, 120),
         IPF(1, 1, 0, 240, 320, 120), IPF(1, 2, 320, 240, 320, 120),
         IPF(2, 0, 0, 360, 320, 120), IPF(2, 1, 320, 360, 320, 120),
         IPF(2, 2, 0, 480, 320, 120)
     };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
    
    IPF(0, 0, 000, 000, 120, 320), IPF(0, 2, 120, 000, 120, 320), IPF(1, 1, 240, 000, 120, 320), IPF(2, 0, 360, 000, 120, 320), IPF(2, 2, 480, 000, 120, 320),
    
    IPF(0, 1, 000, 320, 120, 320), IPF(1, 0, 120, 320, 120, 320), IPF(1, 2, 240, 320, 120, 320), IPF(2, 1, 360, 320, 120, 320)
       };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];

    [self checkFrames:frames];
}

-(void)testSizeLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
         IPF(0, 0, 0, 000, 320, 120), IPF(0, 1, 320, 000, 320, 120),
         IPF(0, 2, 0, 120, 320, 120),
         IPF(1, 0, 0, 240, 320, 120), IPF(1, 1, 320, 240, 320, 120),
         IPF(1, 2, 0, 360, 320, 120),
         IPF(2, 0, 0, 480, 320, 120), IPF(2, 1, 320, 480, 320, 120),
         IPF(2, 2, 0, 600, 320, 120)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testSizeLocationsWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
                             
    IPF(0, 0, 000, 000, 120, 320), IPF(0, 2, 120, 000, 120, 320), IPF(1, 0, 240, 000, 120, 320), IPF(1, 2, 360, 000, 120, 320), IPF(2, 0, 480, 000, 120, 320), IPF(2, 2, 600, 000, 120, 320),
                             
    IPF(0, 1, 000, 320, 120, 320),                                IPF(1, 1, 240, 320, 120, 320),                                IPF(2, 1, 480, 320, 120, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 120;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
                             IPF(0, 0, 0, 000, 320, 160), IPF(0, 1, 320, 000, 320, 160),
                             IPF(0, 2, 0, 160, 320, 160), IPF(1, 0, 320, 160, 320, 160),
                             IPF(1, 1, 0, 320, 320, 160), IPF(1, 2, 320, 320, 320, 160),
                             IPF(2, 0, 0, 480, 320, 160), IPF(2, 1, 320, 480, 320, 160),
                             IPF(2, 2, 0, 640, 320, 160)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
                             
    IPF(0, 0, 000, 000, 160, 320), IPF(0, 2, 160, 000, 160, 320), IPF(1, 1, 320, 000, 160, 320), IPF(2, 0, 480, 000, 160, 320), IPF(2, 2, 640, 000, 160, 320),
     
    IPF(0, 1, 000, 320, 160, 320), IPF(1, 0, 160, 320, 160, 320), IPF(1, 2, 320, 320, 160, 320), IPF(2, 1, 480, 320, 160, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testMultiplierDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
         IPF(0, 0, 0, 000, 320, 160), IPF(0, 1, 320, 000, 320, 160),
         IPF(0, 2, 0, 160, 320, 160),
         IPF(1, 0, 0, 320, 320, 160), IPF(1, 1, 320, 320, 320, 160),
         IPF(1, 2, 0, 480, 320, 160),
         IPF(2, 0, 0, 640, 320, 160), IPF(2, 1, 320, 640, 320, 160),
         IPF(2, 2, 0, 800, 320, 160)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testMultiplierDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
                             
    IPF(0, 0, 000, 000, 160, 320), IPF(0, 2, 160, 000, 160, 320), IPF(1, 0, 320, 000, 160, 320), IPF(1, 2, 480, 000, 160, 320), IPF(2, 0, 640, 000, 160, 320), IPF(2, 2, 800, 000, 160, 320),
                             
    IPF(0, 1, 000, 320, 160, 320),                                IPF(1, 1, 320, 320, 160, 320),                                IPF(2, 1, 640, 320, 160, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineMultiplier = 0.5;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
         IPF(0, 0, 0,  000, 320, 370), IPF(0, 1, 320,  000, 320, 370),
         IPF(0, 2, 0,  370, 320, 370), IPF(1, 0, 320,  370, 320, 370),
         IPF(1, 1, 0,  740, 320, 370), IPF(1, 2, 320,  740, 320, 370),
         IPF(2, 0, 0, 1110, 320, 370), IPF(2, 1, 320, 1110, 320, 370),
         IPF(2, 2, 0, 1480, 320, 370)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testExtensionDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
                             
     IPF(0, 0, 0000, 000, 370, 320), IPF(0, 2,  370, 000, 370, 320), IPF(1, 1,  740, 000, 370, 320), IPF(2, 0, 1110, 000, 370, 320), IPF(2, 2, 1480, 000, 370, 320),
     
     IPF(0, 1, 0000, 320, 370, 320), IPF(1, 0,  370, 320, 370, 320), IPF(1, 2,  740, 320, 370, 320), IPF(2, 1, 1110, 320, 370, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testExtensionDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
     IPF(0, 0, 0,  000, 320, 370), IPF(0, 1, 320,  000, 320, 370),
     IPF(0, 2, 0,  370, 320, 370),
     IPF(1, 0, 0,  740, 320, 370), IPF(1, 1, 320,  740, 320, 370),
     IPF(1, 2, 0, 1110, 320, 370),
     IPF(2, 0, 0, 1480, 320, 370), IPF(2, 1, 320, 1480, 320, 370),
     IPF(2, 2, 0, 1850, 320, 370)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testExtensionWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
                             
     IPF(0, 0,  000, 000, 370, 320), IPF(0, 2,  370, 000, 370, 320), IPF(1, 0,  740, 000, 370, 320), IPF(1, 2, 1110, 000, 370, 320), IPF(2, 0, 1480, 000, 370, 320), IPF(2, 2, 1850, 000, 370, 320),
     
     IPF(0, 1,  000, 320, 370, 320),                                 IPF(1, 1,  740, 320, 370, 320),                                 IPF(2, 1, 1480, 320, 370, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineExtension = 50;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
     IPF(0, 0, 0,  000, 320, 320), IPF(0, 1, 320, 000, 320, 320),
     IPF(0, 2, 0,  320, 320, 320), IPF(1, 0, 320, 320, 320, 320),
     IPF(1, 1, 0,  640, 320, 320), IPF(1, 2, 320, 640, 320, 320),
     IPF(2, 0, 0,  960, 320, 320), IPF(2, 1, 320, 960, 320, 320),
     IPF(2, 2, 0, 1280, 320, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testAutomaticDimensionLocationsWithHorizontalScrollViewSectionsStartOnNewLineNO
{
    NSDictionary *frames = @{
                             
     IPF(0, 0, 000, 000, 320, 320), IPF(0, 2, 320, 000, 320, 320), IPF(1, 1, 640, 000, 320, 320), IPF(2, 0, 960, 000, 320, 320), IPF(2, 2, 1280, 000, 320, 320),
     
     IPF(0, 1, 000, 320, 320, 320), IPF(1, 0, 320, 320, 320, 320), IPF(1, 2, 640, 320, 320, 320), IPF(2, 1, 960, 320, 320, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testAutomaticDimensionLocationsWithVerticalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
     IPF(0, 0, 0,  000, 320, 320), IPF(0, 1, 320,  000, 320, 320),
     IPF(0, 2, 0,  320, 320, 320),
     IPF(1, 0, 0,  640, 320, 320), IPF(1, 1, 320,  640, 320, 320),
     IPF(1, 2, 0,  960, 320, 320),
     IPF(2, 0, 0, 1280, 320, 320), IPF(2, 1, 320, 1280, 320, 320),
     IPF(2, 2, 0, 1600, 320, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testAutomaticWithHorizontalScrollViewSectionsStartOnNewLineYES
{
    NSDictionary *frames = @{
                             
     IPF(0, 0,  000, 000, 320, 320), IPF(0, 2, 320, 000, 320, 320), IPF(1, 0,  640, 000, 320, 320), IPF(1, 2, 960, 000, 320, 320), IPF(2, 0, 1280, 000, 320, 320), IPF(2, 2, 1600, 000, 320, 320),
     
     IPF(0, 1,  000, 320, 320, 320),                                IPF(1, 1,  640, 320, 320, 320),                                IPF(2, 1, 1280, 320, 320, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionsStartOnNewLine = YES;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testDirtyPixelCalculations
{
    NSDictionary *frames = @{
                             IPF(0, 0, 0, 000, 214, 213), IPF(0, 1, 214, 000, 213, 213), IPF(0, 2, 427, 000, 213, 213),
                             IPF(1, 0, 0, 213, 214, 213), IPF(1, 1, 214, 213, 213, 213), IPF(1, 2, 427, 213, 213, 213),
                             IPF(2, 0, 0, 426, 214, 213), IPF(2, 1, 214, 426, 213, 213), IPF(2, 2, 427, 426, 213, 213)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testItemSpacing
{
    NSDictionary *frames = @{
                             IPF(0, 0, 0, 000, 212, 212), IPF(0, 1, 214, 000, 212, 212), IPF(0, 2, 428, 000, 212, 212),
                             IPF(1, 0, 0, 212, 212, 212), IPF(1, 1, 214, 212, 212, 212), IPF(1, 2, 428, 212, 212, 212),
                             IPF(2, 0, 0, 424, 212, 212), IPF(2, 1, 214, 424, 212, 212), IPF(2, 2, 428, 424, 212, 212)
                             };
    
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 0;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testLineSpacing
{
    NSDictionary *frames = @{
                             IPF(0, 0, 0,  000, 320, 320), IPF(0, 1, 320, 000, 320, 320),
                             IPF(0, 2, 0,  330, 320, 320), IPF(1, 0, 320, 330, 320, 320),
                             IPF(1, 1, 0,  660, 320, 320), IPF(1, 2, 320, 660, 320, 320),
                             IPF(2, 0, 0,  990, 320, 320), IPF(2, 1, 320, 990, 320, 320),
                             IPF(2, 2, 0, 1320, 320, 320)
                             };
    
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 2;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)testItemAndLineSpacing
{
    NSDictionary *frames = @{
                             IPF(0, 0, 0, 000, 212, 212), IPF(0, 1, 214, 000, 212, 212), IPF(0, 2, 428, 000, 212, 212),
                             IPF(1, 0, 0, 222, 212, 212), IPF(1, 1, 214, 222, 212, 212), IPF(1, 2, 428, 222, 212, 212),
                             IPF(2, 0, 0, 444, 212, 212), IPF(2, 1, 214, 444, 212, 212), IPF(2, 2, 428, 444, 212, 212)
                             };
    
    self.layout.itemSpacing = 2;
    self.layout.lineSpacing = 10;
    self.layout.lineSize = 0;
    self.layout.lineItemCount = 3;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.sectionsStartOnNewLine = NO;
    [self updateWindowFrame];
    
    [self checkFrames:frames];
}

-(void)checkFrames:(NSDictionary *)frames
{
    NSAssert(frames.count == 9, @"Incorrect number of frames");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Frame checking"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect frame = CGRectZero;
        if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame.size.width = 640;
            frame.size.height = 2000;
        } else {
            frame.size.width = 2000;
            frame.size.height = 640;
        }
        XCTAssertEqualRect(self.window.frame, frame, @"Incorrect window frame");
    
        [frames enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *vRect, BOOL *stop) {
            
            NSString *indexPathDesc = [NSString stringWithFormat:@"NSIndexPath(%ld,%ld)", (long) indexPath.section, (long) indexPath.row];
            NSString *testName = [[self.name stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"-[%@ ", NSStringFromClass([self class])] withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            
            CGRect expectedFrame = [vRect CGRectValue];
            CGRect actualFrame = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
            
            XCTAssertEqualRect(actualFrame, expectedFrame, @"Frame of %@ is incorrect (%@)", indexPathDesc, testName);
        }];
        
        [expectation fulfill];
        
    });
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end

