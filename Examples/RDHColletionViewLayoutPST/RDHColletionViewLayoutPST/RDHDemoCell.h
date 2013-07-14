//
//  RDHDemoCell.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <PSTCollectionView/PSTCollectionViewCell.h>

@interface RDHDemoCell : PSTCollectionViewCell

+(NSString *)reuseIdentifier;

-(void)setText:(NSString *)text;

@end
