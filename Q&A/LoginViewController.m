//
//  LoginViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-16.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Defines.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.loginButton.tintColor = [UIColor clearColor];
	self.cancelButton.tintColor = [UIColor clearColor];

	[self.loginButton setBackgroundImage:[[UIImage imageNamed:@"round_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 62, 14, 62)] forState:UIControlStateNormal];
	[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"round_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 62, 14, 62)] forState:UIControlStateNormal];
	[self.loginButton setBackgroundImage:[[UIImage imageNamed:@"round_button_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 62, 14, 62)] forState:UIControlStateHighlighted];
	[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"round_button_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 62, 14, 62)] forState:UIControlStateHighlighted];
}
- (IBAction)dismissView:(id)sender 
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)turnToNext:(id)sender
{
	[self.password becomeFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender 
{
	[self.username resignFirstResponder];
	[self.password resignFirstResponder];
}

- (IBAction)login:(id)sender
{
	[self dismissKeyboard:nil];
	if ([self.username.text isEqualToString:@""] && [self.username.text isEqualToString:@""]) {
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"没有信息"
													   message:@"请输入用户信息"
													  delegate:NULL 
											 cancelButtonTitle:@"OK" 
											 otherButtonTitles:NULL];
		
		[alert show];
	} else {
		NSString *loginInfo = [NSString stringWithFormat:@"username=%@&password=%@", self.username.text, self.password.text];
		NSString *loginURL = [kLoginURL stringByAppendingString:loginInfo];
		[self loginToServerURL:[NSURL URLWithString:loginURL]];
	}
}

- (void)loginToServerURL:(NSURL *)serverURL
{
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"登陆成功");
		//返回登陆信息：若成功，则返回key值；若失败，则返回usernameError或者passwordError，以此来判断
		NSLog(@"返回的login信息为: %@", operation.responseString);
		if ([operation.responseString isEqualToString:@"usernameError"]) {
			UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"登陆失败"
                                                           message:@"用户名错误"
                                                          delegate:NULL 
                                                 cancelButtonTitle:@"OK" 
                                                 otherButtonTitles:NULL];
			
            [alert show];
		} else if ([operation.responseString isEqualToString:@"passwordError"]) {
			UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"登陆失败"
                                                           message:@"密码错误"
                                                          delegate:NULL 
                                                 cancelButtonTitle:@"OK" 
                                                 otherButtonTitles:NULL];
			
            [alert show];
		} else {
			[self dismissView:nil];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"登陆出错: %@", error);
	}];
	[operation start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setUsername:nil];
	[self setPassword:nil];
    [self setLoginButton:nil];
    [self setCancelButton:nil];
	[super viewDidUnload];
}

@end
