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
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 3;
        [self.contentView addSubview:label];
        _label = label;
        
        // Pin to superview edge with RDH_CELL_PADDING inset
        [self pinView:label toContentViewAttribute:NSLayoutAttributeLeft withPadding:RDH_CELL_PADDING];
        [self pinView:label toContentViewAttribute:NSLayoutAttributeTop withPadding:RDH_CELL_PADDING];
        [self pinView:label toContentViewAttribute:NSLayoutAttributeRight withPadding:RDH_CELL_PADDING];
        [self pinView:label toContentViewAttribute:NSLayoutAttributeBottom withPadding:RDH_CELL_PADDING];
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    }
    return self;
}

-(void)pinView:(UIView *)view toContentViewAttribute:(NSLayoutAttribute)attribute withPadding:(CGFloat)padding
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute multiplier:1 constant:padding]];
}

-(void)setText:(NSString *)text
{
    self.label.text = text;
}

@end
