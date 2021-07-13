//  RudderAdobeIntegration.h
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

#import <AdobeMobileSDK/ADBMobile.h>
//#import <AdobeVideoHeartbeatSDK/ADBMediaHeartbeatConfig.h>

NS_ASSUME_NONNULL_BEGIN

@class ADBMediaHeartbeat;
@class ADBMediaObject;
@class ADBMediaHeartbeatConfig;



@protocol RSADBMediaHeartbeatFactory <NSObject>
- (ADBMediaHeartbeat *_Nullable) createWithDelegate:(id)delegate  andConfig:(ADBMediaHeartbeatConfig *)config;
@end

@interface RSRealADBMediaHeartbeatFactory : NSObject <RSADBMediaHeartbeatFactory>
@end




@protocol RSADBMediaObjectFactory <NSObject>
- (ADBMediaObject *_Nullable) createWithProperties:(NSDictionary *_Nullable)properties andEventType:(NSString *_Nullable)eventType;
@end

@interface RSRealADBMediaObjectFactory : NSObject <RSADBMediaObjectFactory>
@end




@interface RSPlaybackDelegate : NSObject
/**
 * Quality of service object. This is created and updated upon receipt of a "Video Quality Update"
 * event, which triggers createAndUpdateQoSObject(properties)
 */
@property (nonatomic, strong, nullable) ADBMediaObject *qosObject;
/** The system time in seconds at which the playheadPosition has been recorded.*/
@property (nonatomic) long playheadPositionTime;
/** The current playhead position in seconds.*/
@property (nonatomic) long playheadPosition;
/** Whether the video playhead is in a paused state.*/
@property (nonatomic) BOOL isPaused;

- (instancetype _Nullable)initWithPlayheadPosition:(long)playheadPosition;
- (NSTimeInterval)getCurrentPlaybackTime;
- (void)pausePlayhead;
- (void)unPausePlayhead;
- (void)updatePlayheadPosition:(long)playheadPosition;
- (void)createAndUpdateQOSObject:(NSDictionary *_Nullable)properties;
@end




@protocol RSPlaybackDelegateFactory <NSObject>
-(RSPlaybackDelegate *_Nullable)createPlaybackDelegateWithPosition:(long)playheadPosition;
@end

@interface RSRealPlaybackDelegateFactory : NSObject <RSPlaybackDelegateFactory>
@end







@interface RudderAdobeIntegration : NSObject<RSIntegration>

@property (nonatomic) NSString *trackingServerUrl;
@property (nonatomic) NSString *contextDataPrefix;
@property (nonatomic) NSString *productIdentifier;

@property (nonatomic) NSDictionary *videoEvents;
@property (nonatomic) NSDictionary *contextData;
@property (nonatomic) NSDictionary *rudderEventsToAdobeEvents;


@property (nonatomic) BOOL ssl;
@property (nonatomic) BOOL isTrackLifecycleEvents;
@property (nonatomic) BOOL videoDebug;
@property (nonatomic) BOOL sessionStarted;

@property (nonatomic, strong, nullable) ADBMediaHeartbeat *mediaHeartbeat;
@property (nonatomic, strong, nullable) id<RSADBMediaHeartbeatFactory> heartbeatFactory;
@property (nonatomic, strong, nullable) ADBMediaHeartbeatConfig *heartbeatConfig;

@property (nonatomic, strong, nullable) ADBMediaObject *mediaObject;
@property (nonatomic, strong, nullable) id<RSADBMediaObjectFactory> objectFactory;

@property (nonatomic, strong, nullable) RSPlaybackDelegate *playbackDelegate;
@property (nonatomic, strong, nullable) id<RSPlaybackDelegateFactory> delegateFactory;

@property (nonatomic, strong) Class _Nullable adobeMobile;

-(instancetype) initWithConfig:(NSDictionary *)config
                withAnalytics:(RSClient *)client
             withRudderConfig:(RSConfig*) rudderConfig
;

@end

NS_ASSUME_NONNULL_END
