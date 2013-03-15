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
#import "NewQorAViewController+KeyboardMethods.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Defines.h"

@interface NewQorAViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@end

@implementation NewQorAViewController

- (CameraViewController *)cameraViewController
{
	if (!_cameraViewController) {
		_cameraViewController = [[CameraViewController alloc] init];
		_cameraViewController.delegate = self;
	}
	return _cameraViewController;
}

- (void)setTags:(NSArray *)tags
{
	_tags = tags;
	self.tagsLabel.text = [NSString stringWithFormat:@"标签: %@", [_tags componentsJoinedByString:@","]];
}

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

#pragma mark - navbar button method

- (IBAction)cancel:(id)sender 
{
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
	[self.cameraViewController startCameraControllerFromViewController:self usingDelegate:self];
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
		
        editedImage = (UIImage *) [info objectForKey:
								   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
									 UIImagePickerControllerOriginalImage];
		
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
		
		// Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil , nil);
    }
	
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
		
		//        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
		NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSData *videoData = [NSData dataWithContentsOfURL:movieURL];
#warning 这里好像只能获取url在document文件夹或服务器的movie
		MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
		NSString *duration = [NSString stringWithFormat:@"%.0fs", moviePlayer.duration];
		NSLog(@"%f", moviePlayer.duration);
		
		NSString *cameraInfo;
		if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
			cameraInfo = @"ios.front";
		} else {
			cameraInfo = @"ios.behind";
		}
		
		NSString *paramString = [NSString stringWithFormat:@"?duration=%@&encode=h.264&fileType=mov&cameraInfo=%@", duration, cameraInfo];
		NSURL *uploadURL = [NSURL URLWithString:kUpLoadVideoURL];
		
		[self uploadVideo:videoData toServerURL:uploadURL withParameterPath:paramString];
		
		//保存到本地路径
		//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, nil);
		//		NSString *documentPath = paths[0];
		//		documentPath = [documentPath stringByAppendingPathComponent:@"recordVideo"];
		//		[videoData writeToFile:documentPath atomically:YES];
		
		//		//保存到相册
		//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
		//            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
		//        }
    }
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadVideo:(NSData *)videoData toServerURL:(NSURL *)serverURL withParameterPath:(NSString *)paramString
{
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	AFHTTPClient * Client = [[AFHTTPClient alloc] initWithBaseURL:serverURL];
	NSMutableURLRequest *request = [Client multipartFormRequestWithMethod:@"POST" path:paramString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFileData:videoData name:@"file" fileName:@"iosVideo.mov" mimeType:@"video/quickTime"];
	}];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		NSLog(@"视频上传进度：%1.0f%%", (double)totalBytesWritten / (double)totalBytesExpectedToWrite * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"视频上传成功");
		//返回videoId
		NSLog(@"返回的videoID为: %@", operation.responseString);
		self.videoID = operation.responseString;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"上传出错: %@", error);
	}];
	[operation start];
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
