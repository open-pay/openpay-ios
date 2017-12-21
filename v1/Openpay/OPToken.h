//
//  OPToken.h
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPCard.h"

@interface OPToken : NSObject

@property NSString * id;

@property OPCard *card;

+(OPToken*) initWithDictionary: (NSMutableDictionary*) dictionary;


@end
