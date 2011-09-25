//
//  AnimatorAppDelegate.h
//  Animator
//
//  Created by Jay Roberts on 9/19/11.
//  Copyright 2011 GloryFish.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AnimationGroupController.h"
#import <Quartz/Quartz.h>

@interface AnimatorAppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate> {
    NSWindow *window;
    AnimationGroupController* animationGroupController;
    NSImage* spritesheet;
    NSImageView *spritesheetView;
    NSTextView *codeView;
    NSPopUpButton *animationSelector;
    NSImageView *animationView;
    NSInteger scale;
    NSArray* currentAnimationFrames;
    NSArray* currentAnimationDurations;
    int currentAnimationIndex;
    bool loopAnimation;
}

@property (assign) IBOutlet NSWindow* window;
@property (retain) AnimationGroupController* animationGroupController;
@property (assign) IBOutlet NSImage* spritesheet;
@property (assign) IBOutlet NSImageView *spritesheetView;
@property (assign) IBOutlet NSTextView *codeView;
@property (assign) IBOutlet NSPopUpButton *animationSelector;
@property (assign) IBOutlet NSImageView *animationView;
@property (retain) NSArray* currentAnimationFrames;
@property (retain) NSArray* currentAnimationDurations;
@property (assign) IBOutlet NSButton *loopingCheckbox;
@property (assign) bool loopAnimation;

-(IBAction)chooseSpritesheet:(id)sender;
-(bool)loadSpritesheet:(NSURL*)url;
-(void)updateUI;
-(void)updateCodeView;
-(void)updateAnimationSelector;
-(IBAction)newGroup:(id)sender;
-(IBAction)addAnimation:(id)sender;
-(IBAction)playAnimation:(id)sender;
-(void)setAnimationViewWithRect:(CGRect)rect;
-(IBAction)stopAnimation:(id)sender;
-(void)playAnimation;

#pragma mark -
#pragma mark NSTextView delegate

- (void)textDidChange:(NSNotification *)notification;

@end
