//
//  RDHDemoCell.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoCell.h"

static CGFloat const RDH_CELL_PADDING = 0;

@interface RDHDemoCell ()

@property (nonatomic, weak, readonly) UILabel *label;

@end

@implementation RDHDemoCell

+(NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
        _label = label;
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
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
