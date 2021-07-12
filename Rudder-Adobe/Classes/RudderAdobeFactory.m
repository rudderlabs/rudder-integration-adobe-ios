//  RudderAdobeFactory.m
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "RudderAdobeFactory.h"
#import "RudderAdobeIntegration.h"

@implementation RudderAdobeFactory

static RudderAdobeFactory *sharedInstance;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key {
    return @"Adobe Analytics";
}

-(id<RSIntegration>)initiate:(NSDictionary *)config client:(RSClient *)client rudderConfig:(RSConfig *)rudderConfig{

    [RSLogger logDebug:@"Creating RudderIntegrationFactory: Adobe"];
    return [[RudderAdobeIntegration alloc] initWithConfig:config
                                            withAnalytics:client
                                         withRudderConfig:rudderConfig
            ];
}
@end
