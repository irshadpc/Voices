//
//  RootViewController.h
//  Voices
//
//  Created by Greg Price


#import "AbstractViewController.h"
#import "ApplicationContext.h"
#import "FileController.h"

@interface AbstractViewController()

- (void)doInit;

@end

@implementation AbstractViewController

@synthesize delegate;
@synthesize enableBackSelector, disableBackSelector, forwardingObject;

#pragma mark Setup and Teardown Methods

- (id)init {
	self = [super initWithNibName:nil
                           bundle:nil];
	if (self != nil) {
        [self doInit];
	}
	return self;
} 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
        [self doInit];
	}
	return self;
}

- (void)doInit {
    configurationDictionary = [[[ApplicationContext sharedInstance] fileController]
                               loadPlistDictionary:NSStringFromClass([self class])];
}

- (void)dealloc {
	[self cleanup];
}

- (void)cleanup {
}


#pragma mark Override Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {	
    [super viewDidLoad];
}

- (void)viewDidUnload {
	[self cleanup];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {	
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end


















