//
//  NewQuestionViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-23.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController.h"
#import "Question+Insert.h"

@interface NewQuestionViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *saveButton;

@end

@implementation NewQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//自定义键盘
	UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];    
    
    [topView setItems:@[btnSpace, doneButton]];
    [self.questionTextView setInputAccessoryView:topView];
	
	[self.questionTextView becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
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
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)videoRecord:(id)sender 
{
	UIImagePickerController *myImagePicker = [[UIImagePickerController alloc] init];
	myImagePicker.delegate = self;
	myImagePicker.allowsEditing = YES;
	[self presentModalViewController:myImagePicker animated:YES];
}

- (void)dismissKeyBoard
{
	[self.questionTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	self.saveButton = self.navigationItem.rightBarButtonItem;
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)]; 
	self.navigationItem.rightBarButtonItem = doneButton;
	return YES;
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
