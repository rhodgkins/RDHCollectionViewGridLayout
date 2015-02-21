//
//  RDHAppDelegate.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 07/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDHDemoViewController;

@interface RDHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) RDHDemoViewController *demoViewController;

@end
