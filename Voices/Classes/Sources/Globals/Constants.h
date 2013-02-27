//
//  Constants.h
//  Voices
//
//  Created by Greg Price
//


typedef enum {
    ModulationTypeAlien,
    ModulationTypeRobot,
    ModulationTypeChipmunk,
    ModulationTypeHyper,
    ModulationTypeSlow,
    ModulationTypeEcho,
    ModulationTypeDeepVoice,
    ModulationTypeUnderwater,
    ModulationTypeHelium
} ModulationType;

typedef enum {
    ModulationSourceDirac,
    ModulationSourceFmod
} ModulationSource;

#pragma mark Service Constants

extern NSString * const kServicesSecretToken;
extern NSString * const kServicesHeaderContentType;
extern NSString * const kServicesHeaderAccept;
extern NSString * const kServicesHeaderMethodGet;
extern NSString * const kServicesHeaderMethodPost;
extern NSString * const kServicesHeaderMethodDelete;
extern NSString * const kServicesHeaderPut;



#pragma mark Directories

extern NSString * const kCacheDirectoryPath;


#pragma mark Services

extern NSString * const kServicesBaseURL;


#pragma mark Error Messges

extern NSString * const kErrorAlertMessageStandard;




































