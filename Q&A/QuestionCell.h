//
//  FirstTableCell.h
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *questionID;
@property (strong, nonatomic) IBOutlet UILabel *questionTitle;
@property (strong, nonatomic) IBOutlet UILabel *questionKeywords;
@property (strong, nonatomic) IBOutlet UILabel *questionAskedFrom;
@property (strong, nonatomic) IBOutlet UILabel *questionAnsweredFrom;
@property (strong, nonatomic) IBOutlet UILabel *answerCount;

@end
