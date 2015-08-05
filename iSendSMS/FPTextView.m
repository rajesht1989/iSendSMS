//
//  FPTextView.m
//  iFloatingPlaceHolder
//
//  Created by Rajesh on 5/28/15.
//

#import "FPTextView.h"

@implementation FPTextView

- (void)awakeFromNib
{
    self.lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width, 20)];
    [self addSubview:self.lblPlaceHolder];
    [self.lblPlaceHolder setTextColor:[UIColor lightGrayColor]];
    [self.lblPlaceHolder setFont:[UIFont systemFontOfSize:14]];

    [self setClipsToBounds:NO];
    self.lblFloating = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.bounds.size.width, 10)];
    [self.lblFloating setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:self.lblFloating];
    [self.lblFloating setTextColor:[UIColor darkGrayColor]];
    [self.lblFloating setFont:[UIFont systemFontOfSize:9]];
    [self.lblFloating setAlpha:.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewTextChanged
{
    if (self.text.length)
    {
        [self.lblPlaceHolder setHidden:YES];
        [UIView animateWithDuration:.3 animations:^{
            [self.lblFloating setAlpha:1];
        }];
    }
    else
    {
        [self.lblPlaceHolder setHidden:NO];
        [UIView animateWithDuration:.3 animations:^{
            [self.lblFloating setAlpha:0];
        }];
    }
}

@end
