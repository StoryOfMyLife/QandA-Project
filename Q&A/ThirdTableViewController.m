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
#import "UITabBarController+HideTabBar.h"
#import "Account.h"
#import "ProfileView.h"
#import "CameraViewController.h"

@interface ThirdTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CameraViewController *cameraViewController;

@property (nonatomic, strong) Account *account;

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

- (Account *)account
{
	return [Account sharedAcount];
}

- (ProfileView *)profileView
{
	if (!_profileView) {
//		_profileView = [[ProfileView alloc] initWithRoundedRect:CGRectMake(10, 10, 50, 50)];
		_profileView = [[ProfileView alloc] initWithCircleInRect:CGRectMake(10, 10, 50, 50)];
		[_profileView addTarget:self action:@selector(editProfileImage) forControlEvents:UIControlEventTouchUpInside];
		_profileView.profileImage = self.account.userProfileImage;
		[self.tableView addSubview:_profileView];
	}
	return _profileView;
}

- (CameraViewController *)cameraViewController
{
	if (!_cameraViewController) {
		_cameraViewController = [[CameraViewController alloc] init];
	}
	return _cameraViewController;
}
#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//这里需要设置一下背景，否则UITableview的原背景在push的时候会出现一下，原因未知
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
	[self profileView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}

- (void)viewDidUnload {
	[self setProfileView:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	NSLog(@"ThirdView did receive memory warning!");
}

#pragma mark - UIActionSheet Delegate
- (IBAction)editProfileImage
{
	if (self.profileView.profileImage) {
		UIActionSheet *imageAction = [[UIActionSheet alloc] initWithTitle:@"编辑靓照" delegate:self cancelButtonTitle:@"下次再说" destructiveButtonTitle:@"删掉靓照" otherButtonTitles:@"重照一张", @"重选一张", nil];
		imageAction.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		
//		[imageAction showFromTabBar:self.tabBarController.tabBar];
		[imageAction showInView:[UIApplication sharedApplication].keyWindow];
	} else {
		UIActionSheet *imageAction = [[UIActionSheet alloc] initWithTitle:@"添加靓照" delegate:self cancelButtonTitle:@"下次再说" destructiveButtonTitle:nil otherButtonTitles:@"照一张", @"选一张", nil];
		imageAction.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[imageAction showInView:[UIApplication sharedApplication].keyWindow];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (self.profileView.profileImage) {
		if (0 == buttonIndex) {
			self.account.userProfileImage = nil;
			self.profileView.profileImage = nil;
		} else if (1 == buttonIndex) {
			[self.cameraViewController startCameraControllerFromViewController:self usingDelegate:self];
		} else if (2 == buttonIndex) {
			[self.cameraViewController startPhotoControllerFromViewController:self usingDelegate:self];
		}
	} else {
		if (0 == buttonIndex) {
			[self.cameraViewController startCameraControllerFromViewController:self usingDelegate:self];
		}
		if (1 == buttonIndex) {
			[self.cameraViewController startPhotoControllerFromViewController:self usingDelegate:self];
		}
	}	
}

#pragma mark - camera delegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{	
	[self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
	
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
		
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
    }
	self.account.userProfileImage = imageToSave;
	self.profileView.profileImage = imageToSave;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//这里push到回答页面后不能pop回来，会卡死在界面，原因未知，优先解决！！！
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
		Account *account = [Account sharedAcount];
		account.loginedIn = NO;
		
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
