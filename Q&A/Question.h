//
//  Question.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Video;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * questionID;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * answerCount;
@property (nonatomic, retain) NSString * lastAnswerAuthor;
@property (nonatomic, retain) NSDate * answerTime;
@property (nonatomic, retain) Video *questionVideo;
@property (nonatomic, retain) NSSet *answers;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
