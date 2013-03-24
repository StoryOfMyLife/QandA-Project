//
//  PaintingView.m
//  CoreGraphicPractice
//
//  Created by 刘廷勇 on 13-3-4.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ProfileView.h"

#define CORNER_RADIUS 9.0

@interface ProfileView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ProfileView

#pragma mark - Initialization

- (UIImageView *)imageView
{
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.image = [UIImage imageNamed:@"ProfileNormal"];
		[self addSubview:_imageView];
	}
	return _imageView;
}

- (void)setProfileImage:(UIImage *)profileImage
{
	if (_profileImage != profileImage) {
		_profileImage = profileImage;	
		self.imageView.image = _profileImage;
	}
}

- (void)setup
{
    // do initialization here
	[self setupDefaultImage];
	self.backgroundColor = [UIColor whiteColor];
	self.clipsToBounds = YES;
}

- (void)setupDefaultImage
{
	UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:self.bounds];
	defaultImage.image = [UIImage imageNamed:@"ProfileNormal"];
	defaultImage.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:defaultImage];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (id)initWithRoundedRect:(CGRect)frame
{
	self = [self initWithFrame:frame];
	self.layer.cornerRadius = CORNER_RADIUS;
	self.layer.borderWidth = 0.5;
	self.layer.borderColor = [UIColor grayColor].CGColor;
	return self;
}

- (id)initWithCircleInRect:(CGRect)rect
{
	CGRect frame;
	if (rect.size.height >= rect.size.width) {
		frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.width);
	} else {
		frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.height);
	}
	self = [self initWithFrame:frame];
	self.layer.cornerRadius = frame.size.width / 2;
	self.layer.borderWidth = 0.5;
	self.layer.borderColor = [UIColor grayColor].CGColor;
	return self;
}

//- (void)adrawRect:(CGRect)rect
//{
//	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
//	[roundedRect addClip];
//	
//	if (self.profileImage) {
//		[self.profileImage drawInRect:self.bounds];
//	} else {
//		UIImage *profile = [UIImage imageNamed:@"ProfileNormal"];
//		[profile drawInRect:self.bounds];
//	}
//	
//	[[UIColor blackColor] setStroke];
//    [roundedRect stroke];
//}


@end
