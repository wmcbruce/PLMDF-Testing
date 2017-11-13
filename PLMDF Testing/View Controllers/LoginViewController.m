//
//  LoginViewController.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/12/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginHelper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonTapped:(id)sender {
    [LoginHelper LoginwithUserID:_userNameTextField.text andPassword:_passwordTextField.text];
}

- (void)receiveLoginResponse:(NSDictionary*) responseDictionary {
    
}

- (void)registerForNotifications {
    //setup notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginResponse:)
                                                 name:@"ReceiveLoginResponse"
                                               object:nil];
}
@end
