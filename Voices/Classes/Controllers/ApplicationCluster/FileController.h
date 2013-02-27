

//
//  FileController.h
//  CD
//
//  Created by Greg Price on 6/22/12.
//

#import <Foundation/Foundation.h>

@interface FileController : NSObject

- (NSDictionary *)loadPlistDictionary:(NSString *)plistName;
- (NSDictionary *)loadPlistArray:(NSString *)plistName;
- (NSString *)pathToDocuments;

@end
