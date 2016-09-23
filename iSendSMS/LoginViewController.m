//
//  LoginViewController.m
//  iSendSMS
//
//  Created by Rajesh on 7/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "Connection.h"
#import "SendingIndicatorView.h"

@interface LoginViewController ()
{
    __weak IBOutlet UITextField *txtUserName;
    __weak IBOutlet UITextField *txtPassword;
    SendingIndicatorView *indicatorView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    indicatorView = [[SendingIndicatorView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 2) andIndicationColor:[UIColor greenColor]];
    [self.view addSubview:indicatorView];
    
    if ([Connection isLoggedIn])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (IBAction)signUpTapped:(id)sender
{
    UINavigationController *navigationController = [[self storyboard] instantiateViewControllerWithIdentifier:@"webViewController"];
    WebViewController *webviewController = (WebViewController *)[navigationController topViewController];
    [webviewController setUrlType:kSignUp];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)forgotPasswordTapped:(id)sender
{
    UINavigationController *navigationController = [[self storyboard] instantiateViewControllerWithIdentifier:@"webViewController"];
    WebViewController *webviewController = (WebViewController *)[navigationController topViewController];
    [webviewController setUrlType:kForgotPassword];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)loginButtonTapped:(id)sender
{
    if (!txtUserName.text.length)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter Username" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (!txtPassword.text.length)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSSet *set;
    [self touchesBegan:set withEvent:nil];
    [indicatorView startAnimating];
    [Connection loginWithUserName:txtUserName.text andPassword:txtPassword.text block:^(Result *objResult) {
        [indicatorView stopAnimating];
        if (objResult.bStatus)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objResult.strText preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
