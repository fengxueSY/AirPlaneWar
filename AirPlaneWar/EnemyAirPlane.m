//
//  EnemyAirPlane.m
//  AirPlaneWar
//
//  Created by 666gps on 2017/5/10.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "EnemyAirPlane.h"

@implementation EnemyAirPlane

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 40, 29)]) {
        self.image = [UIImage imageNamed:@"plane2.png"];
    }
    return self;
}


@end
