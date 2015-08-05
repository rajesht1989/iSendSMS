//
//  FPTextField.m
//  iFloatingPlaceHolder
//
//  Created by Rajesh on 5/28/15.
//

#import "FPTextField.h"

@implementation FPTextField

- (void)awakeFromNib
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
  
    [self setClipsToBounds:NO];
    self.lblFloating = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.bounds.size.width, 10)];
    [self addSubview:self.lblFloating];
    [self.lblFloating setTextColor:[UIColor lightGrayColor]];
    [self.lblFloating setFont:[UIFont fontWithName:self.font.familyName size:9]];
    [self.lblFloating setText:self.placeholder];
    [self.lblFloating setAlpha:.0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextChanged
{
    if (self.text.length)
    {
        [UIView animateWithDuration:.3 animations:^{
            [self.lblFloating setAlpha:1];
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            [self.lblFloating setAlpha:0];
        }];
    }
}

@end
