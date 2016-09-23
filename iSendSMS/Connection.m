//
//  Connection.m
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "Connection.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>

@implementation Connection

+ (void)sendSMSToNumber:(NSString *)strNumber andMessage:(NSString *)strMessage block:(completionResult)completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://freesms8.p.mashape.com/index.php?pwd=%@&uid=%@&msg=%@&phone=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],[self URLEncodeString:strMessage],strNumber]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"YNx23LIUU2msh4JKvb0kH0G49vaZp17QNTZjsn4VZ1YKw88Lid" forHTTPHeaderField:@"X-Mashape-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (connectionError)
            {
                completion([[Result alloc] initWithErrorText:connectionError.localizedDescription]);
            }
            else
            {
                id objReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",objReturn);
                completion([[Result alloc] initWithDictionary:objReturn]);
            }
        });
    }];
}

+ (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password block:(completionResult)completion
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"pwd"];
    [self sendSMSToNumber:userName andMessage:@"You are logged in securely with iSendSMS " block:^(Result *objResult) {
       if(objResult.bStatus)
       {
           [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"uid"];
           [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"pwd"];
       }
        completion(objResult);
    }];
    [self logout];
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
}

+ (BOOL)isLoggedIn
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) return YES;
    return NO;
}

+ (NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)sendMsendSMSToNumber:(NSString *)strNumber andMessage:(NSString *)strMessage block:(completionResult)completion {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://webaroo-send-message-v1.p.mashape.com/sendMessage?message=%@&phone=%@",[self URLEncodeString:strMessage], strNumber]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"YNx23LIUU2msh4JKvb0kH0G49vaZp17QNTZjsn4VZ1YKw88Lid" forHTTPHeaderField:@"X-Mashape-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (connectionError)
            {
                completion([[Result alloc] initWithErrorText:connectionError.localizedDescription]);
            }
            else
            {
                id objReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",objReturn);
                completion([[Result alloc] initWithDictionary:objReturn]);
            }
        });
    }];
}

@end

@implementation Result

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        _bStatus = [dict objectForKey:@"response"] ? YES:NO;
        if (_bStatus)
        {
            _strText = @"Message sent successfully";
        }
        else
        {
            _strText = [dict objectForKey:@"error"] ? [dict objectForKey:@"error"] :@"Please try again!";
        }
    }
    return self;
}

- (instancetype)initWithErrorText:(NSString *)error
{
    if (self = [super init])
    {
        _strText = error;
    }
    return self;
}

@end
