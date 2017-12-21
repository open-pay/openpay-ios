//
//  OPAdress.m
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import "OPAddress.h"

@implementation OPAddress

+(OPAddress*) initWithDictionary: (NSMutableDictionary*) dictionary {
    if (dictionary == nil || dictionary == NULL || [dictionary class] == [NSNull class]) {
        return nil;
    }
    OPAddress *address = [[OPAddress alloc] init];
    address.city = [dictionary objectForKey:@"city"];
    address.countryCode = [dictionary objectForKey:@"country_code"];
    address.postalCode = [dictionary objectForKey:@"postal_code"];
    address.line1 = [dictionary objectForKey:@"line1"];
    address.line2 = [dictionary objectForKey:@"line2"];
    address.line3 = [dictionary objectForKey:@"line3"];
    address.state = [dictionary objectForKey:@"state"];
    
    return address;
}

-(NSMutableDictionary*) asMutableDictionary {
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              self.city, @"city",
                                              self.countryCode, @"country_code",
                                              self.postalCode,@"postal_code",
                                              self.line1,@"line1",
                                              self.line2,@"line2",
                                              self.line3,@"line3",
                                              self.state,@"state", nil];
    
    return mutableDictionary;
    
}

@end
