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

@synthesize myScrollView, myInsideView, myHeaderView, myMapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    myScrollView.contentSize = myInsideView.frame.size;
    myScrollView.delegate = self;
    self.titleLabel.text = self.titleText;
    
    startHeaderPosition = myHeaderView.frame.origin.y;
    scrollEnable = NO;
    startPos = 0;
    
    myScrollView.layer.zPosition = 1;
    mapHeight = myMapView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!scrollEnable) {
        if(280 < scrollView.contentOffset.y) {
            return;
        }
        [UIView animateWithDuration:0.3f animations:^{
            [scrollView setContentOffset:CGPointMake(0, startPos)animated:NO];
        }];
    }
    
    /*
    CGRect frameRect = myMapView.frame;
    frameRect.size.height = mapHeight-scrollView.contentOffset.y;
    NSLog(@"%f", mapHeight-scrollView.contentOffset.y);
    if(mapHeight-scrollView.contentOffset.y<200.0f)
        frameRect.size.height = 200.0f;
    myMapView.frame = frameRect; */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollEnable = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)
    targetContentOffset {
    scrollEnable = NO;
    
    float stopY = 0.0f;
    if(startPos == 0) {
        if(scrollView.contentOffset.y > startPos+50.0f) {
            stopY = 280.0f;
            startPos = stopY;
            [scrollView setContentOffset:CGPointMake(0, stopY)animated:YES];
        } else {
            stopY = 0.0f;
            startPos = stopY;
            [scrollView setContentOffset:CGPointMake(0, stopY)animated:YES];
        }
    } else {
        if(scrollView.contentOffset.y < startPos-50.0f) {
            stopY = 0.0f;
            startPos = stopY;
            [scrollView setContentOffset:CGPointMake(0, stopY)animated:YES];
        } else {
            stopY = 280.0f;
            startPos = stopY;
            [scrollView setContentOffset:CGPointMake(0, stopY)animated:YES];
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
