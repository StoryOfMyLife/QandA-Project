//
//  NewQuestionViewController+CameraDelegateMethods.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQuestionViewController+CameraDelegateMethods.h"

@implementation NewQuestionViewController (CameraDelegateMethods)

- (BOOL)startCameraControllerFromViewController: (UIViewController*) controller
								  usingDelegate: (id <UIImagePickerControllerDelegate,
												  UINavigationControllerDelegate>) delegate 
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
    cameraUI.allowsEditing = NO;
	
	//	cameraUI.mediaTypes = @[(NSString *)kUTTypeMovie];
	
    cameraUI.delegate = delegate;
	
	[controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
	[self dismissViewControllerAnimated:YES completion:^{
		NSLog(@"%@", self);
		NSLog(@"%@", [picker parentViewController]);
	}];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
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
		
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
		
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
        }
    }
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
