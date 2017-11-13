//
//  DFAWSClient.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFAWSClient : NSObject

//Login
/*
 Require: Username, Password
 Return: Session Token or Error
 */

//GetPlayers
/*
 Require: None
 Return: "resource" JSON array
    {
        "resource": [
            {
                "_id": "5a0758f1ca044f12d51dd7f2",
                "playerId": "123457",
                "firstName": "Jane",
                "lastName": "Doe",
                "email": "janedoe@gmail.com",
                "phone": "847-555-1212",
                "birthday": "1980-11-11",
                "image": "https://cdn...",
                "dateCreated": "2017-11-11",
                "dateUpdated": "2017-11-11",
                "isActive": true,
                "isSignedIn": false
            }
        ]
    }
*/
-(void) loginWithUserName:(NSString*) username andPassword:(NSString*) password;

//GetBattles
/*
 Require: None
 Return: "resource" JSON array
 {
    "resource": [
        {
            "_id": "5a075915ca044f13fa5505f2",
            "dateBattle": "2017-11-11",
            "players": [
                "12345",
                "67890"
                ]
        }
    ]
 }
 */
-(void) getBattles;

//GetSignIns
/*
 Require: None
 Return: "resource" JSON array
 {
    "resource": [
        {
            "_id": "5a07590cca044f12d6711f42",
            "date": "2017-11-12",
            "playerId": "123457"
        }
    ]
 }
 */
-(void) getSignIns;

//PostPlayer
/*
 Require: JSON with all attributes
 Return:
 */
-(void) postPlayerWithPlayerDictionary:(NSDictionary*)player;

//PutPlayer
/*
 Require: JSON with _id, and updated attribute
 Return:
 */
-(void) putPlayerWithPlayerDictionary:(NSDictionary*)player;

//PostBattle
/*
 Require: JSON with all attributes
 Return:
 */
-(void) postBattleWithBattleDictionary:(NSDictionary*)battle;

//PostSignIn
/*
 Require: JSON with all attributes
 Return:
 */
-(void) postSignInWithSignInDictionary:(NSDictionary*)signIn;

@end
