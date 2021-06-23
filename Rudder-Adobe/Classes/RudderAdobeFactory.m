//  RudderAdobeFactory.m
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "RudderAdobeFactory.h"
#import "RudderAdobeIntegration.h"
//#import <AdobeMediaSDK/ADBMediaHeartbeatConfig.h>
//#import <AdobeVideoHeartbeatSDK/ADBMediaHeartbeatConfig.h>
//#import <AdobeVideoHeartbeatSDK/ADBMediaHeartbeatConfig.h>

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
    
//    id<SEGADBMediaObjectFactory> mediaObjectFactory = [[SEGRealADBMediaObjectFactory alloc] init];
//    id<SEGADBMediaHeartbeatFactory> mediaHeartbeatFactory = [[SEGRealADBMediaHeartbeatFactory alloc] init];
    id adobeMobile = [ADBMobile class];
//    id config = [[ADBMediaHeartbeatConfig alloc] init];
//    id<SEGPlaybackDelegateFactory> delegateFactory = [[SEGRealPlaybackDelegateFactory alloc] init];
    
    [RSLogger logDebug:@"Creating RudderIntegrationFactory: Adobe"];
    return [[RudderAdobeIntegration alloc] initWithConfig:config
                                                withAnalytics:client
                                             withRudderConfig:rudderConfig
                                                    adobe:adobeMobile];
}
@end
