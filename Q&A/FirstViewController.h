//
//  FirstTableViewController.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSegmentedControl.h"
#import "FirstTableViewController.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet SDSegmentedControl *segmentedControl;

@end
