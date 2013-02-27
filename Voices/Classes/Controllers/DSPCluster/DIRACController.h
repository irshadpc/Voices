//
//  RootViewController.h
//  Voices
//
//  Created by Greg Price



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
