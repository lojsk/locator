//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize myScrollView, myInsideView, myMapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    myScrollView.contentSize = myInsideView.frame.size;
    myScrollView.delegate = self;
    self.titleLabel.text = self.titleText;
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.frame.origin.y-myScrollView.contentOffset.y>=180 && scrollView.frame.origin.y-myScrollView.contentOffset.y<430) {
        CGRect frameRect = scrollView.frame;
        frameRect.origin.y -= scrollView.contentOffset.y;
        myScrollView.frame = frameRect;
        myScrollView.contentOffset = CGPointZero;
        myScrollView.bounces = YES;
        
        NSLog(@"%f", scrollView.frame.origin.y);
    } else {
        if(scrollView.frame.origin.y-myScrollView.contentOffset.y<430)
            myScrollView.bounces = NO;
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
