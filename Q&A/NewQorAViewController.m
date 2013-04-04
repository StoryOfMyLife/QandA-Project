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
#import "JSON.h"
#import "MBProgressHUD.h"

@interface NewQorAViewController () <MBProgressHUDDelegate>

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) NSData *videoData;

@property (nonatomic, weak) IBOutlet UILabel *tagsLabel;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

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
	[self.questionTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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
		
		NSError *err = nil;
		NSData *newAnswer = [NSJSONSerialization dataWithJSONObject:answerDic options:NSJSONWritingPrettyPrinted error:&err];
		
		NSString *answerURL = [kUploadAnswerURL stringByAppendingString:self.questionID];
		
		[JSON postJSONData:newAnswer toServerURL:[NSURL URLWithString:answerURL]];
		
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
		NSArray *tags = [self.tags count] > 0 ? self.tags : @[];
		NSDictionary *questionDic = @{@"title" : self.questionTextView.text, 
									  @"video" : @{@"id" : self.videoID}, 
									  @"author" : @"lty",
									  @"authorName" : @"刘廷勇", 
									  @"tags" : tags};
		NSError *err = nil;
		NSData *newQuestion = [NSJSONSerialization dataWithJSONObject:questionDic options:NSJSONWritingPrettyPrinted error:&err];

		[JSON postJSONData:newQuestion toServerURL:[NSURL URLWithString:kUpLoadQuestionURL]];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
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
		self.videoData = [NSData dataWithContentsOfURL:movieURL];
		
		UIImage *videoThumbnail = [self getThumbnailFromURL:movieURL];
		self.imageData = UIImagePNGRepresentation(videoThumbnail);
		
//这里好像只能获取url在document文件夹或服务器的movie		
		AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:movieURL];
		CMTime duration = playerItem.duration;
		int seconds = floor(CMTimeGetSeconds(duration));
		
		
		NSString *cameraInfo;
		if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
			cameraInfo = @"ios.front";
		} else {
			cameraInfo = @"ios.behind";
		}
		
		NSString *paramString = [NSString stringWithFormat:@"?duration=%@s&encode=h.264&fileType=mov&cameraInfo=%@", [NSNumber numberWithInt:seconds], cameraInfo];
		NSURL *uploadURL = [NSURL URLWithString:kUpLoadVideoURL];
		
		[self uploadVideo:self.videoData toServerURL:uploadURL withParameterPath:paramString];
		
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

- (UIImage *)getThumbnailFromURL:(NSURL *)url
{
	MPMoviePlayerController *movieViewController = [[MPMoviePlayerController alloc] initWithContentURL:url];
	UIImage *originImage = [movieViewController thumbnailImageAtTime:1 timeOption:MPMovieTimeOptionNearestKeyFrame];
	NSData *imageData = UIImageJPEGRepresentation(originImage, 0);
	UIImage *compressedImage = [UIImage imageWithData:imageData];
	return compressedImage;
}

- (void)uploadVideo:(NSData *)videoData toServerURL:(NSURL *)serverURL withParameterPath:(NSString *)paramString
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:serverURL];
	NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:paramString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFileData:videoData name:@"file" fileName:@"iosVideo.mov" mimeType:@"video/quickTime"];
	}];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		double uploadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
		self.progressHUD.progress = uploadProgress;
		self.progressHUD.detailsLabelText = [NSString stringWithFormat:@"%1.0f%%", uploadProgress * 100];
		NSLog(@"视频上传进度：%1.0f%%", uploadProgress * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		NSLog(@"视频上传成功");
		//返回videoId
		NSLog(@"返回的videoID为: %@", operation.responseString);
		self.videoID = operation.responseString;
		
		if (self.videoID) {
			NSString *imageURL = [kUpLoadImageURL stringByAppendingString:self.videoID];
			NSURL *uploadURL = [NSURL URLWithString:imageURL];
			[self uploadImage:self.imageData toServerURL:uploadURL withParameterPath:nil];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"上传出错: %@", error);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}];
	[operation start];
	
	self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	self.progressHUD.mode = MBProgressHUDModeDeterminate;
	self.progressHUD.minSize = CGSizeMake(135.f, 135.f);
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"视频上传中...";
	self.progressHUD.yOffset = -50;
	self.progressHUD.dimBackground = YES;
}

- (void)uploadImage:(NSData *)imageData toServerURL:(NSURL *)serverURL withParameterPath:(NSString *)paramString
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:serverURL];
	NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:paramString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFileData:imageData name:@"file" fileName:@"iosImage.png" mimeType:@"image/png"];
	}];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		double uploadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
		NSLog(@"预览图上传进度：%1.0f%%", uploadProgress * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		NSLog(@"截图上传: %@", operation.responseString);
		self.imageData = nil;
		{
			self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
			self.progressHUD.mode = MBProgressHUDModeCustomView;
			self.progressHUD.detailsLabelText = @"";
			self.progressHUD.labelText = @"完成";
			[self.progressHUD hide:YES afterDelay:2];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"上传出错: %@", error);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}];
	[operation start];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
	[self.questionTextView becomeFirstResponder];
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
	[self setProgressHUD:nil];
	[super viewDidUnload];
}
@end
