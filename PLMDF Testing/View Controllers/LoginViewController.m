//
//  LoginViewController.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/12/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "LoginViewController.h"
//#import "LoginHelper.h"
#import "DFAWSClient.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()
@property (nonatomic, strong) DFAWSClient *client;
@property (nonatomic, weak) NSUserDefaults *defaults;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.client = [[DFAWSClient alloc] init];
    [self registerForNotifications];
    self.defaults = [NSUserDefaults standardUserDefaults];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)loginButtonTapped:(id)sender {
    //[LoginHelper LoginwithUserID:_userNameTextField.text andPassword:_passwordTextField.text];
    [self.client loginWithUserName:_userNameTextField.text andPassword:_passwordTextField.text];
    
}

- (void)receiveLoginResponse:(NSNotification*) notification {
    NSLog(@"notification userinfo: %@", notification.userInfo);
    NSLog(@"session_token: %@", [notification.userInfo valueForKey:@"session_token"]);
    
    if ([notification.userInfo valueForKey:@"session_token"]) {
        //store session_token
        [self.defaults setValue:[notification.userInfo valueForKey:@"session_token"] forKey:@"session_token"];
        [self.defaults synchronize];
        
        //[self biometricConfig];
        
        //load main menu...
        [self performSegueWithIdentifier:@"showMainMenu" sender:self];
    } else {
        //login failed.  show error
        NSLog(@"login faild.");
    }
    

}

- (void)registerForNotifications {
    //setup notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginResponse:)
                                                 name:@"receiveLoginResponse"
                                               object:nil];
}

#pragma mark - Biometrics

- (void)biometricConfig {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Authenticate using biometrics";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"User is authenticated successfully");
                                } else {
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            NSLog(@"Authentication Failed");
                                            break;
                                            
                                        case LAErrorUserCancel:
                                            NSLog(@"User pressed Cancel button");
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            NSLog(@"User pressed \"Enter Password\"");
                                            break;
                                            
                                        default:
                                            NSLog(@"Touch ID is not configured");
                                            break;
                                    }
                                    NSLog(@"Authentication Fails");
                                }
                            }];
    } else {
        NSLog(@"Can not evaluate Touch ID");
    }
}


@end
