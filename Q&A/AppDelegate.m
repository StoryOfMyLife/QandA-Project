//
//  AppDelegate.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomizedNavigation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[MagicalRecord setupCoreDataStackWithStoreNamed:@"database.sqlite"];

	//customize appearance
	//tabbar
	[[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"tab_selection_indicator"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
	[[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tab_bar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(-10, 0, -10, 0)]];
	//navbar
	[[UINavigationBar appearanceWhenContainedIn:[CustomizedNavigation class], nil] setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
	//navbar buttons
	[[UIBarButtonItem appearanceWhenContainedIn:[CustomizedNavigation class], nil] setBackgroundImage:[[UIImage imageNamed:@"navbar_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[CustomizedNavigation class], nil] setBackgroundImage:[[UIImage imageNamed:@"navbar_button_pressed_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[CustomizedNavigation class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[CustomizedNavigation class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"navbar_back_button_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	//table view background
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tableView_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
	[[UITableView appearance] setBackgroundView:tableBackgroundView];
	[[UITableView appearance] setBackgroundColor:[UIColor clearColor]];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[MagicalRecord cleanUp];
}

@end
