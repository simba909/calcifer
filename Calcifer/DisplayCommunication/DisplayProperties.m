//
//  DisplayProperties.m
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

#import "DisplayProperties.h"

@implementation DisplayProperties

- (id) initWithName:(NSString *)name andSerial:(NSString *)serial
{
    if (self = [super init]) {
        _name = name;
        _serial = serial;
        return self;
    } else {
        return nil;
    }
}

@end
