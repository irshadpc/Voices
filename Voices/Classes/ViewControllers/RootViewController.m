//
//  RootViewController.m
//  Voices
//
//  Created by Greg Price on 2/26/13.
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
}

- (IBAction)selectRobotSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeRobot;
}

- (IBAction)selectChipmonkSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeChipmunk;
}

- (IBAction)selectSlowSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeSlow;
}

- (IBAction)selectEchoSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeEcho;
}

- (IBAction)selectDeepSound:(id)sender {
    [ApplicationContext sharedInstance].voiceModulationController.modulationType = ModulationTypeDeepVoice;
}

- (IBAction)record:(id)sender {
    [[ApplicationContext sharedInstance].avController startRecordingWithCompletionHandler:^(NSURL *savedURL) {
        NSLog(@"Finite %@", savedURL.absoluteString);
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
#pragma mark - Notification Subscription

- (void) subscribeToDSPCluster {
    [ApplicationContext sharedInstance].voiceModulationController.delegate = self;
}


@end
