//
//  FirstTableViewData.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-18.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * questionNumber;
@property (nonatomic, retain) NSString * questionTitle;
@property (nonatomic, retain) NSString * questionKeywords;
@property (nonatomic, retain) NSString * questionWhoAsked;
@property (nonatomic, retain) NSString * questionWhoAnswered;
@property (nonatomic, retain) NSNumber * answerCount;

@end
