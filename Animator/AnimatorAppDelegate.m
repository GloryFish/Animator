//
//  AnimatorAppDelegate.m
//  Animator
//
//  Created by Jay Roberts on 9/19/11.
//  Copyright 2011 GloryFish.org. All rights reserved.
//

#import "AnimatorAppDelegate.h"

@implementation AnimatorAppDelegate

@synthesize window;
@synthesize animationGroupController;
@synthesize spritesheet;
@synthesize spritesheetView;
@synthesize codeView;
@synthesize animationSelector;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    animationGroupController = [[AnimationGroupController alloc] init];
    scale = 4;
    [codeView setDelegate:self];
    [self updateUI];
}

-(void)dealloc {
    [animationGroupController release];
}

- (IBAction)chooseSpritesheet:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"png", nil]];
    
    if ( [openPanel runModal] == NSOKButton ) {
        NSArray* urls = [openPanel URLs];
        if ([urls count] > 0) {
            [self loadSpritesheet:[urls objectAtIndex:0]];
        }
    }
}

-(bool)loadSpritesheet:(NSURL *)url {
    NSImage* s = [[NSImage alloc] initWithContentsOfURL:url];
    
    if ([s isValid]) {
        spritesheet = s;
        [[self animationGroupController] setSpritesheetFilename:[url lastPathComponent]];
        
        NSSize size = [spritesheet size];
        size = NSMakeSize(size.width * scale, size.height * scale);
        
        [spritesheet setSize:size];
        [spritesheetView setImage:spritesheet];
        
        [self updateCodeView];
        
        return YES;
    }
    
    [s release];
    return NO;
}

-(void)updateUI {
    [self updateCodeView];
    [self updateAnimationSelector];
}

-(void)updateAnimationSelector {
    [animationSelector removeAllItems];
    NSArray* animationNames = [[[animationGroupController animationGroup] objectForKey:@"animations"] allKeys];
    [animationSelector addItemsWithTitles:animationNames];
}

-(void)updateCodeView {
    NSAttributedString* code = [[NSAttributedString alloc] initWithString:[animationGroupController code]];
    
    [[codeView textStorage] setAttributedString:code];
    [codeView setFont:[NSFont userFixedPitchFontOfSize:0.0]];

    [code release];
}

-(IBAction)newGroup:(id)sender {
    [animationGroupController resetAnimationGroup];
    [self updateUI];
}

-(IBAction)addAnimation:(id)sender {
    [animationGroupController newAnimation];
    [self updateUI];
}

#pragma mark -
#pragma mark NSTextView delegate

- (void)textDidChange:(NSNotification *)notification {
    NSLog(@"Notified");
    NSLog(@"%@", [animationGroupController code]);
    if ([animationGroupController parseFromCode:[[codeView textStorage] string]]) {
        NSLog(@"Parse successful");
        [codeView setTextColor:[NSColor blackColor]];
    } else {
        NSLog(@"Parse failed");
        [codeView setTextColor:[NSColor redColor]];
    }
}

@end
