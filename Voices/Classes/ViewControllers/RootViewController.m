//
//  RootViewController.m
//  Voices
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import "RootViewController.h"
#import "AVController.h"
#import "ApplicationContext.h"
#import "Constants.h"


@interface RootViewController ()

@property (strong, nonatomic) NSURL *sessionSoundURL;

@end

@implementation RootViewController

@synthesize sessionSoundURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Voices";
    self.statusLabel.text = @"Alien is set";
    self.playButton.hidden = YES;
    [self subscribeToDSPCluster];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - AbstractViewController Delegate

- (void) abstractViewControllerDone {
    
}


#pragma mark -
#pragma mark - Actions

- (IBAction)selectAlienSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeAlien;
     self.statusLabel.text = @"Alien is set!";
}

- (IBAction)selectRobotSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeHyper;
    self.statusLabel.text = @"Hyper is set!";
}

- (IBAction)selectChipmonkSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeChipmunk;
    self.statusLabel.text = @"Chip is set!";
}

- (IBAction)selectSlowSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeSlow;
    self.statusLabel.text = @"Slow voice is set!";
}

- (IBAction)selectEchoSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeEcho;
    self.statusLabel.text = @"Echo is set!";
}

- (IBAction)selectDeepSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeDeepVoice;
    self.statusLabel.text = @"Deep is set!";
}

- (IBAction)record:(id)sender {
    [[ApplicationContext sharedInstance].avController startRecordingWithCompletionHandler:^(NSURL *savedURL) {
        self.playButton.hidden = NO;
        sessionSoundURL = savedURL;
    }];
}

- (IBAction)play:(id)sender {
    if (sessionSoundURL) {
        [[ApplicationContext sharedInstance].voiceModulationController playbackRecordingFromURL:sessionSoundURL];
    }
}

- (IBAction)stop:(id)sender {
    [[ApplicationContext sharedInstance].avController stopRecording];
}


#pragma mark -
#pragma mark - Subscriptions

- (void) subscribeToDSPCluster {
    [ApplicationContext sharedInstance].voiceModulationController.delegate = self;
}


#pragma mark -
#pragma mark - SoundMod Delegates

- (void) soundFinishedModulationAtUrl:(NSURL *)url
                             withType:(ModulationType)type {
    self.playButton.hidden = YES;
}

@end
