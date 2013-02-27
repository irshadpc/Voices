//
//  FMODController.h
//  VoiceChanger
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VoiceModulationController.hh"
#import "fmod.hpp"
#import "fmod_errors.h"
#import "Constants.h"

@interface FMODController : NSObject <DSPClusterProtocol> {
    FMOD::System   *system;
    FMOD::Sound    *sound;
    FMOD::Channel  *channel;
    FMOD::DSP      *dsplowpass;
    FMOD::DSP      *dsphighpass;
    FMOD::DSP      *dspecho;
    FMOD::DSP      *dspflange;
    FMOD::DSP      *dspdistortion;
    FMOD::DSP      *dspchorus;
    FMOD::DSP      *dspparameq;
}

@property (nonatomic) ModulationType modulationType;



@end
