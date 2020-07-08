//
//  LoginViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/PFUser.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = true;
}
- (IBAction)onTapSignUp:(id)sender {
    [self registerUser];
}
- (IBAction)onTapLogIn:(id)sender {
    [self loginUser];
}
 #pragma mark - Logic
- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}
- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}
 #pragma mark - Animation
- (IBAction)editBegin:(id)sender {
    NSLog(@"Here");
    [UIView animateWithDuration:0.3 animations:^{
        [self.loginButton setBackgroundColor:[UIColor systemBlueColor]];
        self.passwordField.frame = CGRectMake(self.passwordField.frame.origin.x, self.passwordField.frame.origin.y - 100, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
        self.usernameField.frame = CGRectMake(self.usernameField.frame.origin.x, self.usernameField.frame.origin.y - 100, self.usernameField.frame.size.width, self.usernameField.frame.size.height);
        self.mainLabel.frame = CGRectMake(self.mainLabel.frame.origin.x, self.mainLabel.frame.origin.y - 100, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, self.loginButton.frame.origin.y - 100, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    }];
}
- (IBAction)editEnd:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.passwordField.frame = CGRectMake(self.passwordField.frame.origin.x, self.passwordField.frame.origin.y + 100, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
        self.usernameField.frame = CGRectMake(self.usernameField.frame.origin.x, self.usernameField.frame.origin.y + 100, self.usernameField.frame.size.width, self.usernameField.frame.size.height);
        self.mainLabel.frame = CGRectMake(self.mainLabel.frame.origin.x, self.mainLabel.frame.origin.y + 100, self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x, self.loginButton.frame.origin.y + 100, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    }];
    
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
