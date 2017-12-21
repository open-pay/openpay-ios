//
//  OPCardTests.m
//  OpenPayIOSApp
//
//  Created by Heber Lazcano on 6/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//


#import "OPCard.h"
#import "OPCardTests.h"

@implementation OPCardTests

// Test card types

- (void)testVisaCardType {
    NSString *cardNumber = @"41111111111111111";
    OPCard *card = [[OPCard alloc] init];
    card.number = cardNumber;
    XCTAssertTrue(card.type==OPCardTypeVisa, @"Card type should be %@ but was %u", @"Visa", card.type);
}

- (void)testMastercardCardType {
    NSString *cardNumber = @"5105105105105100";
    OPCard *card = [[OPCard alloc] init];
    card.number = cardNumber;
    XCTAssertTrue(card.type==OPCardTypeMastercard, @"Card type should be %@ but was %u", @"Mastercard", card.type);
}

- (void)testAmericanExpressCardType {
    NSString *cardNumber = @"341111111111111";
    OPCard *card = [[OPCard alloc] init];
    card.number = cardNumber;
    XCTAssertTrue(card.type==OPCardTypeAmericanExpress, @"Card type should be %@ but was %u", @"American Express", card.type);
}

// Test card numbers

- (void)testValidCardNumbers {
    NSArray *cardNumbers = [[NSArray alloc] initWithObjects:
                            @"4111111111111111",
                            @"4444444444444448",
                            @"4222222222222220",
                            @"4532418643138442",
                            @"4716314539050650",
                            @"4485498805067453",
                            @"4929679978342120",
                            @"4400544701105053",
                            @"5105105105105100",
                            @"5549904348586207",
                            @"5151601696648220",
                            @"5421885505663975",
                            @"5377756349885534",
                            @"5346784314486086",
                            @"6011373997942482",
                            @"6011640053409402",
                            @"6011978682866778",
                            @"6011391946659189",
                            @"6011358300105877",
                            @"341111111111111",
                            @"340893849936650",
                            @"372036201733247",
                            @"378431622693837",
                            @"346313453954711",
                            @"341677236686203", nil];
    for (NSString *number in cardNumbers) {
        OPCard *card = [[OPCard alloc] init];
        card.number = number;
        XCTAssertTrue(card.numberValid, @"%@ should be a valid card number", number);
    }
}

// Test security code

- (void)testValidAmexSecurityCode {
    NSString *securityCode = @"1234";
    OPCard *card = [[OPCard alloc] init];
    card.number = @"341111111111111";
    card.cvv2 = securityCode;
    XCTAssertNotNil(card, @"Card should not be nil");
    XCTAssertTrue(card.securityCodeCheck == OPCardSecurityCodeCheckPassed, @"Security code check should pass");
}

- (void)testInvalidAmexSecurityCode {
    NSString *securityCode = @"123";
    OPCard *card = [[OPCard alloc] init];
    card.number = @"341111111111111";
    card.cvv2 = securityCode;
    XCTAssertEqual(card.securityCodeCheck, OPCardSecurityCodeCheckFailed, @"Security code check should pass");
}

- (void)testSecurityCode {
    NSString *securityCode = @"123";
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.cvv2 = securityCode;
    XCTAssertEqual(card.securityCodeCheck, OPCardSecurityCodeCheckPassed, @"Security code check should pass");
}

- (void)testInvalidSecurityCodeShort {
    NSString *securityCode = @"12";
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.cvv2 = securityCode;
    XCTAssertEqual(card.securityCodeCheck, OPCardSecurityCodeCheckFailed, @"Security code check should fail");
}

// Test expiration

- (void)testNonExpiredCard {
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.expirationMonth = @"08";
    card.expirationYear = @"25";
    XCTAssertFalse(card.expired, @"Card should not be expired");
}

- (void)testNonExpiredCardExpiresThisYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.expirationMonth = [NSString stringWithFormat: @"%d", components.month];
    card.expirationYear = [NSString stringWithFormat:@"%d", components.year];
    XCTAssertFalse(card.expired, @"Card should not be expired");
}

- (void)testExpiredCardExpiredMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.expirationMonth = [NSString stringWithFormat: @"%d", components.month - 1];
    card.expirationYear = [NSString stringWithFormat:@"%ld", (long)components.year];
    XCTAssertTrue(card.expired, @"Card should be expired");
}

- (void)testExpiredCardExpiredYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    OPCard *card = [[OPCard alloc] init];
    card.number = @"4111111111111111";
    card.expirationMonth = @"08";
    card.expirationYear = [NSString stringWithFormat:@"%d", components.year - 1];
    XCTAssertTrue(card.expired, @"Card should be expired");
}


@end
