![Openpay iOS](http://www.openpay.mx/img/github/ios.jpg)

iOS objective-c library for tokenizing credit/debit card and collect device information

Current version: v2.0.0

Looking for Swift Version? Checkout: (https://github.com/open-pay/openpay-swift-ios)

Please refer to the following documentation sections for field documentation:
* [Create a Token](http://www.openpay.mx/docs/api/#crear-un-nuevo-token)
* [Fraud Tool](http://www.openpay.mx/docs/fraud-tool.html)

## Requirements

- iOS SDK 9.3+
- ARC
- WebKit.framework

## Installation

- Download the latest released version (SDK-v2.0.0.zip).
- Add openpay library (openpay-v2.0.0.a) to your project and to Build Phases -> Link Binary With Libraries.
- Add webkit framework to Build Phases -> Link Binary With Libraries.

## Headers

- Copy all the .h files (Openpay.h, OPCard.h, OPAddress.h, OPToken.h) in the include folder of your project.

*The includes folder is automatically included in the project's header search path.*

*If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.*

## Usage

```objectivec
#import "Openpay.h"
```

#### Create a instance object

For create an instance Openpay needs:
- MerchantId
- Public API Key

```objectivec
Openpay *openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID 
                                                apyKey:API_KEY
                                      isProductionMode:NO];
```

#### Production Mode

Use isProductionMode = YES

```objectivec
Openpay *openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID 
                                                apyKey:API_KEY
                                      isProductionMode:YES];
```


#### Create a token

For more information about how to create a token, please refer to [Create a token] (http://www.openpay.mx/docs/api/#crear-un-nuevo-token) 

##### With only required fields

```objectivec
OPCard *card = [[OPCard alloc]init];
card.holderName = @"Juan Escamilla";
card.number = @"4111111111111111";
card.expirationMonth = @"08";
card.expirationYear = @"19";
card.cvv2 = @"132";

Openpay *openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID 
                                                apyKey:API_KEY
                                      isProductionMode:NO];
[openpay createTokenWithCard:card
                     success:^(OPToken *token) {
                               
                   } failure:^(NSError *error) {
   
}];
```

##### Response

If the request is correct, return an instance of OPToken.
