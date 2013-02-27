//
//  VoiceModulationController.h
//  VoiceChanger
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "VoiceModulationDelegate.h"
#import "DSPClusterProtocol.h"


@interface VoiceModulationController : NSObject

@property (nonatomic) ModulationType modulationType;

@property (assign) id<VoiceModulationDelegate> delegate;

- (void) playbackRecordingFromURL:(NSURL*)url;

- (void) stopPlaying;

@end
