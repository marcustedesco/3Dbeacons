//
//  PositionViewController.m
//  3Dbeacons
//
//  Created by Marcus Tedesco on 4/19/14.
//  Copyright (c) 2014 com.marcustedesco. All rights reserved.
//

#import "PositionViewController.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconTableVC.h"
#import "MTBeaconStore.h"
#import "ESTAppDelegate.h"

/*
 * Maximum distance (in meters) from beacon for which, the dot will be visible on screen.
 */
#define MAX_DISTANCE_H 20
#define MAX_DISTANCE_W 20
#define TOP_MARGIN   150

@interface PositionViewController () <ESTBeaconManagerDelegate>

//@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
@property (nonatomic, strong) NSArray   *beaconRegions;

//@property (nonatomic, strong) UIImageView       *positionDot;
@property (weak, nonatomic) IBOutlet UIImageView *blackDot;
@property (weak, nonatomic) IBOutlet UILabel *xval;
@property (weak, nonatomic) IBOutlet UILabel *yval;

@end

@implementation PositionViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
//    
//    ESTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    MTBeaconStore *beaconStore = delegate.beaconStore;
    
     self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"RegionIdentifier"];
     [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
//    self.beaconRegions = @[[self beaconRegionForBeacon:beaconStore.purpleBeacon],
//                           [self beaconRegionForBeacon:beaconStore.blueBeacon],
//                           [self beaconRegionForBeacon:beaconStore.greenBeacon]];
//    
   /* for (ESTBeaconRegion * beaconRegion in self.beaconRegions) {
        [self.beaconManager startRangingBeaconsInRegion:beaconRegion];
    }*/
    
    
    
    /*self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    */
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated
{
    for (ESTBeaconRegion * beaconRegion in self.beaconRegions) {
        [self.beaconManager stopRangingBeaconsInRegion:beaconRegion];
    }
    //[self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    //ESTBeacon *firstBeacon = [beacons firstObject];
    
    // update beacons
    
    ESTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    MTBeaconStore *beaconStore = delegate.beaconStore;
    
    for (ESTBeacon *beacon in beacons) {
        if ([beacon.major isEqualToNumber:@10263]) {
            beaconStore.purpleBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                                   xPos:1
                                                                   yPos:1];
        } else if ([beacon.major isEqualToNumber:@29163]) {
            beaconStore.greenBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                                  xPos:2
                                                                  yPos:5];
        } else if ([beacon.major isEqualToNumber:@14402]) {
            beaconStore.blueBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                                 xPos:5
                                                                 yPos:3];
        }
    }
    [beaconStore currentPosFromBeacons];
    
    
    [self updateDotPositionForDistance];    
}

#pragma mark -

- (void)updateDotPositionForDistance
{
    float stepH = (self.view.frame.size.height - TOP_MARGIN) / MAX_DISTANCE_H;
    float stepW = (self.view.frame.size.width) / MAX_DISTANCE_W;
    
  //  int newY = TOP_MARGIN + (distance * step);
    
    ESTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    MTBeaconStore *beaconStore = delegate.beaconStore;
    
    CGPoint pos = [beaconStore currentPosFromBeacons];
    
    [self.blackDot setCenter:CGPointMake(pos.x*stepW, TOP_MARGIN+pos.y*stepH)];
    [self.xval setText:[NSString stringWithFormat:@"%.2f", pos.x]];
    [self.yval setText:[NSString stringWithFormat:@"%.2f", pos.y]];
}

/*
 
 @interface PositionViewController ()
 
 @property (weak, nonatomic) IBOutlet UIImageView *blackDot;
 @end
 
 @implementation PositionViewController
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 // Do any additional setup after loading the view from its nib.
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 */

@end
