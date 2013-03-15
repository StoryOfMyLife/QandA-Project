//
//  NewQuestionViewController+KeyboardMethods.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "NewQorAViewController.h"
#import "AddingTagViewController.h"

@interface NewQorAViewController (KeyboardMethods) <AddingTagViewControllerDelegate>

- (void)customizeKeyboardOfTextView:(UITextView *)textView;

@end
