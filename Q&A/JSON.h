//
//  JSON.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-18.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
//#define kURL @"http:api.kivaws.org/v1/loans/search.json?status=fundraising"


#import <Foundation/Foundation.h>

@protocol MyJSONDelegate <NSObject>

//JSON数据获取结果状态指示
@optional
- (void)fetchJSONDidFinished;
- (void)fetchJSONFailed;
- (void)fetchedData:(NSArray *)array;
@end

@interface JSON : NSObject

@property (nonatomic, weak) id <MyJSONDelegate> delegate;
/*
后台自动获取JSON数据，并更新到数据库中 
*/
- (void)getJSONDataFromURL:(NSString *)url intoDocument:(UIManagedDocument *)document;

/*
 此方法当success或者failure为nil的时候，才会调用delegate
 */
- (void)getJSONDataFromURL:(NSString *)urlString success:(void (^)(NSData *data))successBlock failure:(void (^)(NSString *err))failureBlock;

+ (void)postJSONData:(NSData *)jsonData toServerURL:(NSURL *)serverURL;

@end
