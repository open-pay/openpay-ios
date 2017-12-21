//
//  Openpay.h
//  Openpay
//
//  Created by Heber Lazcano on 6/23/14.
//  Copyright (c) 2014 Openpay S.A.P.I. de C.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "OPCard.h"
#import "OPToken.h"

#define API_URL_SANDBOX @"https://sandbox-api.openpay.mx"
#define API_URL_PRODUCTION @"https://api.openpay.mx"
#define API_VERSION @"1.1"

typedef void (^OpenpayTokenizeResponseBlock)(OPToken *responseParams);
typedef void (^OpenpayErrorBlock)(NSError *error);

@interface Openpay : NSObject <NSURLConnectionDelegate>

@property NSString* merchantId;
@property NSString* apiKey;
@property BOOL isProductionMode;
@property(strong,nonatomic) WKWebView *webViewDF;

- (Openpay*) initWithMerchantId: (NSString*) merchantId
                         apyKey:(NSString*) apiKey
               isProductionMode:(BOOL) isProductionMode;

- (Openpay*) initWithMerchantId: (NSString*) merchantId
                         apyKey:(NSString*) apiKey
               isProductionMode:(BOOL) isProductionMode
                        isDebug:(BOOL) isDebug;

- (void)createTokenWithCard:(OPCard *)card
                    success:(OpenpayTokenizeResponseBlock)successBlock
                    failure:(OpenpayErrorBlock)failureBlock;

- (void) getTokenWithId: (NSString*) tokenId
                success:(OpenpayTokenizeResponseBlock)successBlock
                failure:(OpenpayErrorBlock)failureBlock;

- (NSString*)createDeviceSessionId;

@end
