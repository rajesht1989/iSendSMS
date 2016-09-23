//
//  Connection.h
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithErrorText:(NSString *)error;
@property (nonatomic,assign)BOOL bStatus;
@property (nonatomic,strong)NSString *strText;
@end

typedef void (^completionResult)(Result *objResult);

@interface Connection : NSObject

+ (void)sendSMSToNumber:(NSString *)strNumber andMessage:(NSString *)strMessage block:(completionResult)completion;
+ (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password block:(completionResult)completion;
+ (void)sendMsendSMSToNumber:(NSString *)strNumber andMessage:(NSString *)strMessage block:(completionResult)completion;
+ (BOOL)isLoggedIn;
+ (void)logout;

@end


