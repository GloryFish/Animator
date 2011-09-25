//
//  AnimatorAppDelegate.m
//  Animator
//
//  Created by Jay Roberts on 9/19/11.
//  Copyright 2011 GloryFish.org. All rights reserved.
//

#import "AnimatorAppDelegate.h"
#import <Foundation/Foundation.h>

@implementation AnimatorAppDelegate

@synthesize window;
@synthesize animationGroupController;
@synthesize spritesheet;
@synthesize spritesheetView;
@synthesize codeView;
@synthesize animationSelector;
@synthesize animationView;
@synthesize currentAnimationName;
@synthesize currentAnimationFrames;
@synthesize currentAnimationDurations;
@synthesize loopingCheckbox;
@synthesize loopAnimation;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    animationGroupController = [[AnimationGroupController alloc] init];
    scale = 4;
    currentAnimationIndex = 0;
    loopAnimation = [loopingCheckbox state] == NSOnState;
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

- (IBAction)openAnimationFile:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"ani", nil]];
    
    if ( [openPanel runModal] == NSOKButton ) {
        NSArray* urls = [openPanel URLs];
        NSLog(@"urls: %@", urls);
        if ([urls count] > 0) {
            [self loadAnimationFile:[urls objectAtIndex:0]];
        }
    }

}

-(bool)loadAnimationFile:(NSURL*)url {
    NSError *error = nil;
    NSString* animationCode = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (animationCode) {
        if ([animationGroupController parseFromCode:animationCode]) {
            [codeView setString:animationCode];
            
            NSString* spritesheetFilename = [[animationGroupController animationGroup] objectForKey:@"spritesheet"];
            
            NSURL* spritesheetURL = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:spritesheetFilename];
            
            [self loadSpritesheet:spritesheetURL];
            [self updateUI];
            return YES;
        }
        
    }

    return NO;
}

-(bool)loadSpritesheet:(NSURL *)url {
    NSImage* s = [[NSImage alloc] initWithContentsOfURL:url];
    
    if ([s isValid]) {
        [self setSpritesheet:s];
        [[self animationGroupController] setSpritesheetFilename:[url lastPathComponent]];
        [spritesheetView setImage:spritesheet];
        
        [self updateCodeView];
        
        return YES;
    }
    
    [s release];
    return NO;
}

-(void)updateUI {
    if ([[animationGroupController spritesheetFilename] isEqualToString:@""]) {
        [spritesheetView setImage:nil];
    }
    
    [self updateCodeView];
    [self updateAnimationSelector];
}

-(void)updateAnimationSelector {
    [self setCurrentAnimationName:[[animationSelector selectedItem] title]];
    
    [animationSelector removeAllItems];
    NSArray* animationNames = [[[animationGroupController animationGroup] objectForKey:@"animations"] allKeys];
    [animationSelector addItemsWithTitles:animationNames];

    // Check to see if 
    if ([animationSelector itemWithTitle:currentAnimationName] != nil) {
        [animationSelector selectItemWithTitle:currentAnimationName];
    } else {
        NSString* aTitle = [[[[animationGroupController animationGroup] objectForKey:@"animations"] allKeys] objectAtIndex:0];
        [self setCurrentAnimationName:aTitle];
        [animationSelector selectItemWithTitle:currentAnimationName];
    }
}

-(void)updateCodeView {
    NSAttributedString* code = [[NSAttributedString alloc] initWithString:[animationGroupController code]];
    
    [[codeView textStorage] setAttributedString:code];
    [codeView setFont:[NSFont userFixedPitchFontOfSize:0.0]];

    [code release];
}

-(IBAction)newGroup:(id)sender {
    [animationGroupController resetAnimationGroup];
    [AnimatorAppDelegate cancelPreviousPerformRequestsWithTarget:self];
    [animationView setImage:nil];
    [self updateUI];
}

-(IBAction)addAnimation:(id)sender {
    [animationGroupController newAnimation];
    [self updateUI];
}

