//
//  NewQuestionViewController.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-23.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "GCPlaceholderTextView.h"

@interface NewQuestionViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *questionTextView;

@property (nonatomic, strong) UIBarButtonItem *saveButton;

@end
