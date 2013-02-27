//
//  AppDelegate.h
//  Voices
//
//  Created by Greg Price on 2/26/13.
//  Copyright (c) 2013 XtremeMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) RootViewController *rootViewController;

@end
