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

#define RDH_RANDOM_DATA 1

@interface RDHDemoViewController ()

@property (nonatomic, weak, readwrite) RDHCollectionViewGridLayout *collectionViewLayout;

@property (nonatomic, copy, readonly) NSDictionary *testData;

@end

@implementation RDHDemoViewController

@synthesize collectionViewLayout = _collectionViewLayout;

+(RDHCollectionViewGridLayout *)newGridLayout
{
    RDHCollectionViewGridLayout *layout = [RDHCollectionViewGridLayout new];
    layout.lineItemCount = RDH_RANDOM_DATA ? ((arc4random() % 5) + 1) : 4;
    layout.lineSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 5;
    layout.itemSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 10;
    layout.lineDimension = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = YES;
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

-(RDHCollectionViewGridLayout *)collectionViewLayout
{
    return (RDHCollectionViewGridLayout *) self.collectionView.collectionViewLayout;
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

-(void)showInfo
{
#if RDH_RANDOM_DATA
    NSMutableString *message = [NSMutableString stringWithFormat:@"Collection view: sections=%ld\n", (long) [self.collectionView numberOfSections]];
    [message appendString:@"Layout:\n"];
    [message appendFormat:@"lineItemCount=%lu,\n", (unsigned long) self.collectionViewLayout.lineItemCount];
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
    return [self.testData[@(section)] unsignedIntegerValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDHDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RDHDemoCell reuseIdentifier] forIndexPath:indexPath];
    
    [cell setText:[NSString stringWithFormat:@"%ld, %ld", (long) indexPath.section, (long) indexPath.item]];
    
    return cell;
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

@end
