//
//  FileController.m
//  tangoair
//
//  Created by Logan Cautrell on 8/19/11.
//  Copyright 2011 XtremeMac. All rights reserved.
//

#import "Constants.h"
#import "FileController.h"
#import "NSString+Additions.h"

@interface FileController()

- (NSString *)plistPathForName:(NSString *)plistName;

@end


@implementation FileController


#pragma mark Setup and Teardown Methods

- (id)init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


#pragma mark Public Methods

- (NSDictionary *)loadPlistDictionary:(NSString *)plistName {
	NSString *myPlistPath = [self plistPathForName:plistName];
	return [NSDictionary dictionaryWithContentsOfFile:myPlistPath];
}

- (NSDictionary *)loadPlistArray:(NSString *)plistName {
	NSString *myPlistPath = [self plistPathForName:plistName];
	return [NSArray arrayWithContentsOfFile:myPlistPath];
}

- (NSString *)pathToDocuments {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    return [paths lastObject];
}

#pragma mark Implementation Methods

- (NSString *)plistPathForName:(NSString *)plistName {
	plistName = [plistName capitalizeFirstCharacter];
	if ([plistName rangeOfString:@".plist"].location != NSNotFound) {
		plistName = [plistName stringByReplacingOccurrencesOfString:@".plist" withString:@""];
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *path = [[[paths lastObject] stringByAppendingPathComponent:kCacheDirectoryPath] 
					  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
	}
    
	return path;
}


@end
