//
//  AVController.m
//  VoiceChanger
//
//  Created by Greg Price on 1/18/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import "AVController.h"

@interface AVController()

@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) void (^completionBlock)(NSURL *audioOutUrl);
@property (nonatomic) NSInteger count;

@end

@implementation AVController

@synthesize recorder, player;


-(id) init {
	if( (self=[super init])) {
        [self initAudioRecorder];
        self.count = 0;
    }
    return self;
}

#pragma mark -
#pragma mark Public Methods

-(void)startRecording {
    [recorder record];
}

-(void)startRecordingWithCompletionHandler: (void (^)(NSURL *audioOutUrl)) block {
    self.recorder = nil;
    [self initAudioRecorder];
    self.completionBlock = block;
    [recorder record];
}

-(void)stopRecording {
    [recorder stop];
    self.completionBlock(recorder.url);
}

-(void)playSoundAtURL:(NSURL *) url {
    NSLog(@"URL = %@", url.absoluteString);
    player = nil;
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                    error:&error];
	if (error)
		NSLog(@"AVAudioPlayer error %@, %@", error, [error userInfo]);
    
	[player play];
    NSLog(@"Play");
}


#pragma mark -
#pragma mark Init Methods

-(void) initAudioRecorder {
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4]
                     forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0]
                     forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1]
                     forKey:AVNumberOfChannelsKey];
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* fullFilePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"in.caf"]];
    self.count++;
    NSError *error;
    recorder = [[ AVAudioRecorder alloc] initWithURL: [NSURL fileURLWithPath:fullFilePath]
                                            settings:recordSetting
                                               error:&error];
    [recorder setMeteringEnabled:YES];
    [recorder prepareToRecord];
    NSLog(@"IN %@", recorder.url.absoluteString);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Done");
}

@end
