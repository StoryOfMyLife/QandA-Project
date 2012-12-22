//
//  FirstTableViewController.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//
#define kURL @"http:59.64.176.73:8080/videoserver/video/list.do"//http:api.kivaws.org/v1/loans/search.json?status=fundraising"

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "FirstTableCell.h"

@interface FirstTableViewController : CoreDataTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger flag;

@end
