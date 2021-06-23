//  RudderAdobeIntegration.m
//  Pods-Rudder-Adobe
//
//  Created by Desu Sai Venkat on 16/06/2021.
//  Copyright (c) 2021 Desu Sai Venkat. All rights reserved.
//

#import "RudderAdobeIntegration.h"
#import <Rudder/Rudder.h>

#import <AdobeMobileSDK/ADBMobile.h>

static NSDictionary *adobeEcommerceEvents;

@implementation RudderAdobeIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig *)rudderConfig adobe:(id _Nullable)ADBMobileClass {
    self = [super init];
    if (self) {
        // do initialization here
        [RSLogger logDebug:@"Initializing Adobe SDK"];
        
        self.adobeMobile = ADBMobileClass;
        
        self.trackingServerUrl = [config objectForKey:@"heartbeatTrackingServerUrl"];
        
        if ([config objectForKey:@"contextDataPrefix"] == nil || [[config objectForKey:@"contextDataPrefix"] isEqualToString:(@"a.")]) {
            self.contextDataPrefix = @"";
        }
        else {
            self.contextDataPrefix = [config objectForKey:@"contextDataPrefix"];
        }
        
        self.ssl = [[config objectForKey:@"sslHeartbeat"] boolValue];
        
        self.videoEvents = [config objectForKey:@"eventsToTypes"];
        self.contextData = [NSDictionary dictionaryWithObjects:[[config objectForKey:@"contextDataMapping"] valueForKey:@"to"]
                                                       forKeys:[[config objectForKey:@"contextDataMapping"] valueForKey:@"from"]];
        //[config objectForKey:@"contextDataMapping"];
        self.rudderEventsToAdobeEvents = [config objectForKey:@"rudderEventsToAdobeEvents"];
        self.productIdentifier = [config objectForKey:@"productIdentifier"];
        
        [self setAdobeEcommerceEvents];
    }
    if(rudderConfig.logLevel == RSLogLevelVerbose) {
        [self.adobeMobile setDebugLogging:TRUE];
    }
//    [self.adobeMobile collectLifecycleData];
    
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
        if (message.event)
        {
            NSString* eventName = [message.event lowercaseString];
            NSMutableDictionary *propertiesDictionary = [message.properties mutableCopy];
            [ADBMobile trackAction:@"myapp.ActionName" data:propertiesDictionary];
//            KVAEvent *event;
            // If it is E-Commerce event
            if (adobeEcommerceEvents[eventName])
            {
                NSMutableDictionary<NSString*, NSObject*>* eventProperties = [message.properties mutableCopy];
                NSDictionary *contextData = [self mapProducts: adobeEcommerceEvents[eventName] andProperties: eventProperties andContext:message.context andMessage: message];
//                NSDictionary *contextData = [self mapProducts:]
                [self.adobeMobile trackAction:adobeEcommerceEvents[eventName] data:contextData];
//                SEGLog(@"[ADBMobile trackAction:%@ data:%@];", event, contextData);
                return;
            }
            
            
        }
    }else if ([type isEqualToString:@"screen"]){
        // do for screen
    }
    else if ([type isEqualToString:@"identify"]){
        // do for identify
        if (!message.userId) return;
        [self.adobeMobile setUserIdentifier : message.userId];
        [RSLogger logDebug:[NSString stringWithFormat:@"[ADBMobile setUserIdentifier:%@]", message.userId]];
    }
    else {
        [RSLogger logDebug:@"Adobe Integration: Message type not supported"];
    }

}

-(NSMutableDictionary *) extractTrackTopLevelProps:(RSMessage *) message {
    NSMutableDictionary *topLevelProperties = [[NSMutableDictionary alloc] initWithCapacity:10];
    [topLevelProperties setValue:message.messageId forKey:@"messageId"];
    [topLevelProperties setValue:message.event forKey:@"event"];
    [topLevelProperties setValue:message.anonymousId forKey:@"anonymousId"];
    return topLevelProperties;
}

//-(NSMutableDictionary *) mapContextValues:(NSMutableDictionary *) eventProperties andContext
//{
//    return nil;
//}

BOOL isBoolean(NSObject* object)
//-(BOOL) isBoolean:(NSObject*) object
{
//    if ([obj isKindOfClass:[ExampleClass BOOL]]) {
//    return [object class] == [BOOL class];//[object isKindOfClass:[CFBoolean class]];
    return (object == (void*)kCFBooleanFalse || object == (void*)kCFBooleanTrue);//    CFTypeID boolTypeID = CFBooleanGetTypeID();
//    //the type ID of CFBoolean
//    CFTypeID objectTypeID = CFGetTypeID((__bridge CFTypeRef)(object));
//    //the type ID of num
//    return objectTypeID == boolTypeID;
}

