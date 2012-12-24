//
//  NewQuestionViewController+KeyboardMethods.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController+KeyboardMethods.h"

@implementation NewQuestionViewController (KeyboardMethods)

- (void)customizeKeyboardOfTextView:(UITextView *)textView
{
	//自定义键盘
	UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setBarStyle:UIBarStyleBlackTranslucent];
	topView.alpha = 0;
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//	UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithTitle:@"录视频" style:UIBarButtonItemStyleBordered target:self action:@selector(videoRecord:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];    
	
	UIBarButtonItem *videoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(videoRecord:)];
	
    [topView setItems:@[videoBtn, btnSpace, doneButton] animated:YES];
    [textView setInputAccessoryView:topView];
	
	[textView becomeFirstResponder];
}

- (void)dismissKeyBoard
{
	[self.questionTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem = self.saveButton;
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

@end
