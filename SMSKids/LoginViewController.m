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
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    
    [self.logInView.signUpButton setBackgroundColor:[UIColor blackColor]];
    [self.logInView.signUpButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundColor:[UIColor grayColor]];
    [self.logInView.passwordForgottenButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitleColor: [UIColor blackColor]  forState:UIControlStateNormal];
    
    
    // Add login field background
    fieldsBackground = [[UIView alloc] init];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    [self.fieldsBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]]];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    //[self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    //[self.logInView.usernameField setFrame:CGRectMake(65.0f, 345.0f, 250.0f, 50.0f)];
    //[self.logInView.passwordField setFrame:CGRectMake(65.0f, 395.0f, 250.0f, 50.0f)];
    //[self.logInView.logInButton setFrame:CGRectMake(65.0f, 450.0f, 250.0f, 40.0f)];
    //[self.logInView.signUpButton setFrame:CGRectMake(65.0f, 500.0f, 250.0f, 40.0f)];
    //[self.logInView.passwordForgottenButton setFrame:CGRectMake(65.0f, 550.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(0, 0, 400, 750)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
