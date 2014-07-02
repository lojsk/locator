//
//  LoginViewController.m
//  PageViewDemo
//
//  Created by lojsk on 01/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize phoneNumberField, codeNumberField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstStepAuditification:(id)sender {
    RMPhoneFormat *fmt = [[RMPhoneFormat alloc] init];
    // Call any number of times
    NSString *numberString = phoneNumberField.text;
    NSString *formattedNumber = [fmt format:numberString];
    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *password = [NSString stringWithFormat:@"%d", 1000 + arc4random() % 8999];
    NSLog(@"Random Number: %@", password);
    
    PFUser *user = [PFUser user];
    user.username = formattedNumber;
    user.password = password;
    
    user[@"code"] = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [PFCloud callFunctionInBackground:@"send"
                               withParameters:@{@"number": formattedNumber, @"code": password}
                                        block:^(NSString *result, NSError *error) {
                                            if (!error) {
                                                NSLog(@"%@", result);
                                                // result is @"Hello world!"
                                            }
                                        }];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@ | %d", errorString, [error code]);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}


@end
