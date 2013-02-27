//
//  NSString+Additions.h
//  tangoair
//
//  Copyright 2011 XtremeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)stringByURLEncoding;
- (NSString *)stringByHtmlifying;
- (NSString *)uncapitalizeFirstCharacter;
- (NSString *)capitalizeFirstCharacter;
+ (NSString *)localizedDateStringWithUnixTimestamp:(NSInteger)unixTimeStamp withTime:(BOOL)withTime;
+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
- (NSString *)md5;
+ (NSString *)ordinalStringForNumber:(NSInteger)number; 
- (NSString *)stringByStrippingExtraWhiteSpace;

@end


