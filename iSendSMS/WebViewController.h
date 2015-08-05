//
//  WebViewController.h
//  iSendSMS
//
//  Created by Rajesh on 7/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kSignUp = 0,
    kForgotPassword
}URLtype;
@interface WebViewController : UIViewController
@property URLtype urlType;
@end
