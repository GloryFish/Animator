//
//  AnimationGroupController.h
//  Animator
//
//  Created by Jay Roberts on 9/19/11.
//  Copyright 2011 GloryFish.org. All rights reserved.
//

#import "SBJson.h"
#import <Quartz/Quartz.h>

@interface AnimationGroupController : NSObject {

    NSMutableDictionary* animationGroup;
    SBJsonWriter* codeWriter;
}

@property (nonatomic, retain) NSMutableDictionary* animationGroup;

-(void)resetAnimationGroup;
-(void)setSpritesheetFilename:(NSString*)filename;
-(NSString*)code;
-(void)newAnimation;
-(void)newFrame:(NSString*)animationName;
-(NSMutableDictionary*)emptyFrame;
-(bool)parseFromCode:(NSString*)code;
-(bool)groupIsValid:(NSDictionary*)group;

@end
