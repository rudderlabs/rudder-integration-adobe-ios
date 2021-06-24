//  RudderAdobeFactory.m
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "RudderAdobeFactory.h"
#import "RudderAdobeIntegration.h"
#import <AdobeVideoHeartbeatSDK/ADBMediaHeartbeatConfig.h>
#import <AdobeVideoHeartbeatSDK/ADBMediaHeartbeatConfig.h>

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
    
    id adobeMobileClass = [ADBMobile class];
    id heartbeatConfig = [[ADBMediaHeartbeatConfig alloc] init];
    id<RSADBMediaObjectFactory> mediaObjectFactory = [[RSRealADBMediaObjectFactory alloc] init];
    id<RSADBMediaHeartbeatFactory> mediaHeartbeatFactory = [[RSRealADBMediaHeartbeatFactory alloc] init];
    id<RSPlaybackDelegateFactory> delegateFactory = [[RSRealPlaybackDelegateFactory alloc] init];

    
    [RSLogger logDebug:@"Creating RudderIntegrationFactory: Adobe"];
    return [[RudderAdobeIntegration alloc] initWithConfig:config
                                            withAnalytics:client
                                         withRudderConfig:rudderConfig
                                                    adobe:adobeMobileClass
                                 andMediaHeartbeatFactory:(id<RSADBMediaHeartbeatFactory> _Nullable)mediaHeartbeatFactory
                                  andMediaHeartbeatConfig:(ADBMediaHeartbeatConfig *_Nullable)heartbeatConfig
                                    andMediaObjectFactory:(id<RSADBMediaObjectFactory> _Nullable)mediaObjectFactory
                                  andPlaybackDelegateFactory:(id<RSPlaybackDelegateFactory> _Nullable)delegateFactory
            ];
}
@end
