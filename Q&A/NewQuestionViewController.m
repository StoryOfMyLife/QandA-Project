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

@interface NewQuestionViewController ()
@end

@implementation NewQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self customizeKeyboardOfTextView:self.questionTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.questionTextView becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
	Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	//		question = [Question MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	question.questionTitle = self.questionTextView.text;
	question.questionKeywords = @"【词1,词2,词3】";
	NSString *date = (NSString *)[NSDate date];
	question.questionWhoAsked = [NSString stringWithFormat:@"发布人：刘廷勇  %@", date];
	question.questionWhoAnswered = @"最后回答：还没人回答";
	question.answerCount = @"(0)";
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
