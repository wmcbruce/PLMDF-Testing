//
//  PlayerDetailViewController.h
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playerJSONModel.h"

@interface PlayerDetailViewController : UIViewController

@property (weak,nonatomic) playerJSONModel * player;

@property (weak, nonatomic) IBOutlet UITextField *playerIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileImageButton;
@property (weak, nonatomic) IBOutlet UITableView *signInTableView;
@property (weak, nonatomic) IBOutlet UITableView *battleTableView;

- (IBAction)editProfileImage:(id)sender;
@end
