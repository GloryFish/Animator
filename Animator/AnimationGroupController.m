//
//  AnimationGroupController.m
//  Animator
//
//  Created by Jay Roberts on 9/19/11.
//  Copyright 2011 GloryFish.org. All rights reserved.
//

#import "AnimationGroupController.h"
#import "SBJson.h"

@implementation AnimationGroupController

@synthesize animationGroup;

-(id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
        codeWriter = [[SBJsonWriter alloc] init];
        codeWriter.humanReadable = YES;
        
        [self resetAnimationGroup];
    }
    
    return self;
}

// Creates a blank animationGroup
-(void)resetAnimationGroup {
    NSMutableDictionary* ag = [NSMutableDictionary dictionary];
    [ag setObject:@"" forKey:@"spritesheet"];
    
    NSMutableDictionary* animations = [NSMutableDictionary dictionary];
    
    
    [ag setObject:animations forKey:@"animations"];

    NSMutableDictionary* frame = [self emptyFrame];
    NSMutableArray* frames = [NSMutableArray arrayWithObject:frame];

    [animations setObject:frames forKey:@"animationName"];
    
    [ag setObject:animations forKey:@"animations"];
    
    [self setAnimationGroup:ag];
}

-(void)setSpritesheetFilename:(NSString*)filename {
    [[self animationGroup] setObject:filename forKey:@"spritesheet"];
}

// Return a text representation of the AnimationGroup
-(NSString*)code {
    return [codeWriter stringWithObject:animationGroup];
}

-(void)newAnimation {
    NSString* animationName = [NSString stringWithFormat:@"animationName%i", [[animationGroup objectForKey:@"animations"] count] + 1];
    
    
    NSMutableArray* frames = [NSMutableArray arrayWithObject:[self emptyFrame]];
    
    [[animationGroup objectForKey:@"animations"] setObject:frames forKey:animationName]; 
}

-(void)newFrame:(NSString*)animationName {
    
}

-(NSMutableDictionary*)emptyFrame {
    NSMutableDictionary* frame = [NSMutableDictionary dictionary];
    
    NSMutableDictionary* rect = [NSMutableDictionary dictionary];
    [rect setObject:[NSNumber numberWithInt:0] forKey:@"x"];
    [rect setObject:[NSNumber numberWithInt:0] forKey:@"y"];
    [rect setObject:[NSNumber numberWithInt:0] forKey:@"width"];
    [rect setObject:[NSNumber numberWithInt:0] forKey:@"height"];
    
    [frame setObject:rect forKey:@"rect"];
    [frame setObject:[NSNumber numberWithFloat:1.0] forKey:@"duration"];
    return frame;
}

-(void)dealloc {
    [codeWriter release];
}

@end
