//
//  SecondViewController.m
//  BBExpandableTextView
//
//  Created by Benzamin Basher Planning on 10/31/17.
//  Copyright © 2017 RedGreen Studio. All rights reserved.
//

#import "SecondViewController.h"
#import "BBExpandableTextView.h"


@interface SecondViewController ()<UITextFieldDelegate, BBExpandandableTextViewDelegate>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - BBExpandableTextView Delegate

-(void)BBExpandableTextViewWillBeginEditing:(BBExpandableTextView *)expandableTextView
{
    NSLog(@"TextField will begin editing.....");
}

-(void)BBExpandableTextViewDidBeginEditing:(BBExpandableTextView*)expandableTextView
{
    NSLog(@"TextField just began editing!");
}
-(void)BBExpandableTextViewDoneEditing:(BBExpandableTextView*)expandableTextView
{
    NSLog(@"TextField done editing, Bye Bye.");
}


@end
