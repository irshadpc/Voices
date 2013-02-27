//
//  DIRACController.m
//  Voices
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//


#import "DIRACController.h"

double gExecTimeTotal = 0.;

@interface DIRACController()

@property (readonly) EAFRead *reader;
@property (readonly) EAFWrite *writer;

@property (assign) float time;
@property (assign) float pitch;
@property (assign) float formant;
@property (assign) float percent;
@property (assign) float silenceTime;

@property (assign) BOOL isRecording;
@property (assign) BOOL isPlaying;

@property (strong, nonatomic) NSURL *monitorTempFile;
@property (strong, nonatomic) NSURL *inUrl;
@property (strong, nonatomic) NSURL *outUrl;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) void (^completionBlock)(NSURL *url);

@end

@implementation DIRACController

@synthesize time, pitch, formant, percent, silenceTime, monitorTempFile, inUrl, outUrl, recorder, player, error, reader, writer, isPlaying, isRecording, completionBlock;

-(id) init {
	if((self=[super init])) {
        // DIRAC parameters
        time      = 3;
        pitch     = 1;
        formant   = pow(1., 0./15.);
    }
    return self;
}



#pragma mark -
#pragma mark Public Methods

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL *)) handle
      andModulationType: (ModulationType) modulationType {
    inUrl = url;
    reader = [[EAFRead alloc] init];
	writer = [[EAFWrite alloc] init];
    self.completionBlock = handle;
    [self setParamsWithType:modulationType];
	[self beginDiracConversion];
}

- (void) playSoundAtUrl: (NSURL*) url
  withCompletionHandler: (void (^)(NSURL* outUrl)) handle {
    inUrl = url;
    reader = [[EAFRead alloc] init];
	writer = [[EAFWrite alloc] init];
    self.completionBlock = handle;
	[self beginDiracConversion];
}

- (void) stopPlaying {
    
}


#pragma mark -
#pragma mark Worker Methods

#pragma mark Dirac Conversion

- (void) setParamsWithType:(ModulationType) type {
    switch (type) {
        case ModulationTypeAlien:
            //MAGIC NUMBERS!
            time = .63;
            pitch = 1.33;
            formant = pow(2.64, 0./8.04);
            break;
        case ModulationTypeChipmunk:
            time = .65;
            pitch = 2.0;
            formant = pow(2.0, 0./2.0);
            break;
        case ModulationTypeDeepVoice:
            time = 1.3;
            pitch = .7;
            formant = pow(1.0, 0./1.0);
            break;
        case ModulationTypeHelium:
            time = 2.0;
            pitch = 1.8;
            formant = pow(1.0, 0./1.0);
            break;
        case ModulationTypeHyper:
            time = .65;
            pitch = 1.0;
            formant = pow(1.0, 0./1.0);
            break;
        case ModulationTypeSlow:
            time = 6;
            pitch = 1.0;
            formant = pow(1.0, 0./1.0);
        default:
            break;
    }
}

