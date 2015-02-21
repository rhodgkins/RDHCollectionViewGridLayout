//
//  RDHDemoViewController.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RDHCollectionViewGridLayout.h"

@interface RDHDemoViewController : UICollectionViewController

-(void)reset;

-(void)setLayout:(RDHCollectionViewGridLayout *)layout animated:(BOOL)animated;

@end
