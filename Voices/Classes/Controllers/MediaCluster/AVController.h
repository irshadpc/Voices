//
//  AVController.h
//  Voices
//
//  Created by Greg Price


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVController : NSObject <AVAudioPlayerDelegate>

@property (strong, nonatomic) NSURL *outURL;

-(void)startRecording;

-(void)startRecordingWithCompletionHandler: (void (^)(NSURL *audioOutUrl)) block;

-(void)stopRecording;

-(void)playSoundAtURL:(NSURL *) url;

@end
