//
//  AnswerCell.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (weak, nonatomic) IBOutlet UILabel *videoDuration;

@property (weak, nonatomic) IBOutlet UIImageView *videoPreview;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
