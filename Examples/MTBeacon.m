//
//  MTBeacon.m
//  3Dbeacons
//
//  Created by Marcus Tedesco on 4/19/14.
//  Copyright (c) 2014 com.marcustedesco. All rights reserved.
//

#import "MTBeacon.h"

@implementation MTBeacon

- (MTBeacon *)initWithBeacon:(ESTBeacon *)beacon
                         xPos:(NSInteger)xPos
                        yPos:(NSInteger)yPos {
    self = [super init];
    if (self) {
        self.beac = beacon;
        self.xPos = xPos;
        self.yPos = yPos;
        //self = [beacon copy];
    }
    return self;
}

//- (void)setXPos:(NSInteger)xPos {
//    self.xPos = xPos;
//}
//
//- (void)setYPos:(NSInteger)yPos {
//    self.yPos = yPos;
//}

@end
