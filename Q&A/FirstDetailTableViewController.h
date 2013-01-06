//
//  FirstDetailTableViewController.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CoreDataTableViewController.h"
#import "Question+Insert.h"

@interface FirstDetailTableViewController : CoreDataTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Question *question;

@end
