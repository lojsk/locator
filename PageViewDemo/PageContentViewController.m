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

@synthesize myScrollView, myInsideView, myTableView, mySearchInput, parent;

- (void)viewDidLoad
{
    [super viewDidLoad];

    myScrollView.contentSize = myInsideView.frame.size;
    myScrollView.delegate = self;
    self.titleLabel.text = self.titleText;
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    dm = [DataManager sharedInstance];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.frame.origin.y-myScrollView.contentOffset.y>=180 && scrollView.frame.origin.y-myScrollView.contentOffset.y<430) {
        CGRect frameRect = scrollView.frame;
        frameRect.origin.y -= scrollView.contentOffset.y;
        myScrollView.frame = frameRect;
        myScrollView.contentOffset = CGPointZero;
        myScrollView.bounces = YES;
        [(ViewController*)parent changeSubViewPosition:frameRect.origin.y];
        NSLog(@"%f", scrollView.frame.origin.y);
    } else {
        if(scrollView.frame.origin.y-myScrollView.contentOffset.y<430)
            myScrollView.bounces = NO;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((SPGooglePlacesAutocompletePlace *)[data objectAtIndex:indexPath.row]).name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    mySearchInput.text = ((SPGooglePlacesAutocompletePlace *)[data objectAtIndex:indexPath.row]).name;
    data = [[NSArray alloc] init];
    [myTableView reloadData];
}

- (IBAction)NearChanged:(id)sender {
    // if([myAutocompleteView isHidden])
    //     [self locationBegin:self];
    
    query = [[SPGooglePlacesAutocompleteQuery alloc] init];
    query.input = mySearchInput.text;
    query.radius = 100.0;
    query.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    query.location = dm.location;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(aTime) object:nil];
    [self performSelector:@selector(aTime) withObject:nil afterDelay:0.4];
    
}

- (IBAction)endEditing:(id)sender {
    [myTableView setHidden:YES];
}

-(void)aTime {
    //self.autoTable.noResults = NO;
    if([query.input isEqual:@""]) {
        data = nil;
        [myTableView reloadData];
        return;
    }
    //self.autoTable.isLoading = YES;
    [myTableView reloadData];
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        //self.autoTable.isLoading = NO;
        if (error) {
            //isLatLng = NO;
            //self.autoTable.noResults = YES;
            [myTableView reloadData];
        } else {
            //isLatLng = YES;
            data = places;
            [myTableView reloadData];
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
