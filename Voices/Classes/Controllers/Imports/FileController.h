//
//  FileController.h
//  tangoair
//
//  Created by Logan Cautrell on 8/19/11.
//  Copyright 2011 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileController : NSObject

- (NSDictionary *)loadPlistDictionary:(NSString *)plistName;
- (NSDictionary *)loadPlistArray:(NSString *)plistName;
- (NSString *)pathToDocuments;

@end
