//
//  DFAWSClient.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "DFAWSClient.h"
#import "AFNetworking.h"

@implementation DFAWSClient


-(void) loginWithUserName:(NSString*) username andPassword:(NSString*) password {

    NSDictionary *parameters = @{@"email": username, @"password": password};
    
    //http://ec2-13-59-152-185.us-east-2.compute.amazonaws.com/api/v2/system/admin/session
    
    NSString *authURL = @"http://ec2-13-59-152-185.us-east-2.compute.amazonaws.com/api/v2/system/admin/session";
    
    NSError *writeError = nil;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:120];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"36fda24fe5588fa4285ac6c6c2fdfbdb6b6bc9834699774c9bf777f706d05a8" forHTTPHeaderField:@"X-DreamFactory-API-Key"];
    [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
                NSLog(@"respons_name: %@", [responseObject valueForKey:@"name"]);
                NSLog(@"respons_last_login: %@", [responseObject valueForKey:@"last_login_date"]);
                NSLog(@"session_token: %@", [responseObject valueForKey:@"session_token"]);
                
                //Notification...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLoginResponse"
                                                                    object:responseObject
                                                                  userInfo:nil];
            }
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@",response);
            NSLog(@"Response Object: %@",responseObject);
            
            //Notification...
            
        }
    }] resume];
    
}

-(void) getBattles {
    
}

-(void) getSignIns {
    
}

-(void) postPlayerWithPlayerDictionary:(NSDictionary*)player {
    
}

-(void) putPlayerWithPlayerDictionary:(NSDictionary*)player {
    
}

-(void) postBattleWithBattleDictionary:(NSDictionary*)battle {
    
}

-(void) postSignInWithSignInDictionary:(NSDictionary*)signIn {
    
}


@end
