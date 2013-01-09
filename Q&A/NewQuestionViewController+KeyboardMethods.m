//
//  NewQuestionViewController+KeyboardMethods.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController+KeyboardMethods.h"
#import "NewQuestionViewController+CameraDelegateMethods.h"

@implementation NewQuestionViewController (KeyboardMethods)

- (void)customizeKeyboardOfTextView:(UITextView *)textView
{
	//自定义键盘
	UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];  
    [topView setBarStyle:UIBarStyleBlackTranslucent];
	topView.alpha = 0;
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];    
	
	UIBarButtonItem *videoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showVideoSytleChooseAction)];
	
    [topView setItems:@[videoBtn, btnSpace, doneButton] animated:YES];
    [textView setInputAccessoryView:topView];
	
	[textView becomeFirstResponder];
}

- (void)showVideoSytleChooseAction
{
	[self.questionTextView resignFirstResponder];
	UIActionSheet *videoAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"录新视频", @"从相册中选取", nil];
	videoAction.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	[videoAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self startPhotoControllerFromViewController:self usingDelegate:self];
	} else if (buttonIndex == 0) {
		[self startVideoControllerFromViewController:self usingDelegate:self];
	} else if (buttonIndex == 2) {
		[self.questionTextView becomeFirstResponder];
	}
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    //
}

- (void)dismissKeyBoard
{
	[self.questionTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem = self.saveButton;
	if ([self.questionTextView.text isEqualToString:@""] && [self.navigationItem.rightBarButtonItem.title isEqualToString:@"发送"]) {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	} else {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (self.navigationItem.rightBarButtonItem.title != @"完成") {
		self.saveButton = self.navigationItem.rightBarButtonItem;
	}
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
	self.navigationItem.rightBarButtonItem = doneButton;
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	if ([self.questionTextView.text isEqualToString:@""] && [self.navigationItem.rightBarButtonItem.title isEqualToString:@"发送"]) {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	} else {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

@end
