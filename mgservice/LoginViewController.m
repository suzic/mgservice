//
//  LoginViewController.m
//  mgservice
//
//  Created by 苏智 on 16/1/28.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 4.0f;
}

- (IBAction)loginPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
