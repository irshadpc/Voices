//
//  DSPContext.m
//  Voices
//
//  Created by Greg Price on 2/26/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import "DSPContext.h"
#import "DIRACController.h"
#import "FMODController.hh"


#define LAZY_LOAD_PROPERTY(class, ivar) \
\
- (class *)ivar { \
    if (ivar == nil) { \
        ivar = [[class alloc] init]; \
    } \
    return ivar; \
}

@implementation DSPContext

@synthesize diracController, fmodController;

#pragma mark Boilerplate Singleton Implemenation

+ (DSPContext *)sharedInstance {
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

LAZY_LOAD_PROPERTY(DIRACController, diracController);
LAZY_LOAD_PROPERTY(FMODController, fmodController);

@end
