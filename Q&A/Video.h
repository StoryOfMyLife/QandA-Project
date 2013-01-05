//
//  Video.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Question;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSString * encode;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * cameraInfo;
@property (nonatomic, retain) Question *tookFromQuestion;
@property (nonatomic, retain) Answer *tookFromAnswer;

@end
