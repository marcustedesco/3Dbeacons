//
//  MTBeacon.h
//  3Dbeacons
//
//  Created by Marcus Tedesco on 4/19/14.
//  Copyright (c) 2014 com.marcustedesco. All rights reserved.
//

#import "ESTBeacon.h"

@interface MTBeacon : ESTBeacon

@property (nonatomic) ESTBeacon* beac;
@property (nonatomic) NSInteger xPos;
@property (nonatomic) NSInteger yPos;

- (MTBeacon *) initWithBeacon:(ESTBeacon *)beacon
                         xPos: (NSInteger) xPos
                         yPos: (NSInteger) yPos;

@end
