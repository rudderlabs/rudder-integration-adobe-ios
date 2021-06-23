//  RudderAdobeIntegration.h
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
//#import <Rudder/RSLogger.h>

#import <AdobeMobileSDK/ADBMobile.h>


NS_ASSUME_NONNULL_BEGIN

@interface RudderAdobeIntegration : NSObject<RSIntegration>

@property (nonatomic) NSString *trackingServerUrl;
@property (nonatomic) NSString *contextDataPrefix;
@property (nonatomic) NSString *productIdentifier;

@property (nonatomic) BOOL ssl;

@property (nonatomic) NSDictionary *videoEvents;
@property (nonatomic) NSDictionary *contextData;
@property (nonatomic) NSDictionary *rudderEventsToAdobeEvents;

@property (nonatomic, strong) Class _Nullable adobeMobile;

-(instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig adobe:(id _Nullable)ADBMobileClass;

@end

NS_ASSUME_NONNULL_END
