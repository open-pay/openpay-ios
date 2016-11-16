![Openpay iOS](http://www.openpay.mx/img/github/ios.jpg)

iOS library for tokenizing credit/debit card and collect device information

Current version : 1.0

Looking for Swift Version? Checkout: (https://github.com/open-pay/openpay-swift-ios)

Please refer to the following documentation sections for field documentation:
* [Create a Token](http://www.openpay.mx/docs/api/#crear-un-nuevo-token)
* [Fraud Tool](http://www.openpay.mx/docs/fraud-tool.html)

## Requirements

- ARC
- CoreLocation.framework

## Installation

- [Download the pre-built library](https://github.com/open-pay/openpay-ios/releases).
- Add openpay.a to your project and to Build Phases -> Link Binary With Libraries.
- Add CoreLocation.framework to Build Phases -> Link Binary With Libraries.

### Modify the Info.plist
Include the NSLocationWhenInUseUsageDescription key. This string value for this key can currently be empty, but Apple may require a description of why the location is needed in the future.

#### Headers

##### includes folder
The includes folder is automatically included in the project's header search path.

- Copy the include folder to your project (or include/*.h to your existing include folder). Drag the folder to your project to add the references.

If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.

##### Direct copy
You can copy the headers directly into your project and add them as direct references.
- Drag the contents of 'include' folder to your project (select copy if needed)

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


## Contributing


#### Tests

Please include tests with all new code. Also, all existing tests must pass before new code can be merged.
