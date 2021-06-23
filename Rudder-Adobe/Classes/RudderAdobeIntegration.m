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
        self.rudderEventsToAdobeEvents = [NSDictionary dictionaryWithObjects:[[config objectForKey:@"rudderEventsToAdobeEvents"] valueForKey:@"to"]
                                                                     forKeys:[[config objectForKey:@"rudderEventsToAdobeEvents"] valueForKey:@"from"]];
        //[config objectForKey:@"rudderEventsToAdobeEvents"];
        self.productIdentifier = [config objectForKey:@"productIdentifier"];
        
        [self setAdobeEcommerceEvents];
    }
    // Check : Remove the below debug statement
    [self.adobeMobile setDebugLogging:TRUE];
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
            // If it is E-Commerce event
            if (adobeEcommerceEvents[eventName])
            {
                NSMutableDictionary<NSString*, NSObject*>* eventProperties = [message.properties mutableCopy];
                NSDictionary *contextData = [self mapProducts: adobeEcommerceEvents[eventName] andProperties: eventProperties andContext:message.context andMessage: message];
                [self.adobeMobile trackAction:adobeEcommerceEvents[eventName] data:contextData];
                return;
            }
            
            // If Video Event
            
            // Custom Track event
            eventName = [self mappedEvents:eventName];
            
            // Check : Segment has implemented this way.
            // But there is one issue, "Application Opened" or other kind of events
            // which are not mapped to our dashboard, that event will never reach Adobe.
            // Same is implemented for Android.
            // So should we be implementing the same way??
            
            // My thought is that we should check if event is mapped or not.
            // If not then we should simply send that event insetad of rejecting it!
            if (!eventName) {
                [RSLogger logDebug:@"Event must be configured in Adobe and in the 'Map Rudder Events to Adobe Custom Eevnts' setting in Rudderstack before sending."];
                return;
            }
            NSMutableDictionary *eventProperties = [message.properties mutableCopy];
            NSMutableDictionary *topLevelProperties = [self extractTrackTopLevelProps:message];
            NSMutableDictionary *contextData = [self mapContextValues:eventProperties andContext:message.context withTopLevelProps:topLevelProperties];
            // Handling extra eventProperties
            if ([eventProperties count] > 0) {
                for (NSString *key in eventProperties) {
                    NSString *variable = [self.contextDataPrefix stringByAppendingString:eventProperties[key]];
                    [contextData setObject:variable forKey:key];
                }
                // Check : (Repeated) - Removing all objects at once, as it is throwing an error:
                // "NSMutable dictionary was mutated while being enumerated"
                [eventProperties removeAllObjects];
            }
            eventName = message.event;
            [self.adobeMobile trackAction:eventName data:contextData];
        }
    }else if ([type isEqualToString:@"screen"]){
        NSMutableDictionary *eventProperties = [message.properties mutableCopy];
        NSMutableDictionary *topLevelProperties = [self extractTrackTopLevelProps:message];
        NSMutableDictionary *contextData = [self mapContextValues:eventProperties andContext:message.context withTopLevelProps:topLevelProperties];
        // Handling extra eventProperties
        if ([eventProperties count] > 0) {
            for (NSString *key in eventProperties) {
                NSString *variable = [self.contextDataPrefix stringByAppendingString:eventProperties[key]];
                [contextData setObject:variable forKey:key];
            }
            // Check : (Repeated) - Removing all objects at once, as it is throwing an error:
            // "NSMutable dictionary was mutated while being enumerated"
            [eventProperties removeAllObjects];
        }
        [self.adobeMobile trackState:message.event data:contextData];

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

- (NSString *)mappedEvents:(NSString *)eventName
{
//    NSDictionary *mappedEvents = self.rudderEventsToAdobeEvents;
//    for (NSString *key in eventsV2) {
//        if ([key isEqualToString:eventName]) {
//            return [eventsV2 objectForKey:key];
//        }
//    }
//    if(mappedEvents[eventName]) {
//        return mappedEvents[eventName];
//    }
    
    NSDictionary *mappedEvent = self.rudderEventsToAdobeEvents;
    return mappedEvent[eventName];
    //    if (mappedEvent[eventName]) {
//        return mappedEvent[eventName];
//    }
//    return nil;
}

-(NSMutableDictionary *) extractTrackTopLevelProps:(RSMessage *) message {
    NSMutableDictionary *topLevelProperties = [[NSMutableDictionary alloc] initWithCapacity:10];
    [topLevelProperties setValue:message.messageId forKey:@"messageId"];
    [topLevelProperties setValue:message.event forKey:@"event"];
    [topLevelProperties setValue:message.anonymousId forKey:@"anonymousId"];
    return topLevelProperties;
}

BOOL isBoolean(NSObject* object){
    return (object == (void*)kCFBooleanFalse || object == (void*)kCFBooleanTrue);
}

-(NSDictionary<NSString *, NSObject *> *) contextMap:(RSContext *)context withKey:(NSString *) key{
    
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
    
    if ([key isEqualToString:@"userAgent"] && context.userAgent != nil) {
        NSMutableDictionary<NSString *, id> *contextData = [NSMutableDictionary<NSString *, id> dictionary];
        [contextData setObject:context.userAgent forKey: @"userAgent"];
        return contextData;
    }
    
    if ([key isEqualToString:@"locale"]) {
        NSMutableDictionary<NSString *, id> *contextData = [NSMutableDictionary<NSString *, id> dictionary];
        [contextData setObject:context.locale forKey: @"locale"];
        return contextData;
    }
    
    if ([key isEqualToString:@"device"]) {
        return context.device.dict;
    }
    
    if ([key isEqualToString:@"network"]) {
        return context.network.dict;
    }
    
    if ([key isEqualToString:@"timezone"]) {
        NSMutableDictionary<NSString *, id> *contextData = [NSMutableDictionary<NSString *, id> dictionary];
        [contextData setObject:context.timezone forKey: @"timezone"];
        return contextData;
    }
    
    return nil;
}

-(NSMutableDictionary *) mapContextValues:(NSMutableDictionary *)eventProperties andContext:(RSContext *)context withTopLevelProps:(NSMutableDictionary *)topLevelProps {
    NSInteger contextValuesSize = [self.contextData count];
//    NSDictionary *context1 = [self buildContextMap:context];
    if ([eventProperties count] > 0 && contextValuesSize > 0) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:contextValuesSize];
        NSDictionary *contextValues = self.contextData;
        for (NSString *key in contextValues) {
            if ([key containsString:@"."]) {
                // Obj-c doesn't allow chaining so to support nested context object we parse the key if it contains a `.`
                // We only support the list of predefined nested context keys as per our event spec
                NSArray *arrayofKeyComponents = [key componentsSeparatedByString:@"."];
                NSArray *predefinedContextKeys = @[ @"traits", @"app", @"device", @"library", @"os", @"network", @"screen"];
                if ([predefinedContextKeys containsObject:arrayofKeyComponents[0]]) {
                    // If 'context' contains the first key, store it in contextTraits.
                    NSDictionary<NSString *, NSObject *> *contextTraits = [self contextMap:context withKey:arrayofKeyComponents[0]];
                    NSString *parsedKey = arrayofKeyComponents[1];
                    if([contextTraits count] && contextTraits[parsedKey]) {
                        [data setObject:contextTraits[parsedKey] forKey:contextValues[key]];
                    }
                }
            }
            
            NSDictionary<NSString *, NSObject *> *payloadLocation;
            // Determine whether to check the properties or context object based on the key location
            if (eventProperties[key]) {
                payloadLocation = [NSDictionary dictionaryWithDictionary:eventProperties];
                // Check : If mapping is found then remove that key from the evntProperties payload
                [eventProperties removeObjectForKey:key];
            }
            // Check : For "userAgent" value is nil, means it is not being set in RSContext, What should we do!
            NSSet *predefinedContextKeys = [NSSet setWithArray:@[ @"traits", @"app", @"device", @"library",@"locale",@"timezone",@"userAgent", @"os", @"network", @"screen"]];
            if ([predefinedContextKeys containsObject:key]) {
                payloadLocation = [self contextMap:context withKey:key];
            }
//            NSMutableDictionary *val2 = [payloadLocation mutableCopy];
            if (payloadLocation) {
                if (isBoolean(payloadLocation[key])  &&  [payloadLocation[key] isEqual:@YES]){
                   [data setObject:@"true" forKey:contextValues[key]];
                } else if (isBoolean(payloadLocation[key])  &&  [payloadLocation[key] isEqual:@NO]){
                     [data setObject:@"false" forKey:contextValues[key]];
                } else {
                    [data setObject:payloadLocation[key] forKey:key];
                }
            }
            
            // Check : Review and edit the comment properly
            // For screen and track calls our core analytics-ios lib exposes these top level properties
            // These properties are extractetd from the  payload using helper methods (extractSEGTrackTopLevelProps & extractSEGScreenTopLevelProps)
            // Check : We should remove "name", as it is not present inside our specification.
            // Although Segment has implemented it.
            NSArray *topLevelProperties = @[@"event", @"messageId", @"anonymousId", @"name"];
            if ([topLevelProperties containsObject:key] && topLevelProps[key]) {
                [data setObject:topLevelProps[key] forKey:contextValues[key]];
            }
        }
        if ([data count] > 0) return data;
    }
    
    
    return nil;
}

