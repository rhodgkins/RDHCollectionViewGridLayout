//
//  RDHDemoViewController.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoViewController.h"

#import "RDHCollectionViewGridLayout.h"

#import "RDHDemoCell.h"
#import "RDHDemoSectionHeader.h"

#define RDH_RANDOM_DATA 0

static NSString *const CELL_IDENTIFIER = @"RDHDemoCell_Identifer";
static NSString *const SECTION_HEADER_IDENTIFIER = @"RDHDemoSectionHeader_Identifier";

static CGFloat const RDH_SECTION_DIMENSION = 44;

@interface RDHDemoViewController ()

@property (nonatomic, weak) RDHCollectionViewGridLayout *collectionViewLayout;

@property (nonatomic, copy, readonly) NSArray *testData;

@end

@implementation RDHDemoViewController

+(RDHCollectionViewGridLayout *)newGridLayout
{
    RDHCollectionViewGridLayout *layout = [RDHCollectionViewGridLayout new];
    layout.lineItemCount = RDH_RANDOM_DATA ? ((arc4random() % 5) + 1) : 3;
    layout.lineSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 10;
    layout.itemSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 10;
    layout.sectionDimension = RDH_SECTION_DIMENSION;
    layout.lineDimension = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = YES;
    layout.floatingSectionHeaders = YES;
    return layout;
}

- (instancetype)init
{
    self = [self initWithCollectionViewLayout:[[self class] newGridLayout]];
    if (self) {
        // Custom initialization
        
        NSUInteger sectionCount = RDH_RANDOM_DATA ? (arc4random() % 20) + 10 : 10;
        NSMutableArray *testData = [NSMutableArray arrayWithCapacity:sectionCount];
        for (NSUInteger i=0; i<sectionCount; i++) {
            [testData addObject:@(RDH_RANDOM_DATA ? (arc4random() % 16) : 10)];
        }
        _testData = [testData copy];
        
        UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapResetItem)];
        UIBarButtonItem *sectionHeaders = [[UIBarButtonItem alloc] initWithTitle:@"Headers" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSectionHeadersItem)];
        
        UIBarButtonItem *changeScrollDirection = [[UIBarButtonItem alloc] initWithTitle:@"Scrolling" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeScrollDirectionItem)];
        UIBarButtonItem *sectionsOnNewLine = [[UIBarButtonItem alloc] initWithTitle:@"New Line" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeStartSectionOnNewLineItem)];
        
        self.navigationItem.leftBarButtonItems = @[resetItem, sectionHeaders];
        self.navigationItem.rightBarButtonItems = @[changeScrollDirection, sectionsOnNewLine];
    }
    return self;
}

-(RDHCollectionViewGridLayout *)collectionViewLayout
{
    return (RDHCollectionViewGridLayout *) self.collectionView.collectionViewLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RDHDemoCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.collectionView registerClass:[RDHDemoSectionHeader class] forSupplementaryViewOfKind:RDHCollectionViewGridLayoutSectionHeaderKind withReuseIdentifier:SECTION_HEADER_IDENTIFIER];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showInfo];
}

-(void)showInfo
{
#if RDH_RANDOM_DATA
    NSMutableString *message = [NSMutableString stringWithFormat:@"Collection view: sections=%d\n", [self.collectionView numberOfSections]];
    [message appendString:@"Layout:\n"];
    [message appendFormat:@"lineItemCount=%d,\n", self.collectionViewLayout.lineItemCount];
    [message appendFormat:@"lineSpacing=%.2lf,\n", self.collectionViewLayout.lineSpacing];
    [message appendFormat:@"itemSpacing=%.2lf,\n", self.collectionViewLayout.itemSpacing];
    [message appendFormat:@"lineDimension=%.2lf\n", self.collectionViewLayout.lineDimension];
    
    [[[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
#endif
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.testData count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.testData[section] unsignedIntegerValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDHDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [cell setText:[NSString stringWithFormat:@"%d, %d", indexPath.section, indexPath.item]];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RDHDemoSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SECTION_HEADER_IDENTIFIER forIndexPath:indexPath];
    
    [header setText:[NSString stringWithFormat:@"Section %d", indexPath.section]];
     
    return header;
}

#pragma mark - Nav item actions

-(void)didTapResetItem
{
    [self.collectionView setCollectionViewLayout:[[self class] newGridLayout] animated:YES];
    
    [self showInfo];
}

-(void)didTapChangeScrollDirectionItem
{
    UICollectionViewScrollDirection direction = self.collectionViewLayout.scrollDirection;
    switch (direction) {
        case UICollectionViewScrollDirectionHorizontal:
            direction = UICollectionViewScrollDirectionVertical;
            break;
            
        case UICollectionViewScrollDirectionVertical:
            direction = UICollectionViewScrollDirectionHorizontal;
            break;
    }

    self.collectionViewLayout.scrollDirection = direction;
}

-(void)didTapChangeStartSectionOnNewLineItem
{
    self.collectionViewLayout.sectionsStartOnNewLine = !self.collectionViewLayout.sectionsStartOnNewLine;
}

-(void)didTapSectionHeadersItem
{
    self.collectionViewLayout.sectionDimension = self.collectionViewLayout.sectionDimension == 0 ? RDH_SECTION_DIMENSION : 0;
}

@end
