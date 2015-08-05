//
//  ViewController.m
//  iSendSMS
//
//  Created by Rajesh on 6/19/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "FPTextView.h"
#import "FPTextField.h"
#import "Connection.h"
#import "SendingIndicatorView.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate>
{
    SendingIndicatorView *indicatorView;
    ABPeoplePickerNavigationController *peoplePickerController;
}
@property (weak, nonatomic) IBOutlet FPTextField *txtNumber;
@property (weak, nonatomic) IBOutlet FPTextView *txtVwMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
- (IBAction)sendTapped:(id)sender;
- (IBAction)leftBarButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_txtNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtVwMessage.layer setCornerRadius:5];
    [_txtVwMessage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_txtVwMessage.layer setBorderWidth:.5];
    [_txtVwMessage.lblPlaceHolder setText:@"Message"];
    [_txtVwMessage.lblFloating setText:@"Message"];

    [_txtNumber textFieldTextChanged];
    
    UIButton *buttonContact = [[UIButton alloc] initWithFrame:CGRectMake(_txtNumber.bounds.size.width - _txtNumber.bounds.size.height, 2.5, _txtNumber.bounds.size.height - 5, _txtNumber.bounds.size.height - 5)];
    [buttonContact setImage:[UIImage imageNamed:@"Contact.png"] forState:UIControlStateNormal];
    [buttonContact setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [buttonContact addTarget:self action:@selector(chooseContact) forControlEvents:UIControlEventTouchUpInside];
    [_txtNumber addSubview:buttonContact];
    
    indicatorView = [[SendingIndicatorView alloc] initWithFrame:CGRectMake(0, 32, self.view.bounds.size.width, 2) andIndicationColor:[UIColor greenColor]];
    [self.view addSubview:indicatorView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![Connection isLoggedIn])
        {
            UIAlertController *alertCntlr = [UIAlertController alertControllerWithTitle:nil message:@"Application is not logged in. Please login to send SMS" preferredStyle:UIAlertControllerStyleAlert];
            [alertCntlr addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertCntlr addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self leftBarButtonTapped:nil];
            }]];
            [self presentViewController:alertCntlr animated:YES completion:nil];
        }
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureLeftBarButton];
}

- (void)configureLeftBarButton
{
    if ([Connection isLoggedIn])
    {
        [_leftBarButton setTitle:@"Logout"];
    }
    else
    {
        [_leftBarButton setTitle:@"Login"];
    }
}

- (void)chooseContact
{
    peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
    [peoplePickerController setPeoplePickerDelegate:self];
    [self presentViewController:peoplePickerController animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phoneID = ABMultiValueCopyValueAtIndex(phone, 0);
    if (phoneID)
    {
        _txtNumber.text = [[[NSString stringWithFormat:@"%@", phoneID] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"  -()"]]
                            componentsJoinedByString:@""];
        _txtNumber.text = [_txtNumber.text stringByReplacingOccurrencesOfString:@"+91" withString:@""];
        CFRelease(phoneID);
        CFRelease(phone);
    }
    else
    {
        UIAlertController *alertCntlr = [UIAlertController alertControllerWithTitle:nil message:@"Phone number not available" preferredStyle:UIAlertControllerStyleAlert];
        [alertCntlr addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCntlr animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtNumber resignFirstResponder];
    [self.txtVwMessage resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return text.length ?textView.text.length < 158 : YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByAppendingString:string]];
    return [numbersOnly isSupersetOfSet:characterSetFromTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




- (IBAction)sendTapped:(id)sender
{
    if (![Connection isLoggedIn])
    {
        UIAlertController *alertCntlr = [UIAlertController alertControllerWithTitle:nil message:@"You are not logged in. Please login to send SMS" preferredStyle:UIAlertControllerStyleAlert];
        [alertCntlr addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [alertCntlr addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self leftBarButtonTapped:nil];
        }]];
        [self presentViewController:alertCntlr animated:YES completion:nil];
        return;
    }
    
    if (_txtNumber.text.length != 10)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid number" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (!_txtVwMessage.text.length)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter some Message" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self touchesBegan:nil withEvent:nil];
    [indicatorView startAnimating];
    [Connection sendSMSToNumber:_txtNumber.text andMessage:_txtVwMessage.text block:^(Result *objResult) {
        [indicatorView stopAnimating];
        if (objResult.bStatus)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:objResult.strText preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                _txtNumber.text = @"";
                _txtVwMessage.text = @"";
                
                [_txtNumber textFieldTextChanged];
                [_txtVwMessage textViewTextChanged];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:objResult.strText preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)leftBarButtonTapped:(id)sender
{
    if ([Connection isLoggedIn])
    {
        UIAlertController *alertCntlr = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
        [alertCntlr addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil]];
        [alertCntlr addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [Connection logout];
            [_txtNumber setText:@""];
            [_txtVwMessage setText:@""];
                [self configureLeftBarButton];
        }]];
        [self presentViewController:alertCntlr animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES completion:nil];
    }
}
@end
