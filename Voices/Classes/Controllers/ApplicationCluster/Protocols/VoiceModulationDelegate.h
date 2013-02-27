//
//  VoiceModulationDelegate.h
//  Voices
//
//  Created by Greg Price

#import <Foundation/Foundation.h>

@protocol VoiceModulationDelegate <NSObject>

@optional
-(void)soundFinishedModulationAtUrl:(NSURL*)url
                           withType:(ModulationType) type;

@end
