//
//  ESTBeaconTableVC.m
//  DistanceDemo
//
//  Created by Grzegorz Krukiewicz-Gacek on 17.03.2014.
//  Copyright (c) 2014 Estimote. All rights reserved.
//

#import "ESTBeaconTableVC.h"
#import "ESTBeaconManager.h"
#import "ESTViewController.h"
#import "MTBeacon.h"

@interface ESTBeaconTableVC () <ESTBeaconManagerDelegate>

@property (nonatomic, copy) void (^completionHandler)(ESTBeacon *);

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@property (nonatomic, strong) MTBeacon *purpleBeacon;
@property (nonatomic, strong) MTBeacon *greenBeacon;
@property (nonatomic, strong) MTBeacon *blueBeacon;

@end

@interface ESTTableViewCell : UITableViewCell

@end
@implementation ESTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}
@end

@implementation ESTBeaconTableVC

- (id)initWithCompletionHandler:(void (^)(ESTBeacon *))completionHandler
{
    self = [super init];
    if (self)
    {
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select beacon";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                  target:self
                                                                  action:@selector(dismiss)];
    
    [self.tableView registerClass:[ESTTableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    /* 
     * Creates sample region object (you can additionaly pass major / minor values).
     *
     * We specify it using only the ESTIMOTE_PROXIMITY_UUID because we want to discover all
     * hardware beacons with Estimote's proximty UUID.
     */
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                      identifier:@"EstimoteSampleRegion"];
    
    /*
     * Starts looking for Estimote beacons.
     * All callbacks will be delivered to beaconManager delegate.
     */
    [self.beaconManager startRangingBeaconsInRegion:self.region];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
     *Stops ranging after exiting the view.
     */
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
    
    for (ESTBeacon *beacon in beacons) {
        if ([beacon.major isEqualToNumber:@10263]) {
            self.purpleBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                            xPos:-2
                                                            yPos:-5];
        } else if ([beacon.major isEqualToNumber:@29163]) {
            self.greenBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                            xPos:0
                                                            yPos:3];
        } else if ([beacon.major isEqualToNumber:@14402]) {
            self.blueBeacon = [[MTBeacon alloc] initWithBeacon:beacon
                                                            xPos:6
                                                            yPos:-3];
        }
    }
    [self currentPos];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beaconsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    /*
     * Fill the table with beacon data.
     */
    ESTBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTBeacon *selectedBeacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        self.completionHandler(selectedBeacon);
    }];
}

- (CGPoint) currentPos{
    /*NSLog(@"PurpleDistance: %.2f", [self.purpleBeacon.beac.distance floatValue]);
    NSLog(@"GreenDistance: %.2f", [self.greenBeacon.beac.distance floatValue]);
    NSLog(@"BlueDistance: %.2f", [self.blueBeacon.beac.distance floatValue]);*/
    
    NSInteger xa = self.purpleBeacon.xPos;
    NSInteger ya = self.purpleBeacon.yPos;
    NSInteger xb = self.greenBeacon.xPos;
    NSInteger yb = self.greenBeacon.yPos;
    NSInteger xc = self.blueBeacon.xPos;
    NSInteger yc = self.blueBeacon.yPos;
    
    
    float ra = [self.purpleBeacon.beac.distance floatValue];
    float rb = [self.greenBeacon.beac.distance floatValue];
    float rc = [self.blueBeacon.beac.distance floatValue];
    
    float S = (pow(xc, 2.) - pow(xb, 2.) + pow(yc, 2.) - pow(yb, 2.) + pow(rb, 2.) - pow(rc, 2.)) / 2.0;
    float T = (pow(xa, 2.) - pow(xb, 2.) + pow(ya, 2.) - pow(yb, 2.) + pow(rb, 2.) - pow(ra, 2.)) / 2.0;
    float y = ((T * (xb - xc)) - (S * (xb - xa))) / (((ya - yb) * (xb - xc)) - ((yc - yb) * (xb - xa)));
    float x = ((y * (ya - yb)) - T) / (xb - xa);
    
    NSLog(@"X: %.2f", x);
    NSLog(@"Y: %.2f", y);
    
    CGPoint coor = CGPointMake(x, y);
    return coor;
    
    //NSLog(@"Test");
    /*float totalDistance;
    for (ESTBeacon *beacon in self.beaconsArray) {
        totalDistance += [beacon.distance floatValue];

    }
    NSLog(@"Distance: %.2f", totalDistance);*/
    
    /*ESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [totalDistance floatValue]];
    
    return cell;*/
}

@end
