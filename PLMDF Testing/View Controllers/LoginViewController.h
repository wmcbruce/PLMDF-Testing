//
//  LoginViewController.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/12/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonTapped:(id)sender;

@end
