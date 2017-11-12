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


+ (NSString*)getTimeStamp {
    //yyyy-MM-ddTHH:mm:ss.fff yyyy-MM-ddTHH:mm:ss.SSS in obj-c
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    NSDate *date = [NSDate date];
    
    NSString *response = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    return response;
}

+ (NSString*)getTimeStampFromNSDate:(NSDate *)date {
    //yyyy-MM-ddTHH:mm:ss.fff yyyy-MM-ddTHH:mm:ss.SSS in obj-c
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    
    NSString *response = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    return response;
}

+ (NSDate *)getDateFromAPITimeStamp:(NSString *) dateString {
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


#pragma mark - TimeStamp Methods (in NSUserDefaults)
#pragma mark Entitlements

+ (void)setEntitlementtsTimeStampForCustomer:(NSString*)masterCustomerID andCollection:(NSNumber*) collectionID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *entitlementsDict = [[defaults objectForKey:@"entitlementsTSDict"] mutableCopy];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    
    if ([entitlementsDict objectForKey:masterCustomerID]) {
        userDict = [[entitlementsDict objectForKey:masterCustomerID] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];
    NSString *collString = @"";
    
    if (collectionID == nil) {
        collString = @"*";
    } else {
        //collString = [NSString stringWithFormat:@"%ld", (long)collectionID];
        collString = [collectionID stringValue];
    }
    
    [userDict setObject:timeStamp forKey:collString];
    
    [entitlementsDict setObject:userDict forKey:masterCustomerID];
    
    [defaults setObject:entitlementsDict forKey:@"entitlementsTSDict"];
    [defaults synchronize];
    
    //NSLog(@"entitlementsDict\n%@", entitlementsDict);
}


+ (NSString*)getEntitlementTimeStampForCustomer:(NSString*)masterCustomerID andCollection:(NSNumber*) collectionID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *entitlementsDict = [defaults objectForKey:@"entitlementsTSDict"];
    NSMutableDictionary *userDict =nil;
    
    if ([entitlementsDict objectForKey:masterCustomerID]) {
        userDict = [entitlementsDict objectForKey:masterCustomerID];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *collString = @"";
    
    if (collectionID == nil) {
        collString = @"*";
    } else {
        //collString = [NSString stringWithFormat:@"%ld", (long)collectionID];
        collString = [collectionID stringValue];
    }
    
    NSString *timeStamp = [userDict valueForKey:collString];
    return timeStamp;
    
}


#pragma mark Menu
+ (void)setMenuTimeStampWithCollectionID:(NSNumber*) collectionID andOrMimeType:(NSString *) mimeType {
    /*
     NEED TO STORE COLLECTIONID, MIMETYPE, TIMESTAMP
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *menuTSDict = [[defaults objectForKey:@"menuTSDict"] mutableCopy];
    NSMutableDictionary *collDict = [[NSMutableDictionary alloc] init];
    
    NSString *collString = nil;
    if (collectionID == nil) {
        collString = @"*";
    } else {
        //collString = [NSString stringWithFormat:@"%ld", (long)collectionID];
        collString = [collectionID stringValue];
    }
    
    if (mimeType == nil) {
        mimeType = @"*";
    }
    
    if ([menuTSDict objectForKey:collString]) {
        collDict = [[menuTSDict objectForKey:collString] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];

    [collDict setObject:timeStamp forKey:mimeType];
    
    [menuTSDict setObject:collDict forKey:collString];
    
    [defaults setObject:menuTSDict forKey:@"menuTSDict"];
    [defaults synchronize];
    
    //NSLog(@"menuTSDict\n%@", menuTSDict);

}


+ (NSString*)getMenuTimeStampWithCollectionID:(NSNumber*) collectionID andOrMimeType:(NSString*) mimetype {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *menuTSDict = [defaults objectForKey:@"menuTSDict"];
    NSMutableDictionary *collDict = nil;
    
    NSString *collString = nil;
    if (collectionID == nil) {
        collString = @"*";
    } else {
        //collString = [NSString stringWithFormat:@"%ld", (long)collectionID];
        collString = [collectionID stringValue];
    }
    
    if (mimetype == nil) {
        mimetype = @"*";
    }
    
    if ([menuTSDict objectForKey:collString]) {
        collDict = [menuTSDict objectForKey:collString];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *response = nil;
    response = [collDict valueForKey:mimetype];
    return response;
    
}


#pragma mark Content

+ (void)setContentTimeStampForCustomer:(NSString*) masterCustomerID {
    
    if(!masterCustomerID || !masterCustomerID.length)
        return;
    
    /*
     NEED TO STORE MASTERCUSTOMERID, TIMESTAMP
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [[defaults objectForKey:@"contentForCustomerTSDict"] mutableCopy];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    
    if ([contentTSDict objectForKey:masterCustomerID]) {
        userDict = [[contentTSDict objectForKey:masterCustomerID] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];

    [userDict setObject:timeStamp forKey:masterCustomerID];
    
    [contentTSDict setObject:userDict forKey:masterCustomerID];
    
    [defaults setObject:contentTSDict forKey:@"contentForCustomerTSDict"];
    [defaults synchronize];
    
    //NSLog(@"contentForCustomerTSDict\n%@", contentTSDict);

}


+ (NSString*)getContentTimeStampForCustomer:(NSString*) masterCustomerID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [defaults objectForKey:@"contentForCustomerTSDict"];
    NSMutableDictionary *userDict = nil;
    
    if ([contentTSDict objectForKey:masterCustomerID]) {
        userDict = [contentTSDict objectForKey:masterCustomerID];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *response = nil;
    response = [userDict valueForKey:masterCustomerID];
    return response;
}


+ (void)setContentTimeStampForCollection:(NSNumber*) collectionID {
    /*
     NEED TO STORE COLLECTIONID, TIMESTAMP
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [[defaults objectForKey:@"contentForCollectionsTSDict"] mutableCopy];
    NSMutableDictionary *collDict = [[NSMutableDictionary alloc] init];
    
    NSString *collString = nil;
    
    if (collectionID == nil) {
        collString = @"*";
    } else {
        //collString = [NSString stringWithFormat:@"%ld", (long)collectionID];
        collString = [collectionID stringValue];
    }
    
    if ([contentTSDict objectForKey:collString]) {
        collDict = [[contentTSDict objectForKey:collString] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];
    
    [collDict setObject:timeStamp forKey:collString];
    
    [contentTSDict setObject:collDict forKey:collString];
    
    [defaults setObject:contentTSDict forKey:@"contentForCollectionsTSDict"];
    [defaults synchronize];
    
    //NSLog(@"contentForCollectionsTSDict\n%@", contentTSDict);

}


+ (NSString*)getContentTimeStampForCollection:(NSNumber*) collectionID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [defaults objectForKey:@"contentForCollectionsTSDict"];
    NSMutableDictionary *collDict = nil;
    
    NSString *collString = nil;
    if (collectionID == nil) {
        collString = @"*";
    } else {
        collString = [collectionID stringValue];
    }
    
    if ([contentTSDict objectForKey:collString]) {
        collDict = [contentTSDict objectForKey:collString];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *response = nil;
    response = [collDict valueForKey:collString];
    return response;
    
}


+ (void)setContentTimeStampForMimeType:(NSString*) mimeType {
    /*
     NEED TO STORE MIMETYPE, TIMESTAMP
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [[defaults objectForKey:@"contentForMimeTypesTSDict"] mutableCopy];
    NSMutableDictionary *mimeDict = [[NSMutableDictionary alloc] init];
    
    if ([contentTSDict objectForKey:mimeDict]) {
        mimeDict = [[contentTSDict objectForKey:mimeType] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];
    
    [mimeDict setObject:timeStamp forKey:mimeType];
    
    [contentTSDict setObject:mimeDict forKey:mimeType];
    
    [defaults setObject:contentTSDict forKey:@"contentForMimeTypesTSDict"];
    [defaults synchronize];
    
    //NSLog(@"contentForMimeTypesTSDict\n%@", contentTSDict);

}


+ (NSString*)getContentTimeStampForMimeType:(NSString*) mimeType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *contentTSDict = [defaults objectForKey:@"contentForMimeTypesTSDict"];
    NSMutableDictionary *mimeDict = nil;
    
    if ([contentTSDict objectForKey:mimeType]) {
        mimeDict = [[contentTSDict objectForKey:mimeType] mutableCopy];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *response = nil;
    response = [mimeDict valueForKey:mimeType];
    return response;
}


+ (void)setContentTimeStampForCategory:(NSString*) aCategory {
    /*
     NEED TO STORE aCATEGROY, TIMESTAMP
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *categoryTSDict = [[defaults objectForKey:@"contentForCategoriesTSDict"] mutableCopy];
    NSMutableDictionary *catDict = [[NSMutableDictionary alloc] init];
    
    if ([categoryTSDict objectForKey:aCategory]) {
        catDict = [[categoryTSDict objectForKey:aCategory] mutableCopy];
    }
    
    NSString *timeStamp = [BBHelper getTimeStamp];
    
    [catDict setObject:timeStamp forKey:aCategory];
    
    [categoryTSDict setObject:catDict forKey:aCategory];
    
    [defaults setObject:categoryTSDict forKey:@"contentForCategoriesTSDict"];
    [defaults synchronize];
    
    //NSLog(@"contentForCategoriesTSDict\n%@", categoryTSDict);

}


+ (NSString*)getContentTimeStampForCategory:(NSString*) aCategory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *categoryTSDict = [[defaults objectForKey:@"contentForCategoriesTSDict"] mutableCopy];
    NSMutableDictionary *catDict = nil;
    
    if ([categoryTSDict objectForKey:aCategory]) {
        catDict = [[categoryTSDict objectForKey:aCategory] mutableCopy];
    } else {
        NSString *empty = [NSString stringWithFormat:@""];
        return empty;
    }
    
    NSString *response = nil;
    response = [catDict valueForKey:aCategory];
    return response;
}

@end































