//
//  RDHAppDelegate.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 07/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHAppDelegate.h"

#import "RDHDemoViewController.h"

@implementation RDHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RDHDemoViewController *vc = [RDHDemoViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.demoViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
