//
//  NewQuestionViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-23.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQorAViewController.h"
#import "AnswersTableViewController.h"
#import "Question+Insert.h"
#import "NewQuestionViewController+KeyboardMethods.h"
#import "NewQuestionViewController+CameraDelegateMethods.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Defines.h"

@interface NewQorAViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@end

@implementation NewQorAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	if (self.isAnswerView) {
		self.questionTextView.placeholder = NSLocalizedString(@"请输入回复:",);
	} else {
		self.questionTextView.placeholder = NSLocalizedString(@"请输入问题:",);
	}
	self.videoID = @"";
	[self customizeKeyboardOfTextView:self.questionTextView];
	
	[self.questionTableCell setBackgroundView:[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"textview_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(39, 104, 39, 104)]]];
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.questionTextView becomeFirstResponder];
}

- (void)setTags:(NSArray *)tags
{
	if (!_tags) {
		_tags = [[NSArray alloc] initWithArray:tags];
	} else {
		_tags = [tags copy];
	}
	self.tagsLabel.text = [NSString stringWithFormat:@"标签: %@", [_tags componentsJoinedByString:@","]];
}

- (IBAction)cancel:(id)sender {
//	[self.delegate dismissNewQorAViewController:self];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendAnswer:(id)sender
{
	if ([self.videoID isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有视频" message:@"请先录制视频" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
		[alert show];
	} else {
		NSDictionary *answerDic = @{@"title" : self.questionTextView.text, 
		@"video" : @{@"id" : self.videoID}, 
		@"author" : @"lty",
		@"authorName" : @"刘廷勇"};
//		NSLog(@"原始数据 ：%@", answerDic);
		NSError *err = nil;
		NSData *newAnswer = [NSJSONSerialization dataWithJSONObject:answerDic options:NSJSONWritingPrettyPrinted error:&err];
		//	NSString *str = [[NSString alloc] initWithData:newQuestion encoding:NSUTF8StringEncoding];
		//	NSLog(@"序列化后的JSON数据 ：%@", str);
		
		NSString *answerURL = [kUploadAnswerURL stringByAppendingString:self.questionID];
		[self postNewAnswer:newAnswer toServerURL:[NSURL URLWithString:answerURL]];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (IBAction)sendQuestion:(id)sender 
{
//	NSString *createTime = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
	
	if ([self.videoID isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有视频" message:@"请先录制视频" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
		[alert show];
	} else {
		NSDictionary *questionDic = @{@"title" : self.questionTextView.text, 
		@"video" : @{@"id" : self.videoID}, 
		@"author" : @"lty",
		@"authorName" : @"刘廷勇", 
		@"tags" : self.tags};
	//	NSLog(@"原始数据 ：%@", questionDic);
		NSError *err = nil;
		NSData *newQuestion = [NSJSONSerialization dataWithJSONObject:questionDic options:NSJSONWritingPrettyPrinted error:&err];
	//	NSString *str = [[NSString alloc] initWithData:newQuestion encoding:NSUTF8StringEncoding];
	//	NSLog(@"序列化后的JSON数据 ：%@", str);
		
		[self postNewQuestion:newQuestion toServerURL:[NSURL URLWithString:kUpLoadQuestionURL]];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)postNewQuestion:(NSData *)questionData toServerURL:(NSURL *)serverURL
{
//	AFHTTPClient * Client = [[AFHTTPClient alloc] initWithBaseURL:serverURL];
	
//	NSMutableURLRequest *request = [Client multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//		[formData appendPartWithFormData:questionData name:@"question.json"];
//	}];
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
	
    [request setHTTPMethod:@"POST"];
	
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    [request setHTTPBody:questionData];		
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		NSLog(@"问题发布进度：%1.0f%%", (double)totalBytesWritten / (double)totalBytesExpectedToWrite * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"问题发布成功");
		//返回videoId
		NSLog(@"返回的questionID为: %@", operation.responseString);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"上传出错: %@", error);
	}];
	[operation start];
}

- (void)postNewAnswer:(NSData *)answerData toServerURL:(NSURL *)serverURL
{
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
	
    [request setHTTPMethod:@"POST"];
	
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    [request setHTTPBody:answerData];		
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		NSLog(@"问题发布进度：%1.0f%%", (double)totalBytesWritten / (double)totalBytesExpectedToWrite * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"回答成功");
		//返回videoId
		NSLog(@"返回的answerID为: %@", operation.responseString);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"回复出错: %@", error);
	}];
	[operation start];
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
	[self setQuestionTableCell:nil];
	[self setTagsLabel:nil];
	[self setTags:nil];
	[super viewDidUnload];
}
@end
