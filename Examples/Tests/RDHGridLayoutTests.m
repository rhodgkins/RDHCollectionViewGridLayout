//
//  RDHGridLayoutTests.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 22/06/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RDHAppDelegate.h"

@interface RDHGridLayoutTests : XCTestCase

@property (nonatomic, weak) RDHDemoViewController *demoViewController;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) RDHCollectionViewGridLayout *layout;

@end

@implementation RDHGridLayoutTests

-(void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    RDHAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.demoViewController = appDelegate.demoViewController;
    [self.demoViewController reset];
    self.collectionView = self.demoViewController.collectionView;
    self.layout = self.demoViewController.collectionViewLayout;
    [appDelegate.window layoutIfNeeded];
}

-(void)testParameters
{
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    XCTAssertEqual(self.layout.scrollDirection, UICollectionViewScrollDirectionHorizontal, @"Scroll direction should be horiztonal");
    
    self.layout.lineDimension = 123;
    XCTAssertEqual(self.layout.lineDimension, 123, @"Line dimension should be 100");
    
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
    
    XCTAssertThrowsSpecificNamed(self.layout.lineDimension = -10, NSException, NSInternalInconsistencyException, @"Setting a negative line dimension should throw an exception");
    
    XCTAssertThrowsSpecificNamed(self.layout.lineItemCount = 0, NSException, NSInternalInconsistencyException, @"Setting a zero line item count should throw an exception");
}

-(void)testLocations
{
    self.layout.itemSpacing = 0;
    self.layout.lineSpacing = 0;
    self.layout.lineDimension = 123;
    self.layout.lineItemCount = 1;
    [self.demoViewController setLayout:self.layout animated:NO];
    
    CGRect frame;
    CGRect correctFrame = CGRectZero;
    
    frame = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].frame;
    
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        correctFrame.size.width = floor(CGRectGetWidth(self.collectionView.bounds) / self.layout.lineItemCount) - self.layout.itemSpacing;
        correctFrame.size.height = self.layout.lineDimension;
    } else {
        correctFrame.size.width = self.layout.lineDimension;
        correctFrame.size.height = floor(CGRectGetHeight(self.collectionView.bounds) / self.layout.lineItemCount) - self.layout.itemSpacing;
    }
    XCTAssertEqualRect(frame, correctFrame, @"The first items frame is not correct");
    
    if ([self.collectionView numberOfItemsInSection:0] > 1) {
        frame = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].frame;
        if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            correctFrame.origin.y += correctFrame.size.height;
        } else {
            correctFrame.origin.x += correctFrame.size.width;
        }
        XCTAssertEqualRect(frame, correctFrame, @"The second items frame is not correct");
    }
}

-(void)testLocationsWithSpaces
{
    self.layout.itemSpacing = 5;
    self.layout.lineSpacing = 9;
    self.layout.lineDimension = 104;
    self.layout.lineItemCount = 7;
    [self.demoViewController setLayout:self.layout animated:NO];
    
    CGRect frame;
    CGRect correctFrame = CGRectZero;
    
    frame = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].frame;
    
    CGFloat diff = 0;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        correctFrame.size.width = floor((CGRectGetWidth(self.collectionView.bounds)  - ((self.layout.lineItemCount - 1) * self.layout.itemSpacing)) / self.layout.lineItemCount);
        correctFrame.size.height = self.layout.lineDimension;
        diff = CGRectGetWidth(self.collectionView.bounds) - ((correctFrame.size.width * self.layout.lineItemCount) + ((self.layout.lineItemCount - 1) * self.layout.itemSpacing));
        if (diff > 0) {
            correctFrame.size.width++;
        }
    } else {
        correctFrame.size.width = self.layout.lineDimension;
        correctFrame.size.height = floor((CGRectGetHeight(self.collectionView.bounds) - ((self.layout.lineItemCount - 1) * self.layout.itemSpacing)) / self.layout.lineItemCount);
        diff = CGRectGetHeight(self.collectionView.bounds) - ((correctFrame.size.height * self.layout.lineItemCount) + ((self.layout.lineItemCount - 1) * self.layout.itemSpacing));
        if (diff > 0) {
            correctFrame.size.height++;
        }
    }
    XCTAssertEqualRect(frame, correctFrame, @"The first items frame is not correct");
    
    if ([self.collectionView numberOfItemsInSection:0] > 1) {
        frame = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].frame;
        if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            correctFrame.origin.x += correctFrame.size.width + self.layout.itemSpacing;
            if (diff > 0 && diff <= 1) {
                correctFrame.size.width--;
            }
        } else {
            correctFrame.origin.y += correctFrame.size.height + self.layout.itemSpacing;
            if (diff > 0 && diff <= 1) {
                correctFrame.size.height--;
            }
        }
        XCTAssertEqualRect(frame, correctFrame, @"The second items frame is not correct");
    }
}

@end
