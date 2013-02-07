//
//  SearchTableViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-25.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
