//
//  AccountController.h
//  Q&A
//
//  Created by 刘廷勇 on 13-3-15.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject 

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, getter = isloginedIn) BOOL loginedIn; 
@property (nonatomic, strong) UIImage *userProfileImage;

+ (Account *)sharedAcount;

@end
