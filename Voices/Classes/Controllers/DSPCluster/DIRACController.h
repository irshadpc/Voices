//
//  DIRACController.h
//  Voices
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>
#include "Dirac.h"
#include <stdio.h>
#include <sys/time.h>
#import "EAFRead.h"
#import "EAFWrite.h"
#import "VoiceModulationController.h"


@interface DIRACController : NSObject <DSPClusterProtocol, AVAudioPlayerDelegate, AVAudioRecorderDelegate>

void DeallocateAudioBuffer(float **audio, int numChannels);
float **AllocateAudioBuffer(int numChannels, int numFrames);

- (void) stopPlaying;

@end
