//
//  RDHDemoCell.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoCell.h"

static CGFloat const RDH_CELL_PADDING = 5;

@interface RDHDemoCell ()

@property (nonatomic, weak, readonly) UILabel *label;

@end

@implementation RDHDemoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectInset(self.contentView.bounds, RDH_CELL_PADDING, RDH_CELL_PADDING);
}

-(void)setText:(NSString *)text
{
    self.label.text = text;
}

@end
