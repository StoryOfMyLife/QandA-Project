//
//  Answer+Insert.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "Answer+Insert.h"
#import "Video+Insert.h"

@implementation Answer (Insert)

+ (Answer *)answerWithInfo:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
	Answer *answer = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Answer"];
    request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"answerID", [data valueForKey:@"id"]];
	request.fetchLimit = 10;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"answerID" ascending:YES];	
	request.sortDescriptors = @[sortDescriptor];
	
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
		NSLog(@"ERROR: 出现重复数据!!!!");
    } else if ([matches count] == 0) {
		NSString *answerID = [data valueForKey:@"id"];
		NSString *author = [data valueForKey:@"authorName"];
		NSString *title = [data valueForKey:@"title"];
		NSTimeInterval createTimeInterval = [[data valueForKey:@"createTime"] doubleValue] / 1000;
		NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:createTimeInterval];
		
        answer = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
		
		answer.answerID = answerID;
		answer.author = author;
		answer.title = title;
		answer.createTime = createTime;
		
		NSDictionary *videoDic = [data objectForKey:@"video"];
		answer.answerVideo = [Video videoWithInfo:videoDic inManagedObjectContext:context];
		
		[[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    } else {
        answer = [matches lastObject];
    }
    return answer;
}


@end
