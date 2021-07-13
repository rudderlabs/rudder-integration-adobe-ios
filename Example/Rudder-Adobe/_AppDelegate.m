//
//  _AppDelegate.m
//  Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "_AppDelegate.h"
#import <Rudder/Rudder.h>
#import <RudderAdobeFactory.h>
#import <CoreLocation/CoreLocation.h>

@interface _AppDelegate () <CLLocationManagerDelegate>
@property(nonatomic) CLLocationManager *locationManager;
@end

@implementation _AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *WRITE_KEY = @"1s4gjAsjU2O41t6JwCGsCgZf6sg";
    NSString *DATA_PLANE_URL = @"https://8b2e94cad5ff.ngrok.io";
    
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:DATA_PLANE_URL];
    [configBuilder withControlPlaneUrl:@"https://fcc1cb53a2cd.ngrok.io"];
    //[configBuilder withLoglevel:RSLogLevelDebug];
    [configBuilder withFactory:[RudderAdobeFactory instance]];
    // [configBuilder withTrackLifecycleEvens:false];
    [RSClient getInstance:WRITE_KEY config:[configBuilder build]];
    
    
    
    [[RSClient sharedInstance] identify:@"iOS_user_new"];
    [self videoEvents];

//    [[RSClient sharedInstance] track:@"Order Completed" properties:@{
//        @"orderId" : @"1001",
//        @"curr" : @"USD",
//        @"1" : @"1custom",
//        @"2" : @1345,
//        @"products" : @[
//                @{
//                    @"category" : @"11Cloths",
//                    @"product_id" : @"100001",
//                    @"name": @"11Shirt",
//                    @"price" : @101,
//                    @"quantity" : @11
//                },
//                @{
//                    @"category" : @"12Cloths",
//                    @"product_id" : @"100002",
//                    @"name": @"12shirt",
//                    @"price" : @102,
//                    @"quantity" : @12
//                }
//        ]
//    }];
//
//    [[RSClient sharedInstance] track:@"Order Completed" properties:@{
//        @"revenue" : @1001,
//        @"orderId" : @"1001",
//        @"currency" : @"USD",
//        @"custom_1" : @"1custom",
//        @"custom_2" : @1345,
//        @"category" : @"11Cloths",
//        @"productId" : @"100001",
//        @"name": @"11Shirt",
//        @"price" : @101,
//        @"quantity" : @11
//    }];
//
//    [[RSClient sharedInstance] track:@"Product Added"
//                          properties:@{
//                              @"1" : @"2custom",
//                              @"2" : @YES,
//                              @"category" : @"Product_Added_Category",
//                              @"productId" : @"200001",
//                              @"name": @"21Bag",
//                              @"quantity" : @21,
//                              @"price" : @201
//                          }];
//
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"revenue" : @3001,
//                              @"orderId" : @3001,
//                              @"currency" : @"USD",
//                              @"custom_1" : @"3custom",
//                              @"custom_2" : @3345,
//                              @"products" : @[
//                                      @{
//                                          @"category" : @"31Cloths",
//                                          @"product_id" : @300001,
//                                          @"name": @"31Shirt",
//                                          @"price" : @301,
//                                          @"quantity" : @31
//                                      },
//                                      @{
//                                          @"category" : @"32Cloths",
//                                          @"product_id" : @"300002",
//                                          @"name": @"32shirt",
//                                          @"price" : @302,
//                                          @"quantity" : @32
//                                      }
//                              ]
//                          }];
//
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"custom_2" : @32345,
//                              @"products" : @[
//                                      @{
//                                          @"product_id" : @3200001,
//                                          @"name": @"33Shirt",
//                                          @"price" : @301
//                                      },
//                                      @{
//                                          @"product_id" : @"3200002",
//                                          @"name": @"34shirt",
//                                          @"quantity" : @32
//                                      }
//                              ]
//                          }];
//    
//    [[RSClient sharedInstance] track:@"Checkout Started"
//                          properties:@{
//                              @"custom_2" : @32345,
//                          }];
//
//    [[RSClient sharedInstance] track:@"cart viewed"
//                              properties:@{
//                                  @"custom_2" : @4345,
//                              }];
//
//    [[RSClient sharedInstance] track:@"product removed"
//                              properties:@{
//                                  @"custom_2" : @5345,
//                              }];
//
//    [[RSClient sharedInstance] track:@"product viewed"
//                              properties:@{
//                                  @"custom_2" : @6345,
//                              }];
//
    
