//
//  FPTextField.h
//  iFloatingPlaceHolder
//
//  Created by Rajesh on 5/28/15.
//

#import <UIKit/UIKit.h>

@interface FPTextField : UITextField

@property(nonatomic,strong) UILabel *lblFloating;

- (void)textFieldTextChanged;

@end
