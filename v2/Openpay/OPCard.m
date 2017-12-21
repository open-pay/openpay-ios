//
//  OPCard.m
//  OpenPayIOSApp
//
//  Created by Francisco Vieyra on 5/18/14.
//  Copyright (c) 2014 OpenPay. All rights reserved.
//

#import "OPCard.h"

@implementation OPCard
@synthesize errors;

-(id) init {
    self = [super init];
    if (self) {
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (OPCard*) initWithDictionary: (NSMutableDictionary*) tokenDictionary {
    if (tokenDictionary == nil || tokenDictionary == NULL || [tokenDictionary class] == [NSNull class]) {
        return nil;
    }
    NSDictionary* cardDictionary = [tokenDictionary objectForKey:@"card"];
    if (cardDictionary == nil || cardDictionary == NULL || [cardDictionary class] == [NSNull class]) {
        return nil;
    }
    
    OPCard *card = [[OPCard alloc] init];
    card.number = [cardDictionary objectForKey:@"card_number"];
    card.holderName = [cardDictionary objectForKey:@"holder_name"];
    card.expirationYear = [cardDictionary objectForKey:@"expiration_year"];
    card.expirationMonth = [cardDictionary objectForKey:@"expiration_month"];
    card.cvv2 = [cardDictionary objectForKey:@"cvv2"];
    
    card.address = [OPAddress initWithDictionary:[cardDictionary objectForKey:@"address"]];
    
    return card;
}

- (NSMutableDictionary*) asMutableDictionary {
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              self.number, @"card_number",
                                              self.holderName, @"holder_name",
                                              self.expirationYear, @"expiration_year",
                                              self.expirationMonth,@"expiration_month",
                                              self.cvv2, @"cvv2",
                                              [self.address asMutableDictionary], @"address",nil];
    
    
    
    return mutableDictionary;
}

- (BOOL)getExpired {
    if (self.expirationMonth.intValue > 12 || self.expirationMonth.intValue < 1) { return true; }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentMonth = [components month];
    NSInteger currentYear = [components year];
    
    int year = self.expirationYear.intValue;
    if ([self.expirationYear length] <= 2) {
        year += 2000;
    }
    
    if (year < currentYear) { return true; }
    
    return (year == currentYear && self.expirationMonth.intValue < currentMonth);
}

- (OPCardType)getType
{
    int digits = [[self.number substringWithRange:NSMakeRange(0, 2)] intValue];
    
    if (digits >= 40 && digits <= 49) {
        return OPCardTypeVisa;
    } else if (digits >= 50 && digits <= 59) {
        return OPCardTypeMastercard;
    } else if (digits == 34 || digits == 37) {
        return OPCardTypeAmericanExpress;
    } else {
        return OPCardTypeUnknown;
    }
}


- (BOOL)getNumberValid {
    if (self.number == nil) { return false; }
    if ([self.number length] < 12) { return false; }
    
    BOOL odd = true;
    int total = 0;
    
    for (int i = (int)self.number.length - 1; i >= 0; i--) {
        int value = [[self.number substringWithRange:NSMakeRange(i, 1)] intValue];
        total += (odd = !odd) ? 2 * value - (value > 4 ? 9 : 0) : value;
    }
    
    return (total % 10) == 0;
}

- (BOOL)getValid {
    BOOL valid = true;
    
    if (!self.numberValid) {
        [errors addObject:@"Card number is not valid"];
        valid = false;
    }
    
    if (self.expired) {
        [errors addObject:@"Card expired is not valid"];
        valid = false;
    }
    
    return valid;
}

- (OPCardSecurityCodeCheck)getSecurityCodeCheck {
    if (self.type == OPCardTypeUnknown) { return OPCardSecurityCodeCheckUnknown; }
    if (self.cvv2 == nil) { return OPCardSecurityCodeCheckUnknown; }
    if (self.cvv2 != nil) {
        NSUInteger requiredLength = (self.type==OPCardTypeAmericanExpress) ? 4 : 3;
        if ([self.cvv2  length] == requiredLength) {
            return OPCardSecurityCodeCheckPassed;
        }
        else {
            return OPCardSecurityCodeCheckFailed;
        }
    }
    return OPCardSecurityCodeCheckUnknown;
}

@end
