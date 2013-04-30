//
//  UITabBarController+HideTabBar.m
//  NPS
//
//  Created by Carlos Oliva on 04-02-12.
//  Copyright (c) 2012 iDev. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"

#define kAnimationDuration .3

@implementation UITabBarController (HideTabBar)

- (void)makeTabbarOriginal
{
	UIView *contentView;
	
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
	
	CGRect tabbarFrame = self.tabBar.frame;
	
	if (tabbarFrame.origin.y > self.view.bounds.size.height - tabbarFrame.size.height ||
		contentView.frame.size.height > self.view.bounds.size.height - tabbarFrame.size.height) {
		tabbarFrame.origin.y = self.view.bounds.size.height - tabbarFrame.size.height;
		self.tabBar.frame = tabbarFrame;
		self.tabBar.alpha = 1;
		contentView.frame = CGRectMake(self.view.bounds.origin.x,
									   self.view.bounds.origin.y,
									   self.view.bounds.size.width,
									   self.view.bounds.size.height - tabbarFrame.size.height);
	}
}

- (void)makeTabbarInvisible:(BOOL)invisible animated:(BOOL)animated
{
	if ( [self.view.subviews count] < 2 ) {
        return;
    }
	
	static BOOL enable = YES;
	
    UIView *contentView;
	
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
	
	NSTimeInterval duration = animated ? 0.3 : 0.0;
	
	UIView *tabbar = self.tabBar;
	
	if (enable) {
		if (invisible && tabbar.alpha > 0) {
			enable = NO;
			contentView.frame = self.view.bounds;
			[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				tabbar.alpha = 0;
			} completion:^(BOOL finished) {
				enable = YES;
			}];
		} else if (!invisible && tabbar.alpha == 0) {
			enable = NO;
			[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				tabbar.alpha = 1;
			} completion:^(BOOL finished) {
				enable = YES;
			}];
		}
	}
}

- (void)makeTabbarHidden:(BOOL)hide animated:(BOOL)animated
{
    // Custom code to hide TabBar
    if ( [self.view.subviews count] < 2 ) {
        return;
    }
	
	static BOOL enable = YES;
	
    UIView *contentView;
	
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
	
	CGRect tabbarFrame = self.tabBar.frame;
	
	NSTimeInterval duration = animated ? 0.3 : 0.0;
	
	if (enable) {
		if (hide && tabbarFrame.origin.y < self.view.bounds.size.height) {
			enable = NO;
			contentView.frame = self.view.bounds;
			tabbarFrame.origin.y += tabbarFrame.size.height;
			[UIView animateWithDuration:duration animations:^{
				self.tabBar.frame = tabbarFrame;
			} completion:^(BOOL finished) {
				enable = YES;
			}];
		} else if (!hide && tabbarFrame.origin.y >= self.view.bounds.size.height) {
			enable = NO;
			tabbarFrame.origin.y -= tabbarFrame.size.height;
			//		contentView.frame = self.tabBarController.view.bounds;
			[UIView animateWithDuration:duration animations:^{
				self.tabBar.frame = tabbarFrame;
			} completion:^(BOOL finished) { //这里是导致快速上拉到顶端出现刷新时view跳动的原因，不用将contentView.size设置回去！！
				//			if (finished) {
				//				contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
				//										   self.tabBarController.view.bounds.origin.y,
				//										   self.tabBarController.view.bounds.size.width,
				//										   self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
				//			}
				enable = YES;
			}];	
		}
	}
    
}

//- (BOOL)isTabBarHidden {
//	CGRect viewFrame = self.view.frame;
//	CGRect tabBarFrame = self.tabBar.frame;
//	return tabBarFrame.origin.y >= viewFrame.size.height;
//}
//
//
//- (void)setTabBarHidden:(BOOL)hidden {
//	[self setTabBarHidden:hidden animated:NO];
//}
//
//
//- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
//	BOOL isHidden = self.tabBarHidden;
//	if(hidden == isHidden)
//		return;
////	NSLog(@"%@", [self.view subviews]);
//	UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
//	if(transitionView == nil) {
//		NSLog(@"could not get the container view!");
//		return;
//	}
//	CGRect viewFrame = self.view.frame;
//	CGRect tabBarFrame = self.tabBar.frame;
//	CGRect containerFrame = transitionView.frame;
//	tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
//	containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
//	[UIView animateWithDuration:kAnimationDuration 
//					 animations:^{
//						 transitionView.frame = containerFrame;
//						 self.tabBar.frame = tabBarFrame;
//					 }
//	 ];
//}


@end
