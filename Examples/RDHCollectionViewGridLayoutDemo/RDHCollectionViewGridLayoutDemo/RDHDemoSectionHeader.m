//
//  RDHDemoSectionHeader.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 07/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoSectionHeader.h"

static CGFloat const RDH_HEADER_PADDING = 8;

@interface RDHDemoSectionHeader ()

@property (nonatomic, weak, readonly) UILabel *label;

@end

@implementation RDHDemoSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
        
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectInset(self.bounds, RDH_HEADER_PADDING, RDH_HEADER_PADDING);
}

-(void)setText:(NSString *)text
{
    self.label.text = text;
}

@end
