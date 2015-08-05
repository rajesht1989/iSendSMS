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
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Mashape"] forHTTPHeaderField:@"X-Mashape-Key"];
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

@end
/*
 import java.util.*;
 import com.twilio.sdk.*;
 import com.twilio.sdk.resource.factory.*;
 import com.twilio.sdk.resource.instance.*;
 import com.twilio.sdk.resource.list.*;
 
 public class TwilioTest {
 // Find your Account Sid and Token at twilio.com/user/account
 public static final String ACCOUNT_SID = "AC222b4e25bb2b13e8c553486450fd0b3c";
 public static final String AUTH_TOKEN = "[AuthToken]";
 
 public static void main(String[]args) throws TwilioRestException {
	TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);
 
 // Build the parameters
 List<NameValuePair> params = new ArrayList<NameValuePair>();
 params.add(new BasicNameValuePair("To", "321213123123"));
 params.add(new BasicNameValuePair("From", "+123123123123"));
 
 MessageFactory messageFactory = client.getAccount().getMessageFactory();
 Message message = messageFactory.create(params);
 System.out.println(message.getSid());
 }
 }
 */

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
