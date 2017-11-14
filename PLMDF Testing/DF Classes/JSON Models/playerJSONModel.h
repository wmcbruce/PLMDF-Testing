//
//  playerJSONModel.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface playerJSONModel : NSObject

@property (nonatomic, weak) NSString * objid;
@property (nonatomic, weak) NSString * playerId;
@property (nonatomic, weak) NSString * firstName;
@property (nonatomic, weak) NSString * lastName;
@property (nonatomic, weak) NSString * birthday;
@property (nonatomic, weak) NSString * email;
@property (nonatomic, weak) NSString * phone;
@property (nonatomic, weak) NSString * profileImage;
@property (nonatomic, weak) NSString * dateCreated;
@property (nonatomic, weak) NSString * dateUpdated;
@property (nonatomic) Boolean isActive;
@property (nonatomic) Boolean isSignedIn;

@end
