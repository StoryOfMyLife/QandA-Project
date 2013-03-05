//
//  AddingTagViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-3-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddingTagViewController;

@protocol AddingTagViewControllerDelegate <NSObject>

- (void)addingTagViewController:(AddingTagViewController *)viewController didSelectTags:(NSArray *)selectedTags;

@end

@interface AddingTagViewController : UITableViewController

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, weak) id <AddingTagViewControllerDelegate> delegate;

@end
