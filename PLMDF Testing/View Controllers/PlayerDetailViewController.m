//
//  PlayerDetailViewController.m
//  PLMDF Testing
//
//  Created by Bill Bruce on 11/13/17.
//  Copyright © 2017 Bill Bruce. All rights reserved.
//

#import "PlayerDetailViewController.h"

@interface PlayerDetailViewController ()

@end

@implementation PlayerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_player) {
        _playerIDTextField.text = _player.playerId;
        _firstNameTextField.text = _player.firstName;
        _lastNameTextField.text = _player.lastName;
        _emailTextField.text = _player.email;
        _phoneTextField.text = _player.phone;
        _birthdayTextField.text = _player.birthday;
        //next line won't work...
        //_profileImageView.image = [UIImage imageNamed:_player.profileImage];
        
    }
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

- (IBAction)editProfileImage:(id)sender {
    
}
@end
