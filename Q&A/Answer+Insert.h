//
//  Answer+Insert.h
//  Q&A
//
//  Created by 刘廷勇 on 13-1-6.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "Answer.h"

@interface Answer (Insert)

+ (Answer *)answerWithInfo:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