//    [[RSClient sharedInstance] track:@"Custom Track"
//                              properties:@{
//                                  @"1" : @123.56,
//                                  @"2" : @72345,
//                                  @"3" : @"String1",
//                                  @"4" : @"Custom track call 1"
//                              }];
//
//    [[RSClient sharedInstance] screen:@"screen_call"
//                                  properties:@{
//                                      @"custom_2" : @82345,
//                                  }];
//
    //--------------------------------------------------------------------------------
    
    
    /*
    NSMutableDictionary<NSString *, id> *products1 = [NSMutableDictionary<NSString *, id> dictionary];
    [products1 setObject: @"Games"  forKey: @"category"];
    [products1 setObject: @"1234" forKey: @"id"];
    [products1 setObject: @"20" forKey: @"quantity"];
    [products1 setObject: @"5001" forKey: @"price"];
    [products1 setObject: @"Abhishek" forKey: @"name"];

    NSMutableDictionary<NSString *, id> *products2 = [NSMutableDictionary<NSString *, id> dictionary];
    [products2 setObject: @"Games"  forKey: @"category"];
    [products2 setObject: @"1234" forKey: @"product_id"];
    [products2 setObject: @"20" forKey: @"quantity"];
    [products2 setObject: @"5001" forKey: @"price"];
    
    NSMutableArray<NSObject *>* product = [NSMutableArray array];
    [product addObject: products1];
    [product addObject: products2];
    
    [[RSClient sharedInstance] track:@"Product Added" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"product removed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"cart viewed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"checkout started" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"order completed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    
    [[RSClient sharedInstance] track:@"product viewed" properties:@{
        @"key_1" : @YES,
        @"key_2" : @"value_2",
        @"products" : product
    }];
    */
    
    
    return YES;
}

- (void) videoEvents {
    [self trackVideoPlaybackStarted];
    [self trackVideoQualityUpdated];
    [self trackVideoPlaybackResumed];
    [self trackVideoPlaybackCompleted];
}

- (void) trackVideoPlaybackStarted {
    [[RSClient sharedInstance] track:@"Playback Started" properties:@{
        @"assetId" : @"Playback Started asset ID",             //Content           //MediaObject   //a.media...
        @"program" : @"Program: Flash",                        //show              //a.media...
        @"season" : @"season: Season-1",                                           //a.media...
        @"episode" : @"episdoe: Episode-1",                                        //a.media...
        @"genre" : @"genre: Sci-Fi",                                               //a.media...
        @"channel" : @"channel: Amaz",                         //NETWORK           //a.media...
        @"airdate" : @"airdat: 28june",                                            //a.media...    -NO
        @"publisher" : @"publisher: 1",                      //ORIGINATOR        //a.media...    -NO
        @"rating" : @"rating: 62",                                                //a.media...    -NO
        @"title" : @"title: Flash_Season_3",                   //Content Name      //MediaObject
        @"totalLength" : @300,                                  //Content Length    //MediaObject
        @"livestream" : @true,                                  //Content Type      //(default VOD)
        
        @"video_player" : @"video_player: html",
        
        //Custom Properties
        @"full_screen" : @true,
        @"framerate" : @"598",
        @"ad_enabled" : @true,
        @"quality" : @"hd1800p",
        @"bitrate" : @256,
        @"sound" : @129
    }];
}

- (void) trackVideoPlaybackPaused {
    [[RSClient sharedInstance] track:@"Playback Paused"];
}

- (void) trackVideoPlaybackResumed {
    [[RSClient sharedInstance] track:@"Playback Resumed"];
}

- (void) trackVideoContentStarted {
    [[RSClient sharedInstance] track:@"Content Start" properties:@{
        @"chapter_name" : @"title: You Win Die29",
        @"length" : @299.0,
        @"startTime" : @291.0,
        @"position" : @295
    }];
}

- (void) trackVideoContentComplete {
    [[RSClient sharedInstance] track:@"Content Complete"];
}

- (void) trackVideoPlaybackCompleted {
    [[RSClient sharedInstance] track:@"Playback Completed"];
}

- (void) trackVideoBufferStarted {
    [[RSClient sharedInstance] track:@"Buffer Started"];
}

- (void) trackVideoBufferComplete {
    [[RSClient sharedInstance] track:@"Buffer Completed"];
}

- (void) trackVideoSeekStarted {
    [[RSClient sharedInstance] track:@"Seek Started"];
}

- (void) trackVideoSeekComplete {
    [[RSClient sharedInstance] track:@"Seek Complete" properties:@{
        @"seekPosition" : @73L
    }];
}

- (void) trackVideoAdBreakStarted {
    [[RSClient sharedInstance] track:@"Ad Break Started" properties:@{
        @"title" : @"title: TV Commercial29",
        @"startTime" : @29.0,
        @"indexPosition" : @99L
    }];
}

- (void) trackVideoAdBreakCompleted {
    [[RSClient sharedInstance] track:@"Ad Break Completed"];
}

- (void) trackVideoAdStarted {
    [[RSClient sharedInstance] track:@"Ad Start" properties:@{
        @"title" : @"title: TV Commercial3291",
        @"assetId" : @"12300001",
        @"totalLength" : @129.01,
        @"position" : @81L
    }];
}

- (void) trackVideoAdSkipped {
    [[RSClient sharedInstance] track:@"Ad Skipped"];
}

- (void) trackVideoAdCompleted {
    [[RSClient sharedInstance] track:@"Ad Completed"];
}

- (void) trackVideoPlaybackInterrupted {
    [[RSClient sharedInstance] track:@"Playback Interrupted"];
}

- (void) trackVideoQualityUpdated {
    [[RSClient sharedInstance] track:@"Quality Updated" properties:@{
        @"bitrate" : @256,
        @"startupTime" : @39,
        @"fps" : @64,
        @"droppedFrames" : @3
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
