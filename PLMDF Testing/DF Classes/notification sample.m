//
//  notification sample.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "notification sample.h"

@implementation notification_sample

-(void) method {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(triggerAction:)
                                                 name:@"NotificationMessageEvent"
                                               object:nil];
    
    
    NSDictionary *message = [[NSDictionary alloc] init];
    // set your message properties
    NSDictionary *dict = [NSDictionary dictionaryWithObject:message forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent"
                                                        object:nil
                                                      userInfo:dict];
}


#pragma mark - Notification
-(void) triggerAction:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    NSString *message = [dict valueForKey:@"message"];
    if (message != nil) {
        // do stuff here with your message data
    }
}
@end
