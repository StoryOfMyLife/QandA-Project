//
//  ThirdViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-12.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "QuestionTableViewController.h"
#import "SettingsTableViewController.h"
#import "LoginViewController.h"

@interface ThirdTableViewController ()

@end

@implementation ThirdTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#warning 这里需要设置一下背景，否则UITableview的原背景在push的时候会出现一下，原因未知
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#warning 这里push到回答页面后不能pop回来，会卡死在界面，原因未知，优先解决！！！
//这里再设置一次背景，则没有卡死的情况？？？
	if ([segue.identifier isEqualToString:@"my questions"]) {
//因为questionView.tableView setBackgroundView:后会先执行viewDidLoad方法，所以需要在之前设置其flag，因为questionView的NSfetch方法会将title设置为entity name，所以要在viewDidLoad之后再设置一次其title，所以questionView.navigationItem.title要放在questionView.tableView setBackgroundView:之后
		QuestionTableViewController *questionView = (QuestionTableViewController *)segue.destinationViewController;
		questionView.flag = 1;
		UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
		[questionView.tableView setBackgroundView:tableBackgroundView];
		questionView.navigationItem.title = @"我的提问";
	} else if ([segue.identifier isEqualToString:@"my answers"]) {
		QuestionTableViewController *questionView = (QuestionTableViewController *)segue.destinationViewController;
		questionView.flag = 0;
		UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
		[questionView.tableView setBackgroundView:tableBackgroundView];
		questionView.navigationItem.title = @"我的回答";
	} else if ([segue.identifier isEqualToString:@"system setting"]) {
		SettingsTableViewController *settingView = (SettingsTableViewController *)segue.destinationViewController;
		settingView.navigationItem.title = @"系统设置";
	} else if ([segue.identifier isEqualToString:@"personal setting"]) {
		SettingsTableViewController *settingView = (SettingsTableViewController *)segue.destinationViewController;
		settingView.navigationItem.title = @"个人设置";
	} else if ([segue.identifier isEqualToString:@"login"]) {
		UINavigationController *loginNav = (UINavigationController *)segue.destinationViewController;
		LoginViewController *loginView = (LoginViewController *)loginNav.topViewController;
		loginView.navigationItem.title = @"用户登陆";
		loginView.navigationItem.leftBarButtonItem = nil;
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];	
}

@end