- (IBAction)addFrame:(id)sender {
    NSString* animation = [[animationSelector selectedItem] title];
    [animationGroupController newFrame:animation];
    [self updateUI];
}

- (IBAction)playAnimation:(id)sender {
    // Create an array of rects
    NSString* animationName = [[animationSelector selectedItem] title];

    NSMutableArray* frameRects = [NSMutableArray array];
    NSMutableArray* frameDurations = [NSMutableArray array];
    
    NSArray* frames = [[[animationGroupController animationGroup] objectForKey:@"animations"] objectForKey:animationName];

    for (NSDictionary* frame in frames) {
        CGRect subRect = CGRectMake([[[frame objectForKey:@"rect"] objectForKey:@"x"] intValue],
                                    [[[frame objectForKey:@"rect"] objectForKey:@"y"] intValue], 
                                    [[[frame objectForKey:@"rect"] objectForKey:@"width"] intValue], 
                                    [[[frame objectForKey:@"rect"] objectForKey:@"height"] intValue]);
        [frameRects addObject:[NSValue valueWithRect:subRect]];
        
        [frameDurations addObject:[NSNumber numberWithFloat:[[frame objectForKey:@"duration"] floatValue]]];
    }
    
    [self setCurrentAnimationFrames:frameRects];
    [self setCurrentAnimationDurations:frameDurations];
    currentAnimationIndex = 0;
    
    loopAnimation = YES;

    [self playAnimation];
}

-(IBAction)stopAnimation:(id)sender {
    loopAnimation = NO;
    [AnimatorAppDelegate cancelPreviousPerformRequestsWithTarget:self];
}


-(void)playAnimation {
    NSLog(@"playAnimation: %i", currentAnimationIndex);
    
    if ([self currentAnimationFrames] == nil ||
        [self currentAnimationDurations] == nil) {
        return;
    }
                                           
    if ([[self currentAnimationFrames] count] == 0) {
        return;
    }
    
    CGRect frame = [[currentAnimationFrames objectAtIndex:currentAnimationIndex] rectValue];

    [self setAnimationViewWithRect:frame];
    
    float duration = [[currentAnimationDurations objectAtIndex:currentAnimationIndex] floatValue];
    
    currentAnimationIndex++;

    if ([currentAnimationFrames count] > 1 && (currentAnimationIndex < [[self currentAnimationFrames] count] || loopAnimation)) {
        // Schedule display of next frame
        [self performSelector:@selector(playAnimation) withObject:nil afterDelay:duration];
    } 
    
    if (currentAnimationIndex == [[self currentAnimationFrames] count]) {
        // Reset index
        currentAnimationIndex = 0;
    }
}

-(void)setAnimationViewWithRect:(CGRect)rect {
    // Setting flippe dis required for correct frame coordinates
    [spritesheet setFlipped:YES];
    NSImage* subImage = [[NSImage alloc] initWithSize:rect.size];
    [subImage setFlipped:YES];
    
    
    // Draw the individual frame to an NSImage
    [subImage lockFocus];
    [spritesheet drawAtPoint: NSZeroPoint
                    fromRect: rect
                   operation: NSCompositeCopy
                    fraction: 1.0f];
    [subImage unlockFocus];
    
    
    // Now composite the individual frame to a scaled up image using NSImageInterpolationNone so we get nice clean lines
    NSImage* scaledImage = [[NSImage alloc] initWithSize:NSMakeSize(subImage.size.width * scale, subImage.size.height * scale)];
    
    [scaledImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
	[subImage setSize:scaledImage.size];
	[subImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
    [scaledImage unlockFocus];
    
    [animationView setImage:scaledImage];
    [subImage release];
    
    // Draw an outline around the current frame
    
    // TODO...
    
}

- (IBAction)animationSelectorChanged:(id)sender {
    [self setCurrentAnimationName:[[animationSelector selectedItem] title]];
    [self stopAnimation:sender];
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
    [self updateAnimationSelector];   
}


@end
