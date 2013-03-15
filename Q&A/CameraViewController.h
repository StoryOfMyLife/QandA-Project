//
//  CameraViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-3-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController : UIImagePickerController

- (BOOL)startCameraControllerFromViewController: (UIViewController *) controller
								  usingDelegate: (id <UIImagePickerControllerDelegate,
												  UINavigationControllerDelegate>) delegate;
- (BOOL)startPhotoControllerFromViewController: (UIViewController *) controller
								 usingDelegate: (id <UIImagePickerControllerDelegate,
												 UINavigationControllerDelegate>) delegate;
- (BOOL)startVideoControllerFromViewController: (UIViewController *) controller
								 usingDelegate: (id <UIImagePickerControllerDelegate,
												 UINavigationControllerDelegate>) delegate;

@end
