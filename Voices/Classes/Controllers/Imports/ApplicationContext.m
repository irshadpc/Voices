//
//  ApplicationContext.m
//  tangoair
//
//  Copyright 2011 XtremeMac. All rights reserved.
//

#import "ApplicationContext.h"
#import "FileController.h"
#import "DataController.h"
#import "AVController.h"
#import "VoiceModulationController.h"

#define LAZY_LOAD_PROPERTY(class, ivar) \
\
- (class *)ivar { \
    if (ivar == nil) { \
        ivar = [[class alloc] init]; \
    } \
    return ivar; \
}


@implementation ApplicationContext

@synthesize dataController, fileController, voiceModulationController, avController;

#pragma mark Boilerplate Singleton Implemenation

+ (ApplicationContext *)sharedInstance {
    static dispatch_once_t once = 0;
    __strong static id sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;    
}


#pragma mark Setup and Teardown Methods

- (id)init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


#pragma mark Accessor Methods

LAZY_LOAD_PROPERTY(DataController, dataController);
LAZY_LOAD_PROPERTY(FileController, fileController);
LAZY_LOAD_PROPERTY(VoiceModulationController, voiceModulationController);
LAZY_LOAD_PROPERTY(AVController, avController);

@end



































