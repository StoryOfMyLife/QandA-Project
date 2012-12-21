//
//  Question+Insert.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-20.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "Question+Insert.h"

@implementation Question (Insert)

+ (Question *)insertNewQuestion:(NSDictionary *)newQuestion inManagedObjectContext:(NSManagedObjectContext *)context
{
	Question *question = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"questionID", [newQuestion objectForKey:@"videoID"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"questionID" ascending:YES];	
	request.sortDescriptors = @[sortDescriptor];
						 
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
		NSLog(@"ERROR: 出现重复数据!!!!");
    } else if ([matches count] == 0) {
        question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
        question.questionTitle = [newQuestion objectForKey:@"title"];
		question.questionKeywords = [newQuestion objectForKey:@"keywords"];
		question.questionWhoAsked = [newQuestion objectForKey:@"whoAsked"];
		question.questionWhoAnswered = [newQuestion objectForKey:@"whoAnswered"];
		question.answerCount = [newQuestion objectForKey:@"answerCount"];
		question.questionID = [newQuestion objectForKey:@"videoID"];
    } else {
        question = [matches lastObject];
    }
    return question;
}

@end
