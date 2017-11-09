//
//  BBExpandableTextView.h
//  BBExpandableTextView
//
//  Created by Benzamin Basher Planning on 10/31/17.
//  Copyright © 2017 RedGreen Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BBExpandandableTextViewDelegate;

IB_DESIGNABLE @interface BBExpandableTextView : UITextView 


@property(nonatomic, assign) IBOutlet id <BBExpandandableTextViewDelegate> delegateExpandableTextView;

/** TextView placeholder text. Default there's no placeholder text
 */
@property (nonatomic) IBInspectable NSString *placeHolderText;

/** TextView height when expanded. Default is 120.
 */
@property (nonatomic) IBInspectable CGFloat expandHeight;

/** Extra distance from keyboard to TextView you want to put while expanding. Default is 15
 */
@property (nonatomic) IBInspectable CGFloat gapThreshold;

/** Animation duration of textview expandtion, default is 0.3 seconds.
 */
@property (nonatomic) IBInspectable CGFloat animationDuration;

/** BOOL to control animate or not while expanding the textview, default in true
 */
@property (nonatomic) IBInspectable BOOL showBoxWhenExpanded;


@end

@protocol BBExpandandableTextViewDelegate <NSObject>

@optional

/** When keyboard is up and textview is about to expand
 */
-(void)BBExpandableTextViewWillBeginEditing:(BBExpandableTextView*)expandableTextView;

/** When keyboard is up and textview is expanded
 */
-(void)BBExpandableTextViewDidBeginEditing:(BBExpandableTextView*)expandableTextView;

/** When keyboard is down and textview is collapsed
 */
-(void)BBExpandableTextViewDoneEditing:(BBExpandableTextView*)expandableTextView;
@end

