//
//  BBHelper.m
//  CoreDataTestingMDC
//
//  Created by William Bruce on 12/31/16.
//  Copyright © 2016 aaos. All rights reserved.
//

#import "BBHelper.h"
#import "AppDelegate.h"

@implementation BBHelper

#pragma mark - String and Date Methods

+ (NSString*)stringFromNSInteger:(NSNumber*) theNumber {
    NSString *theString = [[NSString alloc] initWithString:[theNumber stringValue]];
    //NSString *responseStrring = [NSString stringWithFormat:@"%@", theString];
    return theString;
}


+ (NSString*)getDateTimeStampString {
    //yyyy-MM-ddTHH:mm:ss.fff yyyy-MM-ddTHH:mm:ss.SSS in obj-c
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    NSDate *date = [NSDate date];
    
    NSString *response = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    return response;
}

+ (NSString*)getDateTimeStampFromNSDate:(NSDate *)date {
    //yyyy-MM-ddTHH:mm:ss.fff yyyy-MM-ddTHH:mm:ss.SSS in obj-c
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    
    NSString *response = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    return response;
}

+ (NSDate *)getDateFromTimeStampString:(NSString *) dateString {
    if(!dateString)
        return nil;
    if(![dateString isKindOfClass:[NSString class]])
        return nil;
    
    //yyyy-MM-ddTHH:mm:ss.fff
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate* date = [df dateFromString:dateString];
    //NSLog(@"\n  datestring: %@\n  date: %@", dateString, date);
    return date;
}

@end































