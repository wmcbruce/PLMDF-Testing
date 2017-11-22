//
//  battleJSONModel.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/21/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface battleJSONModel : NSObject
/*
 BATTLE JSON STRUCTURE
 {
 "dateBattle": "11/10/2017",
 "players": [
 "12345",
 "67890"
 ]
 }
 */

//@property (nonatomic, weak) NSString * objid;
@property (nonatomic, weak) NSString * battleDate;
@property (nonatomic, weak) NSArray * playerIdArray;

@end
