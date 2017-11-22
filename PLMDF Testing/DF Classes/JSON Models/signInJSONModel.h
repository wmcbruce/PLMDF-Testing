//
//  signInJSONModel.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/21/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signInJSONModel : NSObject
/*
 SIGN IN JSON STRUCTURE
 {
 "date": "11/12/2017",
 "playerId": "123457"
 }
 */

//@property (nonatomic, weak) NSString * objid;
@property (nonatomic, weak) NSString * playerId;
@property (nonatomic, weak) NSString * signInDate;

@end
