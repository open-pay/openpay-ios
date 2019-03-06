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

- Download the latest released version (https://github.com/open-pay/openpay-ios/releases/download/v2.0.0/SDK-v2.0.0.zip).
- Add openpay library (Openpay.a)
  - Go to General -> Linked Framework and Libraries
  - Click "Add items"
  - In the popup, click "Add Other..." option
  - Select the file "Openpay.a" and click "Open"
- Add webkit framework
  - Go to General -> Linked Framework and Libraries
  - Search for "WebKit.framework", select it and click "Add"

## Headers

#### Option A

- Copy all the .h files (Openpay.h, OPCard.h, OPAddress.h, OPToken.h) in the include folder of your project.

*The includes folder is automatically included in the project's header search path.*

*If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.*

#### Option B

- If the include folder does not exist, then you have to add the files to the project folder.
  - Right click on the project folder and select the option "Add files to ..."
  - In the popup, select the files (Openpay.h, OPCard.h, OPAddress.h, OPToken.h), check the option "Copy items if needed" and click "add"

## Usage

```objectivec
#import "Openpay.h"

#define MERCHANT_ID @"merchantId"
#define API_KEY @"apiKey"
```

#### Create a instance object

For create an instance Openpay needs:
- MerchantId
- Public API Key

```objectivec
@property (nonatomic) Openpay *openpay;

- (void)myFunction {
    _openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID apyKey:API_KEY isProductionMode:NO];
}
```

#### Production Mode

Use isProductionMode = YES

```objectivec
@property (nonatomic) Openpay *openpay;

- (void)myFunction {
    _openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID apyKey:API_KEY isProductionMode:YES];
}
```

#### Create a SessionID
The framework contains a function for generate a device sessionID.

```objectivec
@property (nonatomic) Openpay *openpay;
@property NSString *sessionId;

- (void)myFunction {
    _openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID apyKey:API_KEY isProductionMode:NO];
    _sessionId = [_openpay createDeviceSessionId];
}
```

#### Create a token

For more information about how to create a token, please refer to [Create a token] (http://www.openpay.mx/docs/api/#crear-un-nuevo-token) 

##### With only required fields

```objectivec
@property (nonatomic) Openpay *openpay;

- (void)myFunction {
    OPCard *card = [[OPCard alloc]init];
    card.holderName = @"Juan Escamilla";
    card.number = @"4111111111111111";
    card.expirationMonth = @"08";
    card.expirationYear = @"19";
    card.cvv2 = @"132";
    
    _openpay = [[Openpay alloc] initWithMerchantId:MERCHANT_ID apyKey:API_KEY isProductionMode:NO];
    [_openpay createTokenWithCard:card success:^(OPToken *token) {} failure:^(NSError *error) {}];
}
```
