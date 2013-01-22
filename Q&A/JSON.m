//
//  JSON.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-18.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "JSON.h"
#import "Question+Insert.h"
#import "Video+Insert.h"
#import "Answer+Insert.h"
#import "AFNetworkActivityIndicatorManager.h"

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
//用NSURLRequest可以设置超时
- (void)getJSONDataFromURL:(NSString *)urlString
{	
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];	
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [NSURL URLWithString:urlString];

	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
		if ([data length] >0 && error == nil) {
			[self saveData:data];
		}
		else if ([data length] == 0 && error == nil) {
			//获取数据为空，报错
//			[self.delegate fetchJSONFailed];
			NSLog(@"数据为空");
		}
		else if (error != nil) {
			NSLog(@"Error happened : %@", error.localizedDescription);

			[self.delegate fetchJSONFailed];
		}
	}];
}

#pragma mark - 将数据存入数据库，并发出保存结束的消息
- (void)saveData:(NSData *)jsonData
{
	NSArray *questions = [self fetchData:jsonData];
	NSAssert(questions != nil, @"没有获取数据...");

	NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];

	for (NSDictionary *question in questions) {
#warning 这里有一个没有video的问题，先暂时跳过此问题，后续在用delete去服务器上删除		
		if (![[question valueForKey:@"id"] isEqualToString:@"50ff283bb7606b18aca8889f"]) {
			[Question questionWithInfo:question inManagedObjectContext:context];
		}
	}
	[self.delegate fetchJSONDidFinished];
}

//解析JSON数据
- (NSArray *)fetchData:(NSData *)jsonData
{
	NSError *error = nil;
	
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
	
	NSArray *questions = (NSArray *)[results objectForKey:@"content"];
	
	return questions;
}

@end
