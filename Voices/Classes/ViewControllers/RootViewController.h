//
//  RootViewController.h
//  Voices
//
//  Created by Greg Price

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "VoiceModulationController.h"

@interface RootViewController : AbstractViewController <AbstractViewControllerDelegate, VoiceModulationDelegate>

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@end
