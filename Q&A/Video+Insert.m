//
//  Video+Insert.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "Video+Insert.h"

@implementation Video (Insert)

+ (Video *)videoWithInfo:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
	Video *video = nil;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"videoID", [data valueForKey:@"id"]];
	request.fetchLimit = 10;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"videoID" ascending:YES];	
	request.sortDescriptors = @[sortDescriptor];
	
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
		NSLog(@"ERROR: 出现重复数据!!!!");
    } else if ([matches count] == 0) {
		NSString *videoID = [data valueForKey:@"id"];
		NSString *duration = [data valueForKey:@"duration"];
		NSString *fileSize = [data valueForKey:@"fileSize"];
		NSString *cameraInfo = [data valueForKey:@"cameraInfo"];
		NSString *fileType = [data valueForKey:@"fileType"];
		NSString *encode = [data valueForKey:@"encode"];
		//	NSString *mimeType = [videoDic valueForKey:@"mimeType"];
		
        video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
		
		video.videoID = videoID;
		video.duration = duration;
		video.fileSize = [NSNumber numberWithInteger:[fileSize integerValue]];
		video.fileType = fileType;
		video.encode = encode;
		video.cameraInfo = cameraInfo;
		
		[[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    } else {
        video = [matches lastObject];
    }
    return video;
}


@end
