//
//  BBKeyboardAwareTextField.m
//  BBKeyboardAwareTextField
//
//  Created by Benzamin Basher Planning on 10/31/17.
//  Copyright © 2017 RedGreen Studio. All rights reserved.
//

#import "BBKeyboardAwareTextField.h"

#define BB_EXPTXTVIEW_DEFAULT_PLACEHOLDER  @""
//265 is average height of teyboard in all iPhone devices, 44 is the done button toolbar + 44 is the height of the text suggestion bar
#define BB_EXPTXTVIEW_AVERAGE_KEYBOARD_HEIGHT 258 + 44

@interface BBKeyboardAwareTextField()<UITextViewDelegate>
@property(nonatomic, assign) CGFloat viewMoveUpOffsetForKeyboard; //for keeping track of the keyboard's view push height
@property(nonatomic, assign) CGFloat keyboardHeight; //for keeping track of the keyboard's height
@end

@implementation BBKeyboardAwareTextField


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self commonInit];
    return self;
}

- (void)commonInit
{
    //initial values
    _keyboardHeight = BB_EXPTXTVIEW_AVERAGE_KEYBOARD_HEIGHT;
    _gapThreshold = 5;
    _animationDuration = 0.3f;
    self.delegate = self;
    
    if( self.keyboardType == UIKeyboardTypeNumberPad || self.keyboardType == UIKeyboardTypePhonePad ||self.keyboardType == UIKeyboardTypeDecimalPad )
    {
        //ad done button over keyboard
        UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDonePressed:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
        self.inputAccessoryView = keyboardDoneButtonView;
    }
    else
        self.returnKeyType = UIReturnKeyDone;
}

- (void)didMoveToSuperview {
    if (self.superview) {
         //Added to a superview, similar to -viewDidLoad. Subscribe to notifications here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        // Will be removed from superview, similar to -viewDidUnload. Unsubscribe from any notifications here.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardDonePressed:(id)sender
{
    [self endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)anotification {
    
    if([self.delegateKeyboardAwareTextField respondsToSelector:@selector(BBKeyboardAwareTextFieldWillBeginEditing:)])
    {
        [_delegateKeyboardAwareTextField BBKeyboardAwareTextFieldWillBeginEditing:self];
    }
    // get keyboard height
    NSDictionary* info = [anotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardHeight = kbSize.height;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(kbSize.height > self.keyboardHeight)
        self.keyboardHeight = kbSize.height;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self viewController].view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
        self.viewMoveUpOffsetForKeyboard = 0;
    }
    [self resignFirstResponder];
    return YES;
}


#pragma mark - TextField delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField // return NO to disallow editing
{
    //move the main view, so that the keyboard does not hide it.
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint textViewXYPointInWindow = [self convertPoint:CGPointMake(0, 0) toView:[self viewController].view];
    float textViewBottomPoint = textViewXYPointInWindow.y;
    //float textFiledBottomPoint = self.frame.origin.y;
    float threashold = screenHeight - textViewBottomPoint;
    
        if  (threashold < _keyboardHeight)
        {
            self.viewMoveUpOffsetForKeyboard = (_keyboardHeight - threashold) + self.frame.size.height;
            if(self.frame.origin.y >= 0)
                [self setViewMovedUp:YES];
        }
    
    //call delegeate
    if([self.delegateKeyboardAwareTextField respondsToSelector:@selector(BBKeyboardAwareTextFieldDidBeginEditing:)])
    {
        [_delegateKeyboardAwareTextField BBKeyboardAwareTextFieldDidBeginEditing:self];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIViewController *parentViewController = [self viewController];
    if(!parentViewController)
        return;
    
    if (parentViewController.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
    //call delegeate
    if([self.delegateKeyboardAwareTextField respondsToSelector:@selector(BBKeyboardAwareTextFieldDoneEditing:)])
    {
        [_delegateKeyboardAwareTextField BBKeyboardAwareTextFieldDoneEditing:self];
    }
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:self.animationDuration]; // if you want to slide up the view
    UIViewController *parentViewController = [self viewController];
    if(!parentViewController)
        return;
    
    CGRect rect = parentViewController.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= self.viewMoveUpOffsetForKeyboard + self.gapThreshold;
        rect.size.height += self.viewMoveUpOffsetForKeyboard + self.gapThreshold;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += self.viewMoveUpOffsetForKeyboard + self.gapThreshold;
        rect.size.height -= self.viewMoveUpOffsetForKeyboard + self.gapThreshold;
    }
    
    parentViewController.view.frame = rect;
    
    [UIView commitAnimations];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
