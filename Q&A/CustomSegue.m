//
//  CustomSegue.m
//  Q&A
//
//  Created by 刘廷勇 on 13-2-3.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void)perform
{
	FirstViewController *src = (FirstViewController *) self.sourceViewController;
    NewQorAViewController *dst = (NewQorAViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:1
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:nil];
}

@end
