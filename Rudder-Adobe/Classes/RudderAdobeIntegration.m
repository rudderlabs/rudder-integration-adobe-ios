//  RudderAdobeIntegration.m
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "RudderAdobeIntegration.h"
#import <Rudder/Rudder.h>

@implementation RudderAdobeIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig *)rudderConfig {
    self = [super init];
    if (self) {
        [RSLogger logDebug:@"Initializing Adobe SDK"];
    }
    return self;
}

- (void) dump:(RSMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void)reset {
    [RSLogger logDebug:@"Inside reset"];
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if([type isEqualToString:@"track"]){
        // do for track
    }else if ([type isEqualToString:@"screen"]){
        // do for screen
    }else if ([type isEqualToString:@"identify"]){
        // do for identify
    }else if ([type isEqualToString:@"group"]){
        // do for group
    }else if ([type isEqualToString:@"alias"]){
        // do for alias
    }else {
        [RSLogger logDebug:@"Adobe Integration: Message type not supported"];
    }
    
}

@end
