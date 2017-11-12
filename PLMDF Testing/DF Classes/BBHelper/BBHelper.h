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
+ (NSString*)getTimeStamp;

+ (NSString*)getTimeStampFromNSDate:(NSDate *)date;

/**
 Provides an NSDate object with the values of an AAOS API Datestring

 @param dateString yyyy-MM-ddTHH:mm:ss.fff 
 @return NSDate
 */
+ (NSDate *)getDateFromAPITimeStamp:(NSString *) dateString;


/**
 Set the timestamp for last successful fetch of entitlements for customer.

 @param masterCustomerID REQUIRED.
 @param collectionID Optional.
 */
+ (void)setEntitlementtsTimeStampForCustomer:(NSString*)masterCustomerID andCollection:(NSNumber*) collectionID;


/**
 Returns the timestamp of the last fetch of entitlements for customer.

 @param masterCustomerID REQUIRED.
 @param collectionID Optional.
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getEntitlementTimeStampForCustomer:(NSString*)masterCustomerID andCollection:(NSNumber*) collectionID;


/**
 Set the timestamp for the last successful menu fetch.

 @param collectionID Optional.
 @param mimeType Optional.
 */
+ (void)setMenuTimeStampWithCollectionID:(NSNumber*) collectionID andOrMimeType:(NSString *) mimeType;


/**
 Get the4 timestamp for the last successful menu fetch.

 @param collectionID Optional.
 @param mimetype Optional.
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getMenuTimeStampWithCollectionID:(NSNumber*) collectionID andOrMimeType:(NSString*) mimetype;


/**
 Set the timestamp for a successful pull of content for customer.

 @param masterCustomerID Required.
 */
+ (void)setContentTimeStampForCustomer:(NSString*) masterCustomerID;


/**
 Get the timestamp for a successful pull of content for customer.

 @param masterCustomerID Required
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getContentTimeStampForCustomer:(NSString*) masterCustomerID;


/**
 Set the timestamp for a successful content fetch for a collection.

 @param collectionID Required.
 */
+ (void)setContentTimeStampForCollection:(NSNumber*) collectionID;


/**
 the timestamp for latest successful content fetch for a collection.

 @param collectionID Required
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getContentTimeStampForCollection:(NSNumber*) collectionID;


/**
 Set the timestamp for a successful content fetch for a mimetype.

 @param mimeType Required.
 */
+ (void)setContentTimeStampForMimeType:(NSString*) mimeType;


/**
 Get the timestamp for the latest successful content fetch for a mimetype.

 @param mimeType Required.
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getContentTimeStampForMimeType:(NSString*) mimeType;


/**
 Set the timestamp for a successful fetch of content for a category.

 @param aCategory Required
 */
+ (void)setContentTimeStampForCategory:(NSString*) aCategory;


/**
 Get the timestamp for the latest successful fetch of content for a category

 @param aCategory Required.
 @return NSString in yyyy-MM-ddTHH:mm:ss.fff format converted to CST timezone.
 */
+ (NSString*)getContentTimeStampForCategory:(NSString*) aCategory;

@end
