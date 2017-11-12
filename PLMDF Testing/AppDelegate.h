//
//  AppDelegate.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/12/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

