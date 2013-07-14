//
//  RDHDemoCell.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDHDemoCell : UICollectionViewCell

+(NSString *)reuseIdentifier;

-(void)setText:(NSString *)text;

@end
