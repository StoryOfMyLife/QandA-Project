//
//  NewQuestionViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-23.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController.h"
#import "Question+Insert.h"
#import "NewQuestionViewController+KeyboardMethods.h"
#import "NewQuestionViewController+CameraDelegateMethods.h"

@interface NewQuestionViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation NewQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self customizeKeyboard];
}

- (IBAction)cancel:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
	Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	//		question = [Question MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	question.questionTitle = self.questionTextView.text;
	question.questionKeywords = @"1, 2, 3";
	question.questionWhoAsked = @"刘廷勇的问题";
	question.questionWhoAnswered = @"还没人回答";
	question.answerCount = @"0";
	question.questionID = @"000";
	
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_save];

	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)videoRecord:(id)sender 
{
	[self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setQuestionTextView:nil];
	[super viewDidUnload];
}
@end
