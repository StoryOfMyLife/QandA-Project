//
//  Question.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-20.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * answerCount;
@property (nonatomic, retain) NSString * questionKeywords;
@property (nonatomic, retain) NSString * questionID;
@property (nonatomic, retain) NSString * questionTitle;
@property (nonatomic, retain) NSString * questionWhoAnswered;
@property (nonatomic, retain) NSString * questionWhoAsked;

@end
