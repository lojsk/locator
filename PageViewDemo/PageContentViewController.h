//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "DataManager.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "ViewController.h"

@interface PageContentViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    DataManager *dm;
    NSArray *data;
    SPGooglePlacesAutocompleteQuery *query;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property (weak, nonatomic) UIViewController *parent;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myInsideView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *mySearchInput;
@property NSString *imageFile;
@end
