//
//  MTBeaconStore.m
//  3Dbeacons
//
//  Created by Marcus Tedesco on 4/19/14.
//  Copyright (c) 2014 com.marcustedesco. All rights reserved.
//

#import "MTBeaconStore.h"

@implementation MTBeaconStore

- (CGPoint) currentPosFromBeacons {
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
