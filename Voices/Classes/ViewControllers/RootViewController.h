//
//  RootViewController.h
//  Voices
//
//  Created by Greg Price on 1/16/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "VoiceModulationController.h"

@interface RootViewController : AbstractViewController <AbstractViewControllerDelegate, VoiceModulationDelegate>

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@end
