//
//  BBKeyboardAwareTextField.h
//  BBKeyboardAwareTextField
//
//  Created by Benzamin Basher Planning on 10/31/17.
//  Copyright © 2017 RedGreen Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BBKeyboardAwareTextFieldDelegate;

IB_DESIGNABLE @interface BBKeyboardAwareTextField : UITextField<UITextFieldDelegate>


@property(nonatomic, assign) IBOutlet id <BBKeyboardAwareTextFieldDelegate> delegateKeyboardAwareTextField;

/** Extra distance from keyboard to TextField. Default is 5
 */
@property (nonatomic) IBInspectable CGFloat gapThreshold;

/** Animation duration of TextField expandtion, default is 0.3 seconds.
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;

@end

@protocol BBKeyboardAwareTextFieldDelegate <NSObject>

@optional

/** When keyboard is up and textview is about to expand
 */
-(void)BBKeyboardAwareTextFieldWillBeginEditing:(BBKeyboardAwareTextField*)keyboardAwareTextField;

/** When keyboard is up and textview is expanded
 */
-(void)BBKeyboardAwareTextFieldDidBeginEditing:(BBKeyboardAwareTextField*)keyboardAwareTextField;

/** When keyboard is down and textview is collapsed
 */
-(void)BBKeyboardAwareTextFieldDoneEditing:(BBKeyboardAwareTextField*)keyboardAwareTextField;
@end

