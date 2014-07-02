//
//  LoginViewController.h
//  PageViewDemo
//
//  Created by lojsk on 01/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RMPhoneFormat.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *codeNumberField;

@end
