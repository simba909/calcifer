//
//  DisplayProperties.h
//  Calcifer
//
//  Created by Simon Jarbrant on 2018-01-26.
//  Copyright © 2018 Simon Jarbrant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayProperties : NSObject

@property(nonnull, nonatomic, readonly) NSString *name;
@property(nonnull, nonatomic, readonly) NSString *serial;

- (id)initWithName:(nonnull NSString *)name andSerial:(nonnull NSString *)serial;

@end
