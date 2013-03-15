//
//  LoginViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-16.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@protocol LoginViewDelegate <NSObject>

@optional
- (void)loginViewDidLoginWithLoginID:(NSString *)loginID;

@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) id <LoginViewDelegate> delegate;

- (IBAction)login:(id)sender;
@end
