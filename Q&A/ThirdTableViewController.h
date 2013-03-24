//
//  ThirdViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-12.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileView;
@interface ThirdTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet ProfileView *profileView;

- (IBAction)editProfileImage;

@end
