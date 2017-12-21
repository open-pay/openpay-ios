//
//  OPAdress.h
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPAddress : NSObject

/** Postal code. Required. */
@property NSString * postalCode;

/** First line of address. Required. */
@property NSString * line1;

/** Second line of address. Optional. */
@property NSString * line2;

/** Third line of address. Optional. */
@property NSString * line3;

/** City. Required. */
@property NSString * city;

/** State. Required. */
@property NSString * state;

/** Two-letter ISO 3166-1 country code. Optional. */
@property NSString * countryCode;


- (NSMutableDictionary*) asMutableDictionary;

+(OPAddress*) initWithDictionary: (NSMutableDictionary*) dictionary;


@end
