//
//  ApplicationContext.h
//  tangoair
//
//  Copyright 2011 XtremeMac. All rights reserved.
//

@class DataController;
@class FileController;
@class AVController;
@class VoiceModulationController;


@interface ApplicationContext : NSObject {

}

@property (nonatomic, retain, readonly) DataController *dataController;
@property (nonatomic, retain, readonly) FileController *fileController;
@property (nonatomic, retain, readonly) VoiceModulationController *voiceModulationController;
@property (nonatomic, retain, readonly) AVController *avController;

+ (ApplicationContext *)sharedInstance;

@end
