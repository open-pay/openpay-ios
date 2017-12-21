//
//  OPCard.h
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPAddress.h"

typedef NS_ENUM(NSUInteger, OPCardType)
{
    OPCardTypeUnknown,
    OPCardTypeVisa,
    OPCardTypeMastercard,
    OPCardTypeAmericanExpress
};

typedef NS_ENUM(NSUInteger, OPCardSecurityCodeCheck)
{
    OPCardSecurityCodeCheckUnknown,
    OPCardSecurityCodeCheckPassed,
    OPCardSecurityCodeCheckFailed
};

@interface OPCard : NSObject

@property NSDate *creationDate;

@property NSString *id;

@property NSString *bankName;

@property BOOL allowPayouts;

@property NSString *holderName;

@property NSString *expirationMonth;

@property NSString *expirationYear;

@property OPAddress *address;

@property NSString *number;

@property NSString *brand;

@property BOOL allowsCharges;

@property NSString *bankCode;

@property NSString *cvv2;

@property (nonatomic, assign, readonly, getter=getType) OPCardType type;
@property (nonatomic, assign, readonly, getter=getValid) BOOL valid;
@property (nonatomic, assign, readonly, getter=getNumberValid) BOOL numberValid;
@property (nonatomic, assign, readonly, getter=getExpired) BOOL expired;
@property (nonatomic, assign, readonly, getter=getSecurityCodeCheck) OPCardSecurityCodeCheck securityCodeCheck;
@property (nonatomic, strong) NSMutableArray *errors;

- (NSMutableDictionary*) asMutableDictionary;

+ (OPCard*) initWithDictionary: (NSMutableDictionary*) dictionary;

@end
