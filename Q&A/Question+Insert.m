//
//  Question+Insert.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-20.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "Question+Insert.h"
#import "Video+Insert.h"
#import "Answer+Insert.h"

@implementation Question (Insert)

+ (Question *)questionWithInfo:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
	Question *question = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"questionID", [data valueForKey:@"id"]];
	request.fetchLimit = 10;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionID" ascending:YES];	
	request.sortDescriptors = @[sortDescriptor];
						 
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
		NSLog(@"ERROR: 出现重复数据!!!!");
    } else if ([matches count] == 0) {
		NSString *questionID = [data valueForKey:@"id"];
		
		NSString *author = [data valueForKey:@"authorName"];
		
		NSString *lastAnswerAuthor = [data valueForKey:@"lastAnswerAuthor"];
		
		NSString *title = [data valueForKey:@"title"];
		
		NSArray *tags = (NSArray *)[data objectForKey:@"tags"];
		NSString *tag0 = tags[0];
		NSString *tag1 = tags[1];
		NSString *tag2 = tags[2];
		NSString *keywords = [[NSString alloc] initWithFormat:@"【%@, %@, %@】", tag0, tag1, tag2];
		
		NSTimeInterval createTimeInterval = [[data valueForKey:@"createTime"] doubleValue] / 1000;
		NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:createTimeInterval];
		
		NSTimeInterval updateTimeInterval = [[data valueForKey:@"updateTime"] doubleValue] / 1000;
		NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:updateTimeInterval];
		
		NSTimeInterval answerTimeInterval = [[data valueForKey:@"answerTime"] doubleValue] / 1000;
		NSDate *answerTime = [NSDate dateWithTimeIntervalSince1970:answerTimeInterval];
		
		NSInteger answerCount = [[data valueForKey:@"countAnswer"] intValue];
		
        question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];

		question.title = title;
		question.author = author;
		question.questionID = questionID;
		question.createTime = createTime;
		question.updateTime = updateTime;
		question.tags = keywords;
		question.answerCount = [NSNumber numberWithInteger:answerCount];
		question.answerTime = answerTime;
		question.lastAnswerAuthor = lastAnswerAuthor;
		
		NSDictionary *videoDic = [data objectForKey:@"video"];
		question.questionVideo = [Video videoWithInfo:videoDic inManagedObjectContext:context];
		
		NSArray *answersArray = [data objectForKey:@"answers"];
		NSMutableSet *answersSet = [NSMutableSet setWithCapacity:[answersArray count]];
		for (NSDictionary *answerDic in answersArray) {
			Answer *answer = [Answer answerWithInfo:answerDic inManagedObjectContext:context];
			[answersSet addObject:answer];
		}
		question.answers = answersSet;
		
		[[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    } else {
        question = [matches lastObject];
    }
    return question;
}

@end
