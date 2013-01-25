//
//  NewQuestionViewController+CameraDelegateMethods.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController+CameraDelegateMethods.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Defines.h"

@implementation NewQorAViewController (CameraDelegateMethods)

- (BOOL)startCameraControllerFromViewController:(UIViewController *) controller
								  usingDelegate:(id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate 
{	
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) ||
		(delegate == nil) ||
		(controller == nil)) {
		return NO;
	}
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;	
	
    cameraUI.delegate = delegate;
	
	[controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (BOOL)startPhotoControllerFromViewController:(UIViewController *) controller
								 usingDelegate:(id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate 
{	
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) ||
		(delegate == nil) ||
		(controller == nil)) {
		return NO;
	}
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
	
	cameraUI.mediaTypes = @[(NSString *)kUTTypeImage];
	
    cameraUI.delegate = delegate;
	
	[controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (BOOL)startVideoControllerFromViewController:(UIViewController*) controller
								 usingDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate 
{	
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) ||
		(delegate == nil) ||
		(controller == nil)) {
		return NO;
	}
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	cameraUI.videoQuality = UIImagePickerControllerQualityTypeMedium;
	cameraUI.videoMaximumDuration = 60;
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
	
	cameraUI.mediaTypes = @[(NSString *)kUTTypeMovie];
	
    cameraUI.delegate = delegate;
		
	[controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}



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
		NSString *duration = [NSString stringWithFormat:@"%1.0fs", moviePlayer.duration];
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


@end
