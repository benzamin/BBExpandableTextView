//
//  BBExpandableTextView.m
//  BBExpandableTextView
//
//  Created by Benzamin Basher Planning on 10/31/17.
//  Copyright © 2017 RedGreen Studio. All rights reserved.
//

#import "BBExpandableTextView.h"

#define BB_EXPTXTVIEW_DEFAULT_PLACEHOLDER  @""
//265 is average height of teyboard in all iPhone devices, 44 is the done button toolbar + 44 is the height of the text suggestion bar
#define BB_EXPTXTVIEW_AVERAGE_KEYBOARD_HEIGHT 265 + 44 + 44

@interface BBExpandableTextView()<UITextViewDelegate>
@property(nonatomic, assign) CGFloat viewMoveUpOffsetForKeyboard; //for keeping track of the keyboard's view push height
@property(nonatomic, assign) CGFloat initialHeightOfSelf; //for keeping track of the keyboard's height
@property(nonatomic, assign) CGFloat initialBorderWidth;
@property(nonatomic, assign) CGColorRef initialBorderColor;
@property(nonatomic, assign) CGFloat initialCornerRadius;
@property(nonatomic, assign) CGFloat keyboardHeight; //for keeping track of the keyboard's view push height
@end

@implementation BBExpandableTextView


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
    //show initial values
    _placeHolderText = BB_EXPTXTVIEW_DEFAULT_PLACEHOLDER;
    _keyboardHeight = BB_EXPTXTVIEW_AVERAGE_KEYBOARD_HEIGHT;
    _expandHeight = 120;
    _gapThreshold = 0;
    _animationDuration = 0.3f;
    _showBoxWhenExpanded = YES;
   
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    self.layer.masksToBounds = YES;
    
    //ad done button over keyboard
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDonePressed:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.inputAccessoryView = keyboardDoneButtonView;
    
}

- (void)didMoveToWindow {
    if (self.window) {
        // Added to a window, similar to -viewDidLoad. Subscribe to notifications here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    }
    //show placeholder text
    if ([self.text isEqualToString:@""]) {
        self.textColor = [UIColor colorWithRed:210/255 green:210/255 blue:210/255 alpha:.21];
        self.text = self.placeHolderText;
    }
    else
        self.textColor = [UIColor blackColor];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        // Will be removed from window, similar to -viewDidUnload. Unsubscribe from any notifications here.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardDonePressed:(id)sender
{
    [self endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)anotification {
    
    if([self.delegateExpandableTextView respondsToSelector:@selector(BBExpandableTextViewWillBeginEditing:)])
    {
        [_delegateExpandableTextView BBExpandableTextViewWillBeginEditing:self];
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




#pragma mark - TextView delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.initialHeightOfSelf = self.frame.size.height;
    self.initialBorderColor = self.layer.borderColor;
    self.initialBorderWidth = self.layer.borderWidth;
    self.initialCornerRadius = self.layer.cornerRadius;
    
    NSLayoutConstraint *heightCon = [self getHeightConstrintOfSelf];
    if(heightCon)
    {
        [UIView animateWithDuration:self.animationDuration animations:^{
            heightCon.constant = _expandHeight;
            if(self.showBoxWhenExpanded && !self.layer.borderWidth) //default is 0
            {
                self.layer.borderWidth = 1.0f;
                self.layer.borderColor =  [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f] CGColor];
            }
            if(self.showBoxWhenExpanded && !self.layer.cornerRadius)//default is 0
                self.layer.cornerRadius = 5;
            
            [self.superview layoutIfNeeded];
            
        }];
    }
    else{
        CGRect rect = self.frame;
        rect.size.height = _expandHeight;
        self.frame = rect;
        [self.superview layoutIfNeeded];
    }
    
    //set up placeholder text
    if ([self.text isEqualToString:_placeHolderText]) {
        self.text = @"";
        self.textColor = [UIColor blackColor]; //optional
    }
    [self becomeFirstResponder];

    //move the main view, so that the keyboard does not hide it.
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGPoint textFieldXYPointInWindow = [self convertPoint:CGPointMake(0, 0) toView:[self viewController].view];
//    float textFiledBottomPoint = textFieldXYPointInWindow.y + self.initialHeightOfSelf;
    float textFiledBottomPoint = self.frame.origin.y + self.initialHeightOfSelf;
    float threashold = screenHeight - (textFiledBottomPoint + _expandHeight - 20);
    
        if  ((screenHeight - (textFiledBottomPoint + _expandHeight)) < _keyboardHeight)
        {
            self.viewMoveUpOffsetForKeyboard = _keyboardHeight - threashold;
            if(self.frame.origin.y >= 0)
                [self setViewMovedUp:YES];
        }
    
    //call delegeate
    if([self.delegateExpandableTextView respondsToSelector:@selector(BBExpandableTextViewDidBeginEditing:)])
    {
        [_delegateExpandableTextView BBExpandableTextViewDidBeginEditing:self];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self scrollsToTop];
    [self flashScrollIndicators];
    
    NSLayoutConstraint *heightCon = [self getHeightConstrintOfSelf];
    
    if(heightCon)//height constrint available, animate it
    {
        [UIView animateWithDuration:self.animationDuration animations:^{
            heightCon.constant = self.initialHeightOfSelf;
            if(self.showBoxWhenExpanded){
                self.layer.borderWidth = self.initialBorderWidth;
                self.layer.borderColor = self.initialBorderColor;
                self.layer.cornerRadius = self.initialCornerRadius;
            }
            [self.superview layoutIfNeeded];
        }];
    }
    else{
        CGRect rect = self.frame;
        rect.size.height = self.initialHeightOfSelf;
        self.frame = rect;
        [self.superview layoutIfNeeded];
    }

    
    if ([self.text isEqualToString:@""]) {
        self.text = _placeHolderText;
        self.textColor = [UIColor colorWithRed:210/255 green:210/255 blue:210/255 alpha:.21]; //optional
    }
    [textView resignFirstResponder];
    
    UIViewController *parentViewController = [self viewController];
    if(!parentViewController)
        return;
    
    if (parentViewController.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
    //call delegeate
    if([self.delegateExpandableTextView respondsToSelector:@selector(BBExpandableTextViewDoneEditing:)])
    {
        [_delegateExpandableTextView BBExpandableTextViewDoneEditing:self];
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

-(NSLayoutConstraint*)getHeightConstrintOfSelf
{
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute) {
            heightConstraint = constraint;
            break;
        }
    }
    return heightConstraint;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
