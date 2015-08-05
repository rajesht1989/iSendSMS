//
//  WebViewController.m
//  iSendSMS
//
//  Created by Rajesh on 7/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController (){
    IBOutlet UIWebView *webView;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *strUrl;
    switch (_urlType)
    {
        case kSignUp:
            strUrl = @"http://freesms8.co.in/Free-SMS-India-Mobile-Registration.aspx";
            [self setTitle:@"Sign up"];
            break;
        case kForgotPassword:
            [self setTitle:@"Forgot password"];
            strUrl = @"http://www.freesms8.co.in/forgotpassword.aspx";
            break;
        default:
            break;
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}
- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
