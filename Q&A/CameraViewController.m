//
//  CameraViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-3-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "CameraViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Defines.h" 

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startCameraControllerFromViewController:(UIViewController *) controller
								  usingDelegate:(id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate 
{	
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) ||
		(delegate == nil) ||
		(controller == nil)) {
		return NO;
	}
	
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
//    self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	self.mediaTypes = @[(NSString *)kUTTypeImage];;
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    self.allowsEditing = YES;	
	
    self.delegate = delegate;
	
	[controller presentViewController:self animated:YES completion:nil];
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
	
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    self.allowsEditing = YES;
	
	self.mediaTypes = @[(NSString *)kUTTypeImage];
	
    self.delegate = delegate;
	
	[controller presentViewController:self animated:YES completion:nil];
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
	
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	self.videoQuality = UIImagePickerControllerQualityTypeMedium;
	self.videoMaximumDuration = 60;
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    self.allowsEditing = YES;
	
	self.mediaTypes = @[(NSString *)kUTTypeMovie];
	
    self.delegate = delegate;
	
	[controller presentViewController:self animated:YES completion:nil];
    return YES;
}

@end
