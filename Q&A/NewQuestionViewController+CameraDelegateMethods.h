//
//  NewQuestionViewController+CameraDelegateMethods.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQorAViewController.h"

@interface NewQorAViewController (CameraDelegateMethods)

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
