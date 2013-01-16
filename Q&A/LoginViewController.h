//
//  LoginViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-16.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@end
