//
//  Answer.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, Video;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * answerID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) Question *toQuestion;
@property (nonatomic, retain) Video *answerVideo;

@end
