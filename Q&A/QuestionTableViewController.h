//
//  FirstTableViewController.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCell.h"

@interface QuestionTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger flag;

@property (nonatomic ,strong) NSPredicate *predicate;

@end
