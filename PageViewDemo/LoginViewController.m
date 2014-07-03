//
//  LoginViewController.m
//  PageViewDemo
//
//  Created by lojsk on 01/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonHMAC.h>

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

@synthesize prefixNumberField, phoneNumberField, codeNumberField, registerButton, verificyButton, resendSMSButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [phoneNumberField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstStepAuditification:(id)sender {
    RMPhoneFormat *fmt = [[RMPhoneFormat alloc] init];
    // Call any number of times
    NSString *numberString = [NSString stringWithFormat:@"%@%@",prefixNumberField.text, phoneNumberField.text];
    if(numberString.length <= 5)
        return;
    
    formattedNumber = [fmt format:numberString];
    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *password = [NSString stringWithFormat:@"%d", 1000 + arc4random() % 8999];
    NSLog(@"Random Number: %@", password);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"phone" equalTo:formattedNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [codeNumberField setHidden:NO];
            [registerButton setHidden:YES];
            [codeNumberField becomeFirstResponder];
            [phoneNumberField setEnabled:NO];
            [verificyButton setHidden:NO];
            
            
            
            if([objects count]> 0) {
                [resendSMSButton setTitle:@"reset Code" forState:UIControlStateNormal];
                [resendSMSButton setHidden:NO];
            } else {
                [resendSMSButton setHidden:NO];
                // create new user
                PFObject *users = [PFObject objectWithClassName:@"Users"];
                users[@"phone"] = formattedNumber;
                users[@"password"] = [self getHash:password];
                [users saveInBackground];
                [self sendSMS:password];
            }
            
        } else {
            
        }
    }];
    
    
}

- (IBAction)resetCode:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"phone" equalTo:formattedNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] > 0) {
            NSString *password = [NSString stringWithFormat:@"%d", 1000 + arc4random() % 8999];
            [objects firstObject][@"password"] = [self getHash:password];
            [[objects firstObject] saveInBackground];
            [self sendSMS:password];
            NSLog(@"Random Number: %@", password);
        } else {
            NSLog(@"Something is wrong");
            // wrong code
        }
    }];
}

- (IBAction)verificyAccount:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"phone" equalTo:formattedNumber];
    [query whereKey:@"password" equalTo:[self getHash:codeNumberField.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count] > 0) {
            // login
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:formattedNumber forKey:@"phone"];
            NSLog(@"%@ aaa",[prefs valueForKey:@"phone"]);
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            NSLog(@"wrong");
            // wrong password
        }
    }];
}

- (NSString*)getHash:(NSString*)parameters {
    NSString *salt = @"saltLocationString";
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    return [hash base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (void) sendSMS:(NSString*)password {
    // show input for code
    [PFCloud callFunctionInBackground:@"send"
                       withParameters:@{@"number": formattedNumber, @"code": password}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", result);
                                        // result is @"Hello world!"
                                    }
                                }];
}
@end
