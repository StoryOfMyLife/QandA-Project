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
	self.questionTextView.placeholder = NSLocalizedString(@"请输入问题:",);
	[self customizeKeyboardOfTextView:self.questionTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.questionTextView becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
	Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	//		question = [Question MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	question.title = self.questionTextView.text;
	question.tags = @"【关键词1,关键词2,关键词3】";
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *date = [dateFormatter stringFromDate:[NSDate date]];
	question.author = [NSString stringWithFormat:@"发布人：刘廷勇  %@", date];
	question.lastAnswerAuthor = @"最后回答：还没人回答";
	question.answerCount = 0;
	question.questionID = @"000";
	
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_save];

	[self dismissViewControllerAnimated:YES completion:nil];
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