-(NSMutableDictionary *) mapProducts:(NSString *)eventName andProperties:(NSMutableDictionary*) eventProperties andContext:(RSContext *)context andMessage: (nonnull RSMessage *) message {
    if(![eventProperties count]) {
        return nil;
    }
    
    NSMutableDictionary *topLevelProperties = [self extractTrackTopLevelProps:message];
    NSMutableDictionary *data = [self mapContextValues:eventProperties andContext:context withTopLevelProps:topLevelProperties];
    NSMutableDictionary *contextData = [[NSMutableDictionary alloc] initWithDictionary:data];
    
    // If you trigger a product-specific event by using the &&products variable,
    // you must also set that event in the &&events variable.
    // If you do not set that event, it is filtered out during processing.
    [contextData setObject:eventName forKey:@"&&events"];
    
    // Handle Products
    NSString *formattedProducts = @"";
    NSMutableDictionary *products = eventProperties[@"products"];
    [eventProperties removeObjectForKey:@"products"];
    // If multiple products are present
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
    // If product is present at the root level
    else {
        formattedProducts = [self formatProduct:eventProperties];
        // Check : If user sends evenrything except product_id or name
        // then formattedProducts will be null
        // In that case also, we should remove all the product variables?
        [eventProperties removeObjectForKey:@"category"];
        [eventProperties removeObjectForKey:@"quantity"];
        [eventProperties removeObjectForKey:@"price"];
        
        NSString *idKey = [self productIdentifier];
        if (idKey == nil || [idKey isEqualToString:@"id"] ) {
            [eventProperties removeObjectForKey:@"productId"];
            [eventProperties removeObjectForKey:@"product_id"];
        } else {
            [eventProperties removeObjectForKey:idKey];
        }
    }
    
    
    
    // Check : Extra properties & custom data prefix both are not handled by Segment,
    // Implementing that -> If needed we could remove it.
    // Check : Handling extraProperties, which is not handled by Segment
//    NSMutableDictionary * contextData2 = [[NSMutableDictionary alloc] initWithDictionary:data];
    // Handling extra eventProperties
    if ([eventProperties count] > 0) {
        for (NSString *key in eventProperties) {
            NSString *variable = [self.contextDataPrefix stringByAppendingString:eventProperties[key]];
            [contextData setObject:variable forKey:key];
        }
        // Check : Removing all objects at once, as it is throwing an error:
        // "NSMutable dictionary was mutated while being enumerated"
        [eventProperties removeAllObjects];
    }
    
    // Check : Is it possible product is empty for any E-Commerce events e.g., Order Completed (Purchase) event!
    if ([formattedProducts length] > 0) {
        [contextData setObject:formattedProducts forKey:@"&&products"];
    }
    return contextData;
}

