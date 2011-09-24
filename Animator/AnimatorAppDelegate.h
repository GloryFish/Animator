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
}

@property (assign) IBOutlet NSWindow* window;
@property (assign) AnimationGroupController* animationGroupController;
@property (assign) IBOutlet NSImage* spritesheet;
@property (assign) IBOutlet NSImageView *spritesheetView;
@property (assign) IBOutlet NSTextView *codeView;
@property (assign) IBOutlet NSPopUpButton *animationSelector;
@property (assign) IBOutlet NSImageView *animationView;

-(IBAction)chooseSpritesheet:(id)sender;
-(bool)loadSpritesheet:(NSURL*)url;
-(void)updateUI;
-(void)updateCodeView;
-(void)updateAnimationSelector;
-(IBAction)newGroup:(id)sender;
-(IBAction)addAnimation:(id)sender;
-(IBAction)playAnimation:(id)sender;


#pragma mark -
#pragma mark NSTextView delegate

- (void)textDidChange:(NSNotification *)notification;

@end
