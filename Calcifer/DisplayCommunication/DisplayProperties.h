//
//  DisplayProperties.h
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayProperties : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *serial;

- (id)initWithName:(NSString *)name andSerial:(NSString *)serial;

@end
