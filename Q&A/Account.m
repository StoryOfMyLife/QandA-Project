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
#define USER_DEFAULT_KEY_USERNAME @"AccountUserName"
#define USER_DEFAULT_KEY_ACCESSTOKEN @"AccountAccessToken"
#define USER_DEFAULT_KEY_EXPIRE @"AccountExpire"
#define USER_TAGS @"Tags"

@interface Account()

@end

@implementation Account

+ (Account *)sharedAcount
{
	static Account *accountController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		accountController = [[Account alloc] init];
	});
	return accountController;
}

- (UIImage *)userProfileImage
{
	NSString *imagePath = [self imagePath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:imagePath]) {
		NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
		UIImage *image = [UIImage imageWithData:imageData];
		return image;
	}
	return nil;
}

- (void)setUserProfileImage:(UIImage *)userProfileImage
{
	NSString *imagePath = [self imagePath];
	if (userProfileImage) {
		NSData *imageData = UIImagePNGRepresentation(userProfileImage);
		[imageData writeToFile:imagePath atomically:YES];
	} else {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:imagePath]) {
			[fileManager removeItemAtPath:imagePath error:nil];
		}
	}
}

- (NSString *)imagePath
{
	NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *imagePath = [documentPath stringByAppendingPathComponent:@"profile_image.png"];
	return imagePath;
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

- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_USERNAME];
}

- (NSString *)accessToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_ACCESSTOKEN];
}

- (NSArray *)tags
{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:USER_TAGS];
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

- (void)setUsername:(NSString *)username
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:username forKey:USER_DEFAULT_KEY_USERNAME];
    [userDefaults synchronize];
}

- (void)setAccessToken:(NSString *)accessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:accessToken forKey:USER_DEFAULT_KEY_ACCESSTOKEN];
    [userDefaults synchronize];
}

- (void)setTags:(NSArray *)tags
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:tags forKey:USER_TAGS];
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

- (void)removeUsername
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_USERNAME];
    [userDefaults synchronize];
}

- (void)removeAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_ACCESSTOKEN];
    [userDefaults synchronize];
}

- (void)removeTags
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_TAGS];
    [userDefaults synchronize];
}

- (void)removeLoginedIn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_DEFAULT_KEY_EXPIRE];
    [userDefaults synchronize];
}

@end
