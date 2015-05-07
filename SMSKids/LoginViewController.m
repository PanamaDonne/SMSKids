//
//  LoginViewController.m
//  SMSKids
//
//  Created by Daniel - Home on 07/05/15.
//  Copyright (c) 2015 smskids. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>




@interface LoginViewController ()
@property (nonatomic, strong) UIView *fieldsBackground;
@end

@implementation LoginViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    //[self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    //[self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    //[self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"FacebookDown.png"] forState:UIControlStateHighlighted];
    //[self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"Connect with Facebook" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"Connect with Facebook" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"Signup.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignupDown.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign in" forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitleColor: [UIColor whiteColor]  forState:UIControlStateNormal];
    
    
    // Add login field background
    //fieldsBackground = [[UIView alloc] initWithFrame:<#(CGRect)#>:[UIImage imageNamed:@"LoginFieldBG.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Remove text shadow
    /*CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;*/
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    //[self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.logInView.facebookButton setFrame:CGRectMake(65.0f, 287.0f, 250.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(65.0f, 445.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(65.0f, 495.0f, 250.0f, 50.0f)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(65.0f, 600.0f, 250.0f, 50.0f)];
    //[self.fieldsBackground setFrame:CGRectMake(0, 0, , 1334)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
