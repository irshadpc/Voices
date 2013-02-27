//
//  RPAbstractViewController.h
//  tangoair
//
/// This is the base view controller class for the platform.
// 
//  Copyright 2011 XtremeMac. All rights reserved.
//


@protocol AbstractViewControllerDelegate <NSObject>

@optional
- (void) abstractViewControllerSentArray: (NSArray *) array;
- (void) abstractViewControllerSentDictionary: (NSDictionary*) dictionary;
- (void) abstractViewControllerSentObject: (id) object;

@required
- (void)abstractViewControllerDone;

@end

@interface AbstractViewController : UIViewController {

@protected
	NSDictionary *configurationDictionary;	
}

@property (nonatomic, assign) id<AbstractViewControllerDelegate> delegate;
@property (nonatomic, assign) SEL enableBackSelector;
@property (nonatomic, assign) SEL disableBackSelector;
@property (strong, nonatomic) id forwardingObject;

@end

@interface AbstractViewController()

- (void)cleanup;

@end
