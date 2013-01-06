//
//  FirstTableViewController.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//
#define kURL @"http://218.249.255.29:9080/nesdu-webapp/api/question/page/0?size=10"//http:api.kivaws.org/v1/loans/search.json?status=fundraising"

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "QuestionCell.h"

@interface QuestionTableViewController : CoreDataTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger flag;

@end
