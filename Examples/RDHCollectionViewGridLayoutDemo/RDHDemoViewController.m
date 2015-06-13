//
//  RDHDemoViewController.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoViewController.h"

@import RDHCollectionViewGridLayout;

#import "RDHDemoCell.h"

#define RDH_RANDOM_DATA 1

#define FIXED_LAYOUT 0

@interface RDHDemoViewController ()

@property (nonatomic, readonly) RDHCollectionViewGridLayout *currentCollectionViewLayout;

@property (nonatomic, copy, readonly) NSDictionary<NSNumber *, NSNumber *> *testData;

@end

@implementation RDHDemoViewController

@dynamic collectionViewLayout;

+(RDHCollectionViewGridLayout *)newGridLayout
{
    RDHCollectionViewGridLayout *layout = [RDHCollectionViewGridLayout new];
    layout.lineItemCount = RDH_RANDOM_DATA ? ((arc4random() % 5) + 1) : 4;
    layout.lineSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 5;
    layout.itemSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 10;
    if (RDH_RANDOM_DATA) {
        switch (arc4random() % 3) {
            case 0: // Line size
                layout.lineSize = 160;
                break;
            case 1: // Line multiplier
                layout.lineMultiplier = 2;
                break;
            case 2: // Line extension
                layout.lineExtension = 100;
                break;
        }
    } else {
        layout.lineSize = 0;
    }
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = YES;
    
#if FIXED_LAYOUT
    
    layout.itemSpacing = 0;
    layout.lineSpacing = 0;
    layout.lineSize = 0;
    layout.lineItemCount = 3;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = NO;
    
#endif
    
    return layout;
}

- (instancetype)init
{
    self = [self initWithCollectionViewLayout:[[self class] newGridLayout]];
    if (self) {
        // Custom initialization
                
        NSUInteger sectionCount = RDH_RANDOM_DATA ? (arc4random() % 20) + 10 : 10;
        NSMutableDictionary *testData = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
        for (NSUInteger i=0; i<sectionCount; i++) {
            testData[@(i)] = @(RDH_RANDOM_DATA ? (arc4random() % 16) : 10);
        }
        _testData = [testData copy];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapResetItem)];
        
        UIBarButtonItem *changeScrollDirection = [[UIBarButtonItem alloc] initWithTitle:@"Scrolling" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeScrollDirectionItem)];
        UIBarButtonItem *sectionsOnNewLine = [[UIBarButtonItem alloc] initWithTitle:@"New Line" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeStartSectionOnNewLineItem)];
        
        self.navigationItem.rightBarButtonItems = @[changeScrollDirection, sectionsOnNewLine];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:[RDHDemoCell class] forCellWithReuseIdentifier:[RDHDemoCell reuseIdentifier]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showInfo];
}

-(void)reset
{
    [self setLayout:[[self class] newGridLayout] animated:YES];
}

-(RDHCollectionViewGridLayout *)currentCollectionViewLayout
{
    return (RDHCollectionViewGridLayout *) self.collectionView.collectionViewLayout;
}

-(void)setLayout:(RDHCollectionViewGridLayout *)layout animated:(BOOL)animated
{
    [self.collectionView setCollectionViewLayout:layout animated:animated];
}

-(void)showInfo
{
    NSLog(@"Current layout: %@", self.currentCollectionViewLayout);
#if RDH_RANDOM_DATA
    NSMutableString *message = [NSMutableString stringWithFormat:@"Collection view: sections=%ld\n", (long) [self.collectionView numberOfSections]];
    [message appendString:@"Layout:\n"];
    [message appendFormat:@"lineItemCount=%lu,\n", (unsigned long) self.currentCollectionViewLayout.lineItemCount];
    [message appendFormat:@"lineSpacing=%.2lf,\n", self.currentCollectionViewLayout.lineSpacing];
    [message appendFormat:@"itemSpacing=%.2lf,\n", self.currentCollectionViewLayout.itemSpacing];
    
    if (self.currentCollectionViewLayout.lineSize != 0) {
        [message appendFormat:@"lineSize=%.2lf\n", self.currentCollectionViewLayout.lineSize];
    } else if (self.currentCollectionViewLayout.lineMultiplier != 1) {
        [message appendFormat:@"lineMultiplier=%.2lf\n", self.currentCollectionViewLayout.lineMultiplier];
    } else if (self.currentCollectionViewLayout.lineExtension != 0) {
        [message appendFormat:@"lineExtension=%.2lf\n", self.currentCollectionViewLayout.lineExtension];
    } else {
        [message appendString:@"lineDimension=auto\n"];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
#endif
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
#if FIXED_LAYOUT
    return 3;
#else
    return [self.testData count];
#endif
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#if FIXED_LAYOUT
    return 3;
#else
    return [self.testData[@(section)] unsignedIntegerValue];
#endif
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDHDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RDHDemoCell reuseIdentifier] forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(RDHDemoCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *frame = [NSString stringWithFormat:@"(%.1lf, %.1lf)\n(%.1lf, %.1lf)", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height];
    [cell setText:[NSString stringWithFormat:@"%ld, %ld\n%@", (long) indexPath.section, (long) indexPath.item, frame]];
}

#pragma mark - Nav item actions

-(void)didTapResetItem
{
#if FIXED_LAYOUT
    [self.collectionView reloadData];
#else
    [self reset];
    
    [self showInfo];
#endif
}

-(void)didTapChangeScrollDirectionItem
{
    UICollectionViewScrollDirection direction = self.currentCollectionViewLayout.scrollDirection;
    switch (direction) {
        case UICollectionViewScrollDirectionHorizontal:
            direction = UICollectionViewScrollDirectionVertical;
            break;
            
        case UICollectionViewScrollDirectionVertical:
            direction = UICollectionViewScrollDirectionHorizontal;
            break;
    }
    self.currentCollectionViewLayout.scrollDirection = direction;
}

-(void)didTapChangeStartSectionOnNewLineItem
{
    self.currentCollectionViewLayout.sectionsStartOnNewLine = !self.currentCollectionViewLayout.sectionsStartOnNewLine;
}

@end
