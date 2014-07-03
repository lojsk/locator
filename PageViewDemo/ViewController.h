//
//  ViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "SettingsContentViewController.h"
#import "DataManager.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource> {
    DataManager *dm;
    int viewNumber;
}

- (IBAction)startWalkthrough:(id)sender;
- (void)changeSubViewPosition:(float)y;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *insideView;

@end
