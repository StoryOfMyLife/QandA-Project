//
//  JSON.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-18.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "JSON.h"
#import "Question+Insert.h"

@implementation JSON

- (void)getJSONDataFromURL:(NSString *)url intoDocument:(UIManagedDocument *)document
{	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	dispatch_queue_t getJSONQ = dispatch_queue_create("get JSON", NULL);
	dispatch_async(getJSONQ, ^{
		NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
		if (!jsonData) {
			//获取数据为空，报错
			[self.delegate fetchJSONFailed];
		} else {
			[self saveData:jsonData];
		}
	});	
	dispatch_release(getJSONQ);
}
#pragma mark - 将数据存入数据库，并发出保存结束的消息
- (void)saveData:(NSData *)jsonData
{
	NSArray *questions = [self fetchData:jsonData];
	NSAssert(questions != nil, @"没有获取数据...");

	NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];

	for (NSDictionary *question in questions) {	
		NSDictionary * newQuestion = [self extractDataFromData:question];
		[Question insertNewQuestion:newQuestion inManagedObjectContext:context];
	}
	[self.delegate fetchJSONDidFinished];
}

//解析JSON数据
- (NSArray *)fetchData:(NSData *)jsonData
{
	NSError *error = nil;
	
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
	
	return results;
}

//数据处理
- (NSDictionary *)extractDataFromData:(NSDictionary *)data
{	
	NSString *title = [data valueForKey:@"title"];
	
	NSString *tag0 = [data valueForKey:@"tag0"];
	NSString *tag1 = [data valueForKey:@"tag1"];
	NSString *tag2 = [data valueForKey:@"tag2"];
	NSString *keywords = [[NSString alloc] initWithFormat:@"【%@, %@, %@】", tag0, tag1, tag2];
	
	NSString *create_cnName = [data valueForKey:@"create_cnName"];
	NSString *createTime = [data valueForKey:@"createTime"];
	NSString *askedFrom = [[NSString alloc] initWithFormat:@"发布人:%@ 学生 %@", create_cnName, createTime];
	
	NSString *lastAnswer_cnName = [data valueForKey:@"lastAnswer_cnName"];
	NSString *lastAnswerTime = [data valueForKey:@"lastAnswerTime"];
	NSString *answeredFrom = [[NSString alloc] initWithFormat:@"最后回答:%@ 教师 %@", lastAnswer_cnName, lastAnswerTime];
	
	NSString *countAnswer = [data valueForKey:@"countAnswer"];
	NSString *answerCount = [[NSString alloc] initWithFormat:@"(%@)", countAnswer];
	
	NSString *videoID = [data valueForKey:@"videoId"];
	
	NSDictionary *dataDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title", 
																				keywords, @"keywords",
																				askedFrom, @"whoAsked",
																				answeredFrom, @"whoAnswered",
																				answerCount, @"answerCount",
																				videoID, @"videoID", nil];
	return dataDictionary;	
}

@end