-(NSDictionary<NSString *, NSObject *> *) contextMap:(RSContext *)context withKey:(NSString *) key{
//    NSMutableDictionary *contextData = [[NSMutableDictionary alloc] initWithDictionary:context.traits];
//       @"traits", @"app", @"device", @"library", @"os", @"network", @"screen"
//    @[ @"traits", @"app", @"device", @"library",@"locale",@"timezone",@"userAgent", @"os", @"network", @"screen"]];
    if ([key isEqualToString:@"app"]) {
        return context.app.dict;
    }
    
    if ([key isEqualToString:@"traits"]) {
        return context.traits;
    }
    
    if ([key isEqualToString:@"library"]) {
        return context.library.dict;
    }
    
    if ([key isEqualToString:@"os"]) {
        return context.os.dict;
    }
    
    if ([key isEqualToString:@"screen"]) {
        return context.screen.dict;
    }
    
    // Check : Remove it
    context.userAgent=@"mobile";
    if ([key isEqualToString:@"userAgent"]
        && context.userAgent != nil) {
        NSMutableDictionary<NSString *, id> *contextData = [NSMutableDictionary<NSString *, id> dictionary];
        [contextData setObject:context.userAgent forKey: @"userAgent"];
//        NSMutableArray * object = [context.userAgent mutableCopy];
//        NSDictionary<NSString *, NSObject *> * contextData = [[NSDictionary<NSString *, NSObject *> alloc] initWithObjects:object forKeys:@"userAgent"];
////        [contextData set: forKey:];
        return contextData;
    }
    
    // Check : Remove it
    if ([key isEqualToString:@"locale"]) {
        NSDictionary<NSString *, NSObject *> * contextData = [NSDictionary<NSString *, NSObject *> alloc];
        [contextData setValue:context.locale forKey:@"locale"];
        return contextData;
    }
    
    if ([key isEqualToString:@"device"]) {
        return context.device.dict;
    }
    
    if ([key isEqualToString:@"network"]) {
        return context.network.dict;
    }
    
    // Check : Remove it
    if ([key isEqualToString:@"timezone"]) {
        NSDictionary<NSString *, NSObject *> * contextData = [NSDictionary<NSString *, NSObject *> alloc];
        [contextData setValue:context.timezone forKey:@"timezone"];
        return contextData;
    }
    
    return nil;
}

-(NSMutableDictionary *) mapContextValues:(NSMutableDictionary *)eventProperties andContext:(RSContext *)context withTopLevelProps:(NSMutableDictionary *)topLevelProps
{
    NSInteger contextValuesSize = [self.contextData count];
//    NSDictionary *context1 = [self buildContextMap:context];
    if ([eventProperties count] > 0 && contextValuesSize > 0) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:contextValuesSize];
        NSDictionary *contextValues = self.contextData;
        for (NSString *key in contextValues) {
            if ([key containsString:@"."]) {
                // Obj-c doesn't allow chaining so to support nested context object we parse the key if it contains a `.`
                // We only support the list of predefined nested context keys per our event spec
                NSArray *arrayofKeyComponents = [key componentsSeparatedByString:@"."];
//                NSDictionary *val = context;
                NSArray *predefinedContextKeys = @[ @"traits", @"app", @"device", @"library", @"os", @"network", @"screen"];
                if ([predefinedContextKeys containsObject:arrayofKeyComponents[0]]) {
//                    NSDictionary *contextTraits = [context valueForKey:arrayofKeyComponents[0]];
                    NSDictionary<NSString *, NSObject *> *contextTraits = [self contextMap:context withKey:arrayofKeyComponents[0]];
                    NSString *parsedKey = arrayofKeyComponents[1];
//                    [data setObject:contextTraits[parsedKey] forKey:contextValues[key]];
                    if([contextTraits count]
                       && contextTraits[parsedKey]) {
                        [data setObject:contextTraits[parsedKey] forKey:contextValues[key]];
                    }
                }
            }
            
//            NSDictionary *payloadLocation;
            NSDictionary<NSString *, NSObject *> *payloadLocation;
            // Determine whether to check the properties or context object based on the key location
            if (eventProperties[key]) {
                payloadLocation = [NSDictionary dictionaryWithDictionary:eventProperties];
            }
            
            // Check: Traits key is skipped as Segment doesn't have traits in their context payload
            NSSet *predefinedContextKeys = [NSSet setWithArray:@[ @"traits", @"app", @"device", @"library",@"locale",@"timezone",@"userAgent", @"os", @"network", @"screen"]];
            if ([predefinedContextKeys containsObject:key]) {
                payloadLocation = [self contextMap:context withKey:key];
            }
            
            if (payloadLocation) {
                if (isBoolean(payloadLocation[key])  &&  [payloadLocation[key] isEqual:@YES]){
                   [data setObject:@"true" forKey:contextValues[key]];
                } else if (isBoolean(payloadLocation[key])  &&  [payloadLocation[key] isEqual:@NO]){
                     [data setObject:@"false" forKey:contextValues[key]];
                } else {
                    [data setObject:payloadLocation[key] forKey:key];
                }
            }
            
            NSMutableDictionary *val = [topLevelProps mutableCopy];
            // For screen and track calls our core analytics-ios lib exposes these top level properties
            // These properties are extractetd from the  payload using helper methods (extractSEGTrackTopLevelProps & extractSEGScreenTopLevelProps)
            NSArray *topLevelProperties = @[@"event", @"messageId", @"anonymousId", @"name"];
            if ([topLevelProperties containsObject:key] && topLevelProps[key]) {
                [data setObject:topLevelProps[key] forKey:contextValues[key]];
            }
        }
        if ([data count] > 0) return data;
    }
    
    
    return nil;
}

