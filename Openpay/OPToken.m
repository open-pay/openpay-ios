//
//  OPToken.m
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import "OPToken.h"

@implementation OPToken

+(OPToken*) initWithDictionary: (NSMutableDictionary*) dictionary {
    if (dictionary == nil || dictionary == NULL || [dictionary class] == [NSNull class]) {
        return nil;
    }
    OPToken *token = [[OPToken alloc] init];
    token.id = [dictionary objectForKey:@"id"];
    token.card = [OPCard initWithDictionary:dictionary];
    return token;
}

@end
