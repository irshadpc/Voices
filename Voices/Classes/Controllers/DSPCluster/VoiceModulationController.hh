//
//  VoiceModulationController.h
//  VoiceChanger
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@protocol VoiceModulationDelegate <NSObject>

@optional
-(void)soundFinishedModulationAtUrl:(NSURL*)url withType: (ModulationType) type;

@end


@protocol DSPClusterProtocol <NSObject>

@required
- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL* outUrl)) handle;

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL* outUrl)) handle
      andModulationType: (ModulationType) modulationType;

- (void) stopPlaying;

@end


@interface VoiceModulationController : NSObject

@property (nonatomic) ModulationType modulationType;

@property (assign) id<VoiceModulationDelegate> delegate;

- (void) playbackRecordingFromURL:(NSURL*)url;

- (void) stopPlaying;

@end
