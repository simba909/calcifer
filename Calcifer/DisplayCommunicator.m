//
//  DisplayCommunicator.m
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

#import <AppKit/NSScreen.h>

#import "DisplayCommunicator.h"
#import "DDC.h"

NSString *EDIDString(char *string)
{
    NSString *temp = [[NSString alloc] initWithBytes:string length:13 encoding:NSASCIIStringEncoding];
    return ([temp rangeOfString:@"\n"].location != NSNotFound) ? [[temp componentsSeparatedByString:@"\n"] objectAtIndex:0] : temp;
}

@implementation DisplayCommunicator

- (DisplayProperties *)getPropertiesFor:(CGDirectDisplayID)display
{
    struct EDID edid = {};

    if (EDIDTest(display, &edid)) {
        NSString *name;
        NSString *serial;

        for (union descriptor *des = edid.descriptors; des < edid.descriptors + sizeof(edid.descriptors); des++) {
            switch (des->text.type) {
                case 0xFC:
                    name = EDIDString(des->text.data);
                    break;

                case 0xFF:
                    serial = EDIDString(des->text.data);
                    break;
            }
        }

        return [[DisplayProperties alloc] initWithName:name andSerial:serial];
    }

    return [[DisplayProperties alloc] initWithName:@"Unknown display" andSerial:@"0"];
}

- (void)setBrightness:(int)brightness forDisplay:(CGDirectDisplayID)display
{
    NSLog(@"Setting brightness %d for display %d", brightness, display);

    struct DDCWriteCommand command = {};
    command.control_id = BRIGHTNESS;
    command.new_value = brightness;

    if (!DDCWrite(display, &command)) {
        NSLog(@"Failed to set brightness on external display :(");
    }
}

@end
