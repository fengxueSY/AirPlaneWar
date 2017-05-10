//
//  MyAirPlane.m
//  AirPlaneWar
//
//  Created by 666gps on 2017/5/10.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "MyAirPlane.h"

@implementation MyAirPlane

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 66, 72)]) {
        self.image = [UIImage imageNamed:@"plane1.png"];
    }
    return self;
}

- (void)start{
    self.image = [UIImage imageNamed:@"plane1.png"];
}

- (void)dead{
    self.image = [UIImage imageNamed:@"bow.png"];
}


@end
