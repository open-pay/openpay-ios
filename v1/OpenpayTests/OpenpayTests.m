//
//  OpenpayTests.m
//  OpenpayTests
//
//  Created by Heber Lazcano on 6/23/14.
//  Copyright (c) 2014 Openpay S.A.P.I. de C.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OpenpayTests.h"
#import "Openpay.h"
#import <XCTest/XCTest.h>

@implementation OpenpayTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateTokenWithCard
{
    
    Openpay* openPay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID
                                                    apyKey:API_KEY
                                          isProductionMode: NO];
    OPCard* card = [[OPCard alloc] init];
    
    card.number = @"4111111111111111";
    card.holderName = @"Juan Perez Ramirez";
    card.expirationYear = @"20";
    card.expirationMonth  = @"12";
    card.cvv2 = @"110";
    
    OPAddress* address = [[OPAddress alloc] init];
    address.city = @"Querétaro";
    address.countryCode = @"MX";
    address.postalCode = @"76900";
    address.line1 = @"Av 5 de Febrero";
    address.line2 = @"Roble 207";
    address.line3 = @"Col. Felipe";
    address.state = @"Querétaro";
    
    card.address = address;
    
    __block OPToken* token;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [openPay createTokenWithCard:card
                         success:^(OPToken *responseParams) {
                             token = responseParams;
                             dispatch_semaphore_signal(semaphore);
                         } failure:^(NSError *error) {
                             dispatch_semaphore_signal(semaphore);
                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    XCTAssertNotNil(token);
    XCTAssertNotNil([token id]);
    XCTAssertNotNil([token card]);
    XCTAssertNil([[token card] id]);
    XCTAssertNil([[token card] creationDate]);
    XCTAssertTrue([[[token card] number] isEqual:@"411111XXXXXX1111"]);
}

- (void)testCreateTokenWithBadCard
{
    Openpay* openPay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID
                                                    apyKey:API_KEY
                                          isProductionMode: NO];
    OPCard* card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.holderName = @"Juan Perez Ramirez";
    card.expirationYear = @"19";
    card.expirationMonth  = @"12";
    card.cvv2 = @"123";
    
    OPAddress* address = [[OPAddress alloc] init];
    address.city = @"Querétaro";
    
    card.address = address;
    
    __block NSError* requestError;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [openPay createTokenWithCard:card
                         success:^(OPToken *responseParams) {
                             dispatch_semaphore_signal(semaphore);
                         } failure:^(NSError *error) {
                             requestError = error;
                             dispatch_semaphore_signal(semaphore);
                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    XCTAssertNotNil(requestError);
    XCTAssertEqual([requestError code], 1001);
    XCTAssertNotNil([[requestError userInfo] objectForKey:@"error_code"]);
}

- (void)testGetCardWithToken
{
    
    Openpay* openPay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID
                                                    apyKey:API_KEY
                                          isProductionMode: NO];
    __block OPToken* token;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [openPay getTokenWithId: TOKEN_ID_TEST
                    success:^(OPToken *responseParams) {
                        token = responseParams;
                        dispatch_semaphore_signal(semaphore);
                    } failure:^(NSError *error) {
                        dispatch_semaphore_signal(semaphore);
                    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    XCTAssertNotNil(token);
    XCTAssertNotNil([token id]);
}

- (void)testGetDeviceSessionId
{
    Openpay *openPay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID
                                                    apyKey:API_KEY
                                          isProductionMode: NO];
    NSString *session = [openPay createDeviceSessionId];
    XCTAssertNotNil(session);
}

@end