-(NSMutableDictionary *) mapProducts:(NSString *)eventName andProperties:(NSMutableDictionary*) eventProperties andContext:(RSContext *)context andMessage: (nonnull RSMessage *) message
{
    if(![eventProperties count]) {
        return nil;
    }
    
    NSMutableDictionary *contextData = [NSMutableDictionary dictionary];
    NSMutableDictionary *topLevelProperties = [self extractTrackTopLevelProps:message];
    NSMutableDictionary *data = [self mapContextValues:eventProperties andContext:context withTopLevelProps:topLevelProperties];
    
    
    // If you trigger a product-specific event by using the &&products variable,
    // you must also set that event in the &&events variable.
    // If you do not set that event, it is filtered out during processing.
    [contextData setObject:eventName forKey:@"&&events"];
    
    // Handle Products
    NSString *formattedProducts = @"";
    NSMutableDictionary *products = eventProperties[@"products"];
    if ([products isKindOfClass:[NSArray class]]) {
        int count = 0;
        for (NSDictionary *product  in products) {
            NSString *productString = [self formatProduct:product];
            // Catch the case where productIdentifier is nil
            if (productString == nil) {
                return nil;
            }
            formattedProducts = [formattedProducts stringByAppendingString:productString];
            count++;
            if (count < [products count]) {
                formattedProducts = [formattedProducts stringByAppendingString:@","];
            }
        }
    }
    else {
        formattedProducts = [self formatProduct:products];
    }
    
    [contextData setObject:formattedProducts forKey:@"&&products"];
    return contextData;
}

- (NSString *) formatProduct:(NSDictionary *) product {
    NSString *category = product[@"category"] ?: @"";
    
    // The product argument is REQUIRED for Adobe ecommerce events.
    // This value can be 'name', 'sku', or 'id'. Defaults to name
    NSString *productIdentifier = _productIdentifier;
    
    // Fallback to id. Segment's ecommerce v1 Spec'd `id` as the product identifier
    // The setting productIdentifier checks for id, where ecommerce V2
    // is expecting product_id.
    if ([productIdentifier isEqualToString:@"id"]) {
        productIdentifier = product[@"product_id"] ?: product[@"id"];
    }
    
    if ([productIdentifier length] == 0) {
        [RSLogger logDebug:@"Product is a required field."];
        return nil;
    }
    
    // Adobe expects Price to refer to the total price (unit price x units).
    int quantity = [product[@"quantity"] intValue] ?: 1;
    double price = [product[@"price"] doubleValue] ?: 0;
    double total = price * quantity;
    
    NSArray *output = @[ category, productIdentifier, [NSNumber numberWithInt:quantity], [NSNumber numberWithDouble:total] ];
    return [output componentsJoinedByString:@";"];
}

-(void) setAdobeEcommerceEvents {
    adobeEcommerceEvents =
    @{
        @"product added" : @"scAdd",
        @"product removed" : @"scRemove",
        @"cart viewed" : @"scView",
        @"checkout started" : @"scCheckout",
        @"order completed" : @"purchase",
        @"product viewed" : @"prodView"
    };
}

@end