- (void) beginDiracConversion {
    NSString *outputSound = [[[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:@"out.aif"] retain];
	outUrl = [[NSURL fileURLWithPath:outputSound] retain];
	reader = [[EAFRead alloc] init];
	writer = [[EAFWrite alloc] init];
    
	// this thread does the processing
	[NSThread detachNewThreadSelector:@selector(processThread:)
                             toTarget:self
                           withObject:nil];
}

-(void)processThread:(id)param {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	long numChannels = 1;		
	float sampleRate = 44100;
    
	// open input file
	[reader openFileForRead:inUrl
                         sr:sampleRate
                   channels:numChannels];
	
	// create output file (overwrite if exists)
	[writer openFileForWrite:outUrl
                          sr:sampleRate
                    channels:numChannels
                  wordLength:16
                        type:kAudioFileAIFFType];
	
	void *dirac = DiracCreate(kDiracLambdaPreview,
                              kDiracQualityPreview,
                              numChannels,
                              sampleRate,
                              &myReadData,
                              (void*)self);
	
	if (!dirac) {
		printf("!! ERROR !!\n\n\tCould not create DIRAC instance\n\tCheck number of channels and sample rate!\n");
		printf("\n\tNote that the free DIRAC LE library supports only\n\tone channel per instance\n\n\n");
		exit(-1);
	}
	
	// Pass the values to our DIRAC instance
	DiracSetProperty(kDiracPropertyTimeFactor, time, dirac);
	DiracSetProperty(kDiracPropertyPitchFactor, pitch, dirac);
	DiracSetProperty(kDiracPropertyFormantFactor, formant, dirac);
    
	if (pitch > 1.0)
		DiracSetProperty(kDiracPropertyUseConstantCpuPitchShift, 1, dirac);
    
	NSLog(@"Running DIRAC version %s\nStarting processing", DiracVersion());
	
	// Get the number of frames from the file to display our simplistic progress bar
	SInt64 numf = [reader fileNumFrames];
	SInt64 outframes = 0;
	SInt64 newOutframe = numf*time;
	long lastPercent = -1;
	percent = 0;
	
	// This is an arbitrary number of frames per call
	long numFrames = 8192;
	
	// Allocate buffer for output
	float **audio = AllocateAudioBuffer(numChannels, numFrames);
    
	double bavg = 0;
	
	// Processing Loop
	for(;;) {
		// Display ASCII style "progress bar"
		percent = 100.f*(double)outframes / (double)newOutframe;
		long ipercent = percent;
		if (lastPercent != percent) {
            
            lastPercent = ipercent;
			fflush(stdout);
		}
		
		DiracStartClock();								
		
		// Call the DIRAC process function with current time and pitch settings
		// Returns: the number of frames in audio
		long ret = DiracProcess(audio, numFrames, dirac);
		bavg += (numFrames/sampleRate);
		gExecTimeTotal += DiracClockTimeSeconds();		
		
        /**
         printf("x realtime = %3.3f : 1 (DSP only), CPU load (peak, DSP+disk): %3.2f%%\n", bavg/gExecTimeTotal, DiracPeakCpuUsagePercent(dirac));
         **/
        
		// Process only as many frames as needed
		long framesToWrite = numFrames;
		unsigned long nextWrite = outframes + numFrames;
		if (nextWrite > newOutframe) framesToWrite = numFrames - nextWrite + newOutframe;
		if (framesToWrite < 0) framesToWrite = 0;
		
		// Write the data to the output file
		[writer writeFloats:framesToWrite
                  fromArray:audio];
		
		// Increase our counter for the progress bar
		outframes += numFrames;
		
		// As soon as we've written enough frames we exit the main loop
		if (ret <= 0) break;
	}
	
	percent = 100;
	
	// Free buffer for output
	DeallocateAudioBuffer(audio, numChannels);
	
	// destroy DIRAC instance
	DiracDestroy(dirac);
	
	// Done!
	NSLog(@"\nDone!");
	[reader release];
    [writer release];
	// start playback on main thread
	[self performSelectorOnMainThread:@selector(finishProcess)
                           withObject:nil
                        waitUntilDone:NO];
    [pool release];
}

- (void) finishProcess {
    NSLog(@"Finsh Process %@", outUrl.absoluteString);
    self.completionBlock(outUrl);
}


#pragma mark -
#pragma mark Functions

#pragma mark Callback

long myReadData(float **chdata, long numFrames, void *userData) {
	if (!chdata)	return 0;
	
	DIRACController *Self = (DIRACController*)userData;
	if (!Self)	return 0;
    gExecTimeTotal += DiracClockTimeSeconds(); 		
	OSStatus err = [Self.reader readFloatsConsecutive:numFrames
                                            intoArray:chdata];
	DiracStartClock();								
	return err;
}

#pragma mark Convenience

void DeallocateAudioBuffer(float **audio, int numChannels) {
	if (!audio) return;
	for (long v = 0; v < numChannels; v++) {
		if (audio[v]) {
			free(audio[v]);
			audio[v] = NULL;
		}
	}
	free(audio);
	audio = NULL;
}

float **AllocateAudioBuffer(int numChannels, int numFrames) {
	// Allocate buffer for output
	float **audio = (float**)malloc(numChannels*sizeof(float*));
	if (!audio) return NULL;
	memset(audio, 0, numChannels*sizeof(float*));
	for (long v = 0; v < numChannels; v++) {
		audio[v] = (float*)malloc(numFrames*sizeof(float));
		if (!audio[v]) {
			DeallocateAudioBuffer(audio, numChannels);
			return NULL;
		}
		else memset(audio[v], 0, numFrames*sizeof(float));
	}
	return audio;
}
@end
