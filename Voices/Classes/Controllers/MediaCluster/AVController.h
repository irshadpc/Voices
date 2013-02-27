//
//  AVController.h
//  VoiceChanger
//
//  Created by Greg Price on 1/18/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVController : NSObject <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSURL *outURL;

-(void)startRecording;

-(void)startRecordingWithCompletionHandler: (void (^)(NSURL *audioOutUrl)) block;

-(void)stopRecording;

-(void)playSoundAtURL:(NSURL *) url;

@end
