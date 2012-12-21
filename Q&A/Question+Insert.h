//
//  Question+Insert.h
//  Q&A
//
//  Created by 刘廷勇 on 12-12-20.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "Question.h"

@interface Question (Insert)

+ (Question *)insertNewQuestion:(NSDictionary *)newQuestion inManagedObjectContext:(NSManagedObjectContext *)context;

@end
