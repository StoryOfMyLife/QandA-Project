//
//  AccountController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-3-15.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "Account.h"

// User Default Key
#define USER_DEFAULT_KEY_MAIL @"AccountMail"
#define USER_DEFAULT_KEY_PASSWORD @"AccountPassword"
#define USER_DEFAULT_KEY_USERID @"AccountUserID"
#define USER_DEFAULT_KEY_ACCESSTOKEN @"AccountAccessToken"
#define USER_DEFAULT_KEY_EXPIRE @"AccountExpire"

@interface Account()

@end

@implementation Account

static Account *accountController = nil;

+ (Account *)sharedAcount
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		accountController = [[Account alloc] init];
	});
	return accountController;
}

#pragma mark - 获取账户信息
- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_PASSWORD];
}

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_USERID];
}

- (NSString *)accessToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_ACCESSTOKEN];
}

- (BOOL)isloginedIn
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:USER_DEFAULT_KEY_EXPIRE];
}

#pragma mark - 保存账户信息

- (void)setPassword:(NSString *)password
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:password forKey:USER_DEFAULT_KEY_PASSWORD];
    [userDefaults synchronize];
}

- (void)setUserID:(NSString *)userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userID forKey:USER_DEFAULT_KEY_USERID];
    [userDefaults synchronize];
}

- (void)setAccessToken:(NSString *)accessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:accessToken forKey:USER_DEFAULT_KEY_ACCESSTOKEN];
    [userDefaults synchronize];
}

- (void)setLoginedIn:(BOOL)loginedIn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:loginedIn forKey:USER_DEFAULT_KEY_EXPIRE];
    [userDefaults synchronize];
}

#pragma mark - 删除账户信息

- (void)removePassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_PASSWORD];
    [userDefaults synchronize];
}

- (void)removeUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_USERID];
    [userDefaults synchronize];
}

- (void)removeAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_ACCESSTOKEN];
    [userDefaults synchronize];
}

- (void)removeLoginedIn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_EXPIRE];
    [userDefaults synchronize];
}

@end
