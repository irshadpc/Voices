//
//  VoiceModulationDelegate.h
//  Voices
//
//  Created by Greg Price on 2/26/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VoiceModulationDelegate <NSObject>

@optional
-(void)soundFinishedModulationAtUrl:(NSURL*)url
                           withType:(ModulationType) type;

@end
