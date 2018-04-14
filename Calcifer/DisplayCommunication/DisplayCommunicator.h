//
//  DisplayCommunicator.h
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DisplayProperties.h"

@interface DisplayCommunicator : NSObject

- (DisplayProperties *)getPropertiesFor:(CGDirectDisplayID)display;

- (int)getBrightnessFor:(CGDirectDisplayID)display;

- (void)setBrightness:(int)brightness forDisplay:(CGDirectDisplayID)display;

@end
