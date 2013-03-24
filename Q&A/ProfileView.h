//
//  PaintingView.h
//  CoreGraphicPractice
//
//  Created by 刘廷勇 on 13-3-4.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIControl

@property (nonatomic, strong) UIImage *profileImage;

- (id)initWithRoundedRect:(CGRect)frame;

- (id)initWithCircleInRect:(CGRect)rect;

@end