/**"Category;Product;Quantity;Price
    Adobe expects products to formatted as an NSString, delimited with `;`, with values in the following order:
    `"Category;Product;Quantity;Price;eventN=X[|eventN2=X2];eVarN=merch_category[|eVarN2=merch_category2]"`

     Product is a required argument, so if this is not present, Segment does not create the
     `&&products` String. This value can be the product name, sku, or productId,
     which is configured via the Segment setting `productIdentifier`.

     If the other values in the String are missing, Segment
     will leave the space empty but keep the `;` delimiter to preserve the order
     of the product properties.

    `formatProducts` can take in an object from the products array:

     @"products" : @[
         @{
             @"product_id" : @"2013294",
             @"category" : @"Games",
             @"name" : @"Monopoly: 3rd Edition",
             @"brand" : @"Hasbros",
             @"price" : @"21.99",
             @"quantity" : @"1"
         }
     ]

     And output the following : @"Games;Monopoly: 3rd Edition;1;21.99,;Games;Battleship;2;27.98"

     It can also format a product passed in as a top level property, for example

     @{
         @"product_id" : @"507f1f77bcf86cd799439011",
         @"sku" : @"G-32",
         @"category" : @"Food",
         @"name" : @"Turkey",
         @"brand" : @"Farmers",
         @"variant" : @"Free Range",
         @"price" : @180.99,
         @"quantity" : @1,
     }

     And output the following:  @"Food;G-32;1;180.99"

     @param product Product from the products array

     @return Product string representing one product
 **/

