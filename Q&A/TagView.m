//
//  TagView.m
//  CoreGraphicPractice
//
//  Created by 刘廷勇 on 13-5-1.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "TagView.h"

@implementation TagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title atPoint:(CGPoint)point
{
	UIFont *font = [UIFont systemFontOfSize:15.0];
	CGSize size = [title sizeWithFont:font];
	if (size.width > 80) {
		size.width = 80;
	}
	self = [self initWithFrame:CGRectMake(point.x, point.y, size.width * 1.3, size.height * 1.3)];
	
	[self setBackgroundImage:[[UIImage imageNamed:@"tag_bg_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 14, 12, 14)] forState:UIControlStateNormal];
	[self setBackgroundImage:[[UIImage imageNamed:@"tag_bg_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 14, 12, 14)] forState:UIControlStateHighlighted];
	self.titleLabel.font = font;
	self.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self setTitle:title forState:UIControlStateNormal];
	[self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
