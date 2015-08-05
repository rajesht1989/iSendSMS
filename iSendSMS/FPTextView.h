//
//  FPTextView.h
//  iFloatingPlaceHolder
//
//  Created by Rajesh on 5/28/15.
//

#import <UIKit/UIKit.h>

@interface FPTextView : UITextView

- (void)textViewTextChanged;

@property(nonatomic,strong) UILabel *lblPlaceHolder;
@property(nonatomic,strong) UILabel *lblFloating;

@end