- (NSString *) formatProduct:(NSDictionary *) product {
    NSString *category = product[@"category"] ?: @"";
    
    // The product argument is REQUIRED for Adobe ecommerce events.
    // This value can be 'name', 'sku', or 'id'. Defaults to name
    NSString *productIdentifier = product[_productIdentifier];
    
    // Check : for v1 at segment implementation
    // Fallback to id. Rudderstack ecommerce Spec'd `id` as the product identifier
    // The setting productIdentifier checks for id, where ecommerce V2
    // is expecting product_id.
    if ([[self productIdentifier] isEqualToString:@"id"]) {
        productIdentifier = product[@"product_id"] ?: product[@"id"];
        // Check : I've added a corner case (which is not handled by Segment),
        // i.e., if product_id value is integer then it's length cannott be determined.
        // Should we remove the logger comment??
        if (productIdentifier) {
            productIdentifier = [[NSString alloc] initWithFormat:@"%@",productIdentifier];
        }
    }
    
    
    if ([productIdentifier length] == 0) {
        [RSLogger logDebug:@"Product is a required field."];
        return nil;
    }
    
    // Check : If user doesn't set price then by defualt price is set to zero.
    // Which I think is not the ideal case to be, it must be removed
    // Segment has implemented in this way, so should I proceed with Segment!
    
    // Adobe expects Price to refer to the total price (unit price x units).
    int quantity = [product[@"quantity"] intValue] ?: 1;
    double price = [product[@"price"] doubleValue] ?: 0;
    double total = price * quantity;
    
    // Check : If any product value is missing e.g.,
    NSArray *output;
//    if (product[@"category"] && product[@"product"] && product[@"quantity"] && product[@"price"]) {
    if (product[@"quantity"] && product[@"price"]) {
        output = @[ category, productIdentifier, [NSNumber numberWithInt:quantity], [NSNumber numberWithDouble:total] ];
    }
    else if (product[@"quantity"]) {
        output = @[ category, productIdentifier, [NSNumber numberWithInt:quantity]];
    }
    else if (product[@"price"]) {
        NSString *emptyQuantity = @"";
        output = @[ category, productIdentifier, emptyQuantity, [NSNumber numberWithDouble:total] ];
    }
    else if (!productIdentifier){
        return nil;
    }
    else {
        output = @[ category, productIdentifier];
    }
    
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
