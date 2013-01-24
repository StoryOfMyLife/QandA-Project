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
	
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableView_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"my questions"]) {
		QuestionTableViewController *questionView = (QuestionTableViewController *)segue.destinationViewController;
		questionView.navigationItem.title = @"我的提问";
	} else if ([segue.identifier isEqualToString:@"my answers"]) {
		QuestionTableViewController *questionView = (QuestionTableViewController *)segue.destinationViewController;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"---------------个人信息---------------";
	} else if (section == 1) {
		return @"-----------------设置------------------";
	} else return nil;
}

@end
