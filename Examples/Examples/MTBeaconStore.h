//
//  MTBeaconStore.h
//
//
//  Created by Marcus Tedesco on 4/19/14.
//  Copyright (c) 2014 com.marcustedesco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBeacon.h"

@interface MTBeaconStore : NSObject
@property (nonatomic, strong) MTBeacon *purpleBeacon;
@property (nonatomic, strong) MTBeacon *greenBeacon;
@property (nonatomic, strong) MTBeacon *blueBeacon;
- (CGPoint) currentPosFromBeacons;
@end
