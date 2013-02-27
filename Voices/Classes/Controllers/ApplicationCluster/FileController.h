

#import <Foundation/Foundation.h>

@interface FileController : NSObject

- (NSDictionary *)loadPlistDictionary:(NSString *)plistName;
- (NSDictionary *)loadPlistArray:(NSString *)plistName;
- (NSString *)pathToDocuments;

@end
