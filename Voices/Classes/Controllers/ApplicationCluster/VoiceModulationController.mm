//
//  VoiceModulationController.m
//  VoiceChanger
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import "VoiceModulationController.hh"
#import "ApplicationContext.h"
#import "DSPContext.h"
#import "DIRACController.h"
#import "FMODController.hh"
#import "AVController.h"
#import "DataController.h"
#import "Constants.h"

@interface VoiceModulationController()

@property (strong, nonatomic) FMODController *fmodController;
@property (strong, nonatomic) DIRACController *diracController;
@property (strong, nonatomic) NSURL *currentRecording;
@property (assign) id<DSPClusterProtocol> aDelegate;
@property (nonatomic) BOOL recording;
@property (nonatomic) BOOL playing;

@end

@implementation VoiceModulationController

@synthesize fmodController, diracController, recording, playing, currentRecording, aDelegate;

-(id) init {
	if( (self=[super init])) {
        // DIRAC parameters
        self.modulationType = ModulationTypeAlien;
    }
    return self;
}


#pragma mark -
#pragma mark - Public Methods

- (void) playbackRecordingFromURL:(NSURL*) url {
     aDelegate = [self chooseModulationSource:self.modulationType];
    __block ModulationType type = self.modulationType;
    [aDelegate playSoundAtUrl:url
        withCompletionHandler:^(NSURL *outUrl){
            if (outUrl) {
                [[ApplicationContext sharedInstance].avController playSoundAtURL:outUrl];
                if ([self.delegate respondsToSelector:@selector(soundFinishedModulationAtUrl::)]) {
                    [self.delegate soundFinishedModulationAtUrl:outUrl
                                                       withType:type];
                }
            }
       }andModulationType:self.modulationType];
}

- (void) stopPlaying {
    if (aDelegate) {
        [aDelegate stopPlaying];
    }
}


#pragma mark -
#pragma mark - Worker Methods

- (id<DSPClusterProtocol>) chooseModulationSource: (ModulationType) type {
    if (aDelegate) {
        aDelegate = nil;
    }
    if (type == ModulationTypeEcho) {
        return [DSPContext sharedInstance].fmodController;
    }
    return [DSPContext sharedInstance].diracController;
}

@end
