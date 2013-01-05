//
//  Video+Insert.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "Video.h"

@interface Video (Insert)

+ (Video *)videoWithInfo:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
