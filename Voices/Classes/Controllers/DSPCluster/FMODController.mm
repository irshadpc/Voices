//
//  RootViewController.h
//  Voices
//
//  Created by Greg Price


#import "FMODController.hh"


@interface FMODController()

@property (strong, nonatomic) NSTimer *timer;
@property (copy) void (^completionBlock)(NSURL *);
@property (nonatomic) NSInteger count;

@end


@implementation FMODController

@synthesize timer, count;

-(id) init {
	if( (self=[super init])) {
        [self initDSP];
        [self setDSP];
    }
    return self;
}

#pragma mark -
#pragma mark - Public Methods

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL*)) handle {
    self.completionBlock = handle;
    FMOD_RESULT result = FMOD_OK;
    char buffer[200] = {0};
    [url.absoluteString getCString:buffer
                         maxLength:200
                          encoding:NSASCIIStringEncoding];
  
    result = system->createSound(buffer,
                                 FMOD_SOFTWARE,
                                 NULL,
                                 &sound);
    
    ERRCHECK(result);
    
    result = system->playSound(FMOD_CHANNEL_FREE,
                               sound,
                               false,
                               &channel);
    ERRCHECK(result);
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                             target:self
                                           selector:@selector(statusUpdate:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL*)) handle
       andModulationType: (ModulationType) modulationType {
    
    self.completionBlock = handle;
    self.modulationType = modulationType;
    FMOD_RESULT result = FMOD_OK;
    char buffer[200] = {0};
    NSString *tFileName=[NSString stringWithFormat:@"%@/in.caf", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [tFileName getCString:buffer
                         maxLength:200
                          encoding:NSASCIIStringEncoding];
    result = system->createSound(buffer,
                                 FMOD_SOFTWARE,
                                 NULL,
                                 &sound);
    ERRCHECK(result);
    result = system->playSound(FMOD_CHANNEL_FREE,
                               sound,
                               false,
                               &channel);
    ERRCHECK(result);
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                             target:self
                                           selector:@selector(statusUpdate:)
                                           userInfo:nil
                                            repeats:YES];
}


#pragma mark -
#pragma mark - Worker Methods

- (void)statusUpdate:(NSTimer *)timer{
    FMOD_RESULT result  = FMOD_OK;
    bool playing = false;
    bool paused = false;
    
    if (channel != NULL) {
        
        result = channel->isPlaying(&playing);
        if ((result != FMOD_OK) &&
            (result != FMOD_ERR_INVALID_HANDLE) &&
            (result != FMOD_ERR_CHANNEL_STOLEN)){
                ERRCHECK(result);
        }
        
        result = channel->getPaused(&paused);
        if ((result != FMOD_OK) &&
            (result != FMOD_ERR_INVALID_HANDLE) &&
            (result != FMOD_ERR_CHANNEL_STOLEN)){
                ERRCHECK(result);
        }
    }
    
    if (system != NULL) {
        result = system->update();
        ERRCHECK(result);
    }
    
    if (!playing) {
        [self completeProcess];
    }
}

- (void) completeProcess {
    [timer invalidate];
    if (sound) {
        sound->release();
        sound = NULL;
    }
    
    if (system){
        system->release();
        system = NULL;
    }
    self.completionBlock(nil);
}

- (void) setDSP {
    FMOD_RESULT result  = FMOD_OK;
    result = system->addDSP(dspecho, NULL);
    ERRCHECK(result);
    result = dspecho->setParameter(FMOD_DSP_ECHO_DELAY, 50.0f);
    ERRCHECK(result);
}


#pragma mark -
#pragma mark - Init Methods

- (void) initDSP {
    FMOD_RESULT result = FMOD_OK;
    unsigned int version = 0;
    
    result = FMOD::System_Create(&system);
    ERRCHECK(result);
    result = system->getVersion(&version);
    ERRCHECK(result);
    
    result = system->init(32,
                          FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE,
                          NULL);
    ERRCHECK(result);
    
    result = system->createDSPByType(FMOD_DSP_TYPE_ECHO, &dspecho);
    ERRCHECK(result);
    
}


#pragma mark -
#pragma mark - Functions

void ERRCHECK(FMOD_RESULT result)
{
    if (result != FMOD_OK) {
        fprintf(stderr, "FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
        exit(-1);
    }
}

@end
