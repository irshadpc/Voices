//
//  DSPContext.h
//  Voices
//
//  Created by Greg Price on 2/26/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DIRACController;
@class FMODController;

@interface DSPContext : NSObject

@property (nonatomic, strong, readonly) DIRACController *diracController;
@property (nonatomic, strong, readonly) FMODController *fmodController;

+ (DSPContext *)sharedInstance;

@end
