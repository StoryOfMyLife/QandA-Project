//
//  SecondTableViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//
#define kURL @"http:59.64.176.73:8080/videoserver/video/list.do"

#import <UIKit/UIKit.h>
#import "FirstTableCell.h"
#import "CoreDataTableViewController.h"

@interface SecondTableViewController : CoreDataTableViewController <UITableViewDataSource, UITableViewDelegate>

@end
