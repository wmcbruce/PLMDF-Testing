//
//  DFAWSClient.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "DFAWSClient.h"
#import "AFNetworking.h"

@interface DFAWSClient()
    @property (nonatomic, strong) AFHTTPSessionManager *manager;
    @property (nonatomic, strong) NSUserDefaults *defaults;
    @property (nonatomic, strong) NSString *apikey;
    @property (nonatomic, strong) NSString *sessionToken;
@end


@implementation DFAWSClient

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        self.apikey = [_defaults valueForKey:@"apikey"];
        
        _manager = [[AFHTTPSessionManager alloc] init];
        
//        [_manager.requestSerializer setValue:@"36fda24fe5588fa4285ac6c6c2fdfbdb6b6bc9834699774c9bf777f706d05a88"
//                          forHTTPHeaderField:@"X-DreamFactory-API-Key"];
        
        [_manager.requestSerializer setValue:_apikey
                          forHTTPHeaderField:@"X-DreamFactory-API-Key"];
        
        DFAWSClient *__weak weakSelf = self;
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status != AFNetworkReachabilityStatusUnknown && status != AFNetworkReachabilityStatusNotReachable) {
                
                //NOTIFICATION IS UNUSED...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DFAWSServiceReachable" object:weakSelf];
            }
        }];
        [_manager.reachabilityManager startMonitoring];
    }
    
    return self;
}

- (void)dealloc {
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:nil];
    [_manager.reachabilityManager stopMonitoring];
}

-(void) loginWithUserName:(NSString*) username andPassword:(NSString*) password {

    NSDictionary *parameters = @{@"email": username, @"password": password};
    
    //http://ec2-13-59-152-185.us-east-2.compute.amazonaws.com/api/v2/system/admin/session
    
    //NSString *authURL = @"http://ec2-13-59-152-185.us-east-2.compute.amazonaws.com/api/v2/system/admin/session";
    NSString *authURL = @"http://18.217.82.183/api/v2/user/session";

    NSError *writeError = nil;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:120];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"36fda24fe5588fa4285ac6c6c2fdfbdb6b6bc9834699774c9bf777f706d05a8" forHTTPHeaderField:@"X-DreamFactory-API-Key"];
    [request setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
                NSLog(@"respons_name: %@", [responseObject valueForKey:@"name"]);
                NSLog(@"respons_last_login: %@", [responseObject valueForKey:@"last_login_date"]);
                
                [self.defaults setValue:[responseObject valueForKey:@"session_token"] forKey:@"session_token"];
                [self.defaults synchronize];
                
                //Notification...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLoginResponse"
                                                                    object:nil
                                                                  userInfo:responseObject];
            }
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@",response);
            NSLog(@"Response Object: %@",responseObject);
            
            //Notification...
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLoginResponse"
                                                                object:nil
                                                              userInfo:responseObject];
            
        }
    }] resume];
    
}

-(void) getPlayers {
    [self getSessionToken];
    //NSLog(@"client session token: %@", self.sessionToken);
    //NSLog(@"apikey: %@: ", _apikey);
    
    NSString *authURL = @"http://18.217.82.183/api/v2/mongodb/_table/players";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:120];
    
    [request setHTTPMethod:@"GET"];
    [request setValue: @"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue: [self sessionToken] forHTTPHeaderField:@"X-DreamFactory-Session-Token"];
    [request setValue: [self apikey] forHTTPHeaderField:@"X-DreamFactory-API-Key"];
    
    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
                
                NSLog(@"GET Battles response: %@", responseObject);
                
                //Notification...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receivePlayersResponse"
                                                                    object:nil
                                                                  userInfo:responseObject];
            }
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@",response);
            NSLog(@"Response Object: %@",responseObject);
            
            //Notification...
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receivePlayersResponse"
                                                                object:nil
                                                              userInfo:responseObject];
            
        }
    }] resume];
}

-(void) getBattles {
    //[self setSessionToken:[self.defaults valueForKey:@"session_token"]];
    [self getSessionToken];
    //NSLog(@"client session token: %@", self.sessionToken);
    //NSLog(@"apikey: %@: ", _apikey);
    
    NSString *authURL = @"http://18.217.82.183/api/v2/mongodb/_table/battles";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:120];
    
    [request setHTTPMethod:@"GET"];
    [request setValue: @"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue: [self sessionToken] forHTTPHeaderField:@"X-DreamFactory-Session-Token"];
    [request setValue: [self apikey] forHTTPHeaderField:@"X-DreamFactory-API-Key"];
    
    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
                
                NSLog(@"GET Battles response: %@", responseObject);
                
                //Notification...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveBattlesResponse"
                                                                    object:nil
                                                                  userInfo:responseObject];
            }
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@",response);
            NSLog(@"Response Object: %@",responseObject);
            
            //Notification...
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveBattlesResponse"
                                                                object:nil
                                                              userInfo:responseObject];
            
        }
    }] resume];
}

-(void) getSignIns {
    [self getSessionToken];
    NSLog(@"client session token: %@", self.sessionToken);
    
    NSString *authURL = @"http://18.217.82.183/api/v2/mongodb/_table/signins";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:120];
    
    [request setHTTPMethod:@"GET"];
    [request setValue: @"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue: [self sessionToken] forHTTPHeaderField:@"X-DreamFactory-Session-Token"];
    [request setValue: [self apikey] forHTTPHeaderField:@"X-DreamFactory-API-Key"];
    
    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
                
                NSLog(@"GET Sign Ins response: %@", responseObject);
                
                //Notification...
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveSignInsResponse"
                                                                    object:nil
                                                                  userInfo:responseObject];
            }
            
        } else {
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@",response);
            NSLog(@"Response Object: %@",responseObject);
            
            //Notification...
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveSignInsResponse"
                                                                object:nil
                                                              userInfo:responseObject];
            
        }
    }] resume];
}

-(void) postPlayerWithPlayerDictionary:(NSDictionary*)player {
    [self getSessionToken];
    NSLog(@"client session token: %@", self.sessionToken);
    
    
}

-(void) putPlayerWithPlayerDictionary:(NSDictionary*)player {
    [self getSessionToken];
    NSLog(@"client session token: %@", self.sessionToken);
    
}

-(void) postBattleWithBattleDictionary:(NSDictionary*)battle {
    [self getSessionToken];
    NSLog(@"client session token: %@", self.sessionToken);
    
}

-(void) postSignInWithSignInDictionary:(NSDictionary*)signIn {
    [self getSessionToken];
    NSLog(@"client session token: %@", self.sessionToken);
    
}

-(void) getSessionToken {
    [self setSessionToken:[self.defaults valueForKey:@"session_token"]];

}

@end
