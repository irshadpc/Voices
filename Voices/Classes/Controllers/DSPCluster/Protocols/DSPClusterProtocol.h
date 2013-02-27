//
//  DSPClusterProtocol.h
//  Voices
//
//  Created by Greg Price on 2/26/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSPClusterProtocol <NSObject>

@required
- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL* outUrl)) handle;

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL* outUrl)) handle
      andModulationType: (ModulationType) modulationType;

- (void) stopPlaying;

@end

