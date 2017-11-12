//
//  BBHelper.h
//  CoreDataTestingMDC
//
//  Created by William Bruce on 12/31/16.
//  Copyright © 2016 aaos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBHelper : NSObject

/**
 Converts an NSNumber into a String
 [Tis is a mostly redundant method and is not usually needed.  If ever.]
 There are times when farming this conversion to an outside method is cleaner from a coding perspective than doing an inline cast.

 @param theNumber Should be Integer
 @return String of the number
 */
+ (NSString*)stringFromNSInteger:(NSNumber*) theNumber;


/**
 Creates a timestamp string that can be used with the AAOS Client API.

 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getDateTimeStampString;

+ (NSString*)getDateTimeStampFromNSDate:(NSDate *)date;

/**
 Provides an NSDate object with the values of an AAOS API Datestring

 @param dateString yyyy-MM-ddTHH:mm:ss.fff 
 @return NSDate
 */
+ (NSDate *)getDateFromTimeStampString:(NSString *) dateString;



@end
