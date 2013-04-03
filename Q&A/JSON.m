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
#import "AFNetworking.h"

@implementation JSON

- (void)getJSONDataFromURL:(NSString *)url intoDocument:(UIManagedDocument *)document
{	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	dispatch_queue_t getJSONQ = dispatch_queue_create("get JSON", NULL);
	dispatch_async(getJSONQ, ^{
		NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
		if (!jsonData) {
			//获取数据为空，报错
			if ([self.delegate respondsToSelector:@selector(fetchJSONFailed)]) {
				[self.delegate fetchJSONFailed];
			}
		} else {
			[self saveData:jsonData];
		}
	});	
//	dispatch_release(getJSONQ);
}
//用NSURLRequest可以设置超时
- (void)getJSONDataFromURL:(NSString *)urlString success:(void (^)(NSData *data))successBlock failure:(void (^)(NSString *err))failureBlock
{	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [NSURL URLWithString:urlString];

	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		if ([data length] > 0 && error == nil) {
			if (successBlock) {
				successBlock(data);
			} else {
				[self saveData:data];
			}
		}
		else if ([data length] == 0 && error == nil) {
			if (failureBlock) {
				failureBlock(@"数据为空");
			} else {
				NSLog(@"数据为空");
				if ([self.delegate respondsToSelector:@selector(fetchJSONFailed)]) {
					[self.delegate fetchJSONFailed];
				}
			}
		}
		else if (error != nil) {
			if (failureBlock) {
				NSString *err = [NSString stringWithFormat:@"Error happened : %@", error.localizedDescription];
				failureBlock(err);
			} else {
				NSLog(@"Error happened : %@", error.localizedDescription);
				if ([self.delegate respondsToSelector:@selector(fetchJSONFailed)]) {
					[self.delegate fetchJSONFailed];
				}
			}
		}
	}];
}

#pragma mark - 将数据存入数据库，并发出保存结束的消息
- (void)saveData:(NSData *)jsonData
{
	NSArray *questions = [self fetchData:jsonData];
	NSAssert(questions != nil, @"没有获取数据...");
	if ([self.delegate respondsToSelector:@selector(fetchedData:)]) {
		[self.delegate fetchedData:questions];
	}
	
	NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
	for (NSDictionary *question in questions) {
#warning 这里有一个没有video的问题，先暂时跳过此问题，后续在用delete去服务器上删除		
		if (![[question valueForKey:@"id"] isEqualToString:@"50ff283bb7606b18aca8889f"]) {
			[Question questionWithInfo:question inManagedObjectContext:context];
		}
	}
	if ([self.delegate respondsToSelector:@selector(fetchJSONDidFinished)]) {
		[self.delegate fetchJSONDidFinished];
	}
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

+ (void)postJSONData:(NSData *)jsonData toServerURL:(NSURL *)serverURL
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
	
    [request setHTTPMethod:@"POST"];
	
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    [request setHTTPBody:jsonData];		
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	//上传进度
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		NSLog(@"发布进度：%1.0f%%", (double)totalBytesWritten / (double)totalBytesExpectedToWrite * 100);
	}];
	//上传信息反馈
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"发布成功");
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		//返回videoId
		NSLog(@"返回的ID: %@", operation.responseString);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"发布出错: %@", error);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}];
	[operation start];
}

@end
