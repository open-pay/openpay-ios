//
//  Openpay.m
//  Openpay
//
//  Created by Heber Lazcano on 6/23/14.
//  Copyright (c) 2014 Openpay S.A.P.I. de C.V. All rights reserved.
//

#import "Openpay.h"

#define OP_MODULE_TOKENS @"tokens"

#define OP_HTTP_METHOD_POST @"POST"
#define OP_HTTP_METHOD_GET @"GET"

#define OPUnexpectedError NSLocalizedString(@"There was an unexpected error -- try again in a few seconds", @"Unexpected error, such as a 500 from Openpay or a JSON parse error")

FOUNDATION_EXPORT NSString *const OpenpayDomain;
FOUNDATION_EXPORT NSString *const OPErrorMessageKey;

NSString *const OpenpayDomain = @"com.openpay.ios.lib";
NSString *const OPErrorMessageKey = @"com.openpay.ios.lib:ErrorMessageKey";
NSInteger const OPAPIError = 9999;

@interface Openpay ()

@property NSURLConnection *connection;
@property NSMutableURLRequest *request;
@property NSOperationQueue *queue;
@property BOOL isDebug;

@end

@implementation Openpay

-(id) init {
    [NSException raise:@"InvalidConstructorError" format:@"Use 'initWithMerchantId' for create a instance of Openpay"];
    return nil;
}

-(Openpay*) initWithMerchantId: (NSString*) merchantId
                        apyKey: (NSString*) apiKey
              isProductionMode: (BOOL) isProductionMode {
    return [self initWithMerchantId:merchantId apyKey:apiKey isProductionMode:isProductionMode isDebug:NO];
}

-(Openpay*) initWithMerchantId: (NSString*) merchantId
                        apyKey: (NSString*) apiKey
              isProductionMode: (BOOL) isProductionMode
              isDebug:(BOOL)isDebug {
    self.queue = [[NSOperationQueue alloc] init];
    self.merchantId = merchantId;
    self.apiKey = apiKey;
    self.isProductionMode =isProductionMode;
    self.isDebug = isDebug;
    return self;
}

- (void) createTokenWithCard:(OPCard *)card
                     success:(OpenpayTokenizeResponseBlock)successBlock
                     failure:(OpenpayErrorBlock)failureBlock{
    if (card.valid) {
        [self sendFunction:OP_MODULE_TOKENS data:[card asMutableDictionary] httpMethod:OP_HTTP_METHOD_POST success:successBlock failure:failureBlock ];
    } else {
        failureBlock([NSError errorWithDomain:OpenpayDomain code:1001 userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:card.errors, @"errors", nil]]);
    }
}

- (void) getTokenWithId: (NSString*) tokenId
                success:(OpenpayTokenizeResponseBlock)successBlock
                failure:(OpenpayErrorBlock)failureBlock {
    [self sendFunction:[NSString stringWithFormat:@"%@/%@", OP_MODULE_TOKENS, tokenId] data:nil httpMethod:OP_HTTP_METHOD_GET success:successBlock failure:failureBlock];
}

- (NSString*) createDeviceSessionId {
    // Generamos sessionId
    NSString *sessionId;
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidStrRef = CFUUIDCreateString(nil, uuidRef);
    CFRelease(uuidRef);
    sessionId = [(__bridge NSString *)uuidStrRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStrRef);
    
    // Obtenemos identifierForVendor
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *identifierForVendor = [[currentDevice identifierForVendor] UUIDString];
    identifierForVendor = [identifierForVendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // Inicializamos WebView con el identifierForVendor
    _webViewDF = [[WKWebView alloc] init];
    NSString *identifierForVendorScript = [NSString stringWithFormat:@"var identifierForVendor = '%@';", identifierForVendor];
    [_webViewDF evaluateJavaScript:identifierForVendorScript completionHandler:nil];
    
    // Ejecutamos OpenControl
    NSString *urlAsString = [NSString stringWithFormat:@"%@/oa/logo.htm?m=%@&s=%@", (self.isProductionMode? API_URL_PRODUCTION: API_URL_SANDBOX), self.merchantId, sessionId];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webViewDF loadRequest:urlRequest];
    
    return sessionId;
}

- (void) sendFunction: (NSString*) method
                 data: (NSMutableDictionary*) data
           httpMethod:(NSString *)httpMethod
              success:(OpenpayTokenizeResponseBlock)successBlock
              failure:(OpenpayErrorBlock)failureBlock {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/%@/%@", (self.isProductionMode? API_URL_PRODUCTION: API_URL_SANDBOX), self.merchantId, method]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"application/json;revision=%@", API_VERSION],
                             @"Accept", @"application/json",
                             @"Content-Type", [NSString stringWithFormat:@"OpenPay-iOS/%@", OPENPAY_IOS_VERSION],
                             @"User-Agent", nil];
    
    [request setHTTPMethod: httpMethod];
    [request setAllHTTPHeaderFields:headers];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.apiKey, @""];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    [request setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    if (data) {
        NSError *error;
        NSData *payloadData = [NSJSONSerialization dataWithJSONObject:data
                                                              options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPBody:payloadData];
    }
    
    __block NSHTTPURLResponse *response;
    __block NSError *operationError;
    __block NSData *responseData;
    
    [self.queue addOperationWithBlock:^{
        if (_isDebug) {  NSLog(@"Sending request to %@", url); }
        responseData = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&operationError];
        if (operationError == nil) {
            NSMutableDictionary *jsonDictionary = [self dictionaryFromJSONData:responseData error:&operationError];
            if([response statusCode] >= 200 && [response statusCode] < 300) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (operationError == nil) {
                        if (_isDebug) {  NSLog(@"Ok! Valid response received"); }
                        successBlock([OPToken initWithDictionary:jsonDictionary]);
                    }
                    else {
                        failureBlock(operationError);
                    }
                }];
            } else {
                if (_isDebug) { NSLog(@"Response with http error %@", @([response statusCode]).stringValue); }
                NSString *errorCode = [jsonDictionary objectForKey:@"error_code"];
                operationError = [[NSError alloc] initWithDomain:OpenpayDomain
                                                            code: [errorCode intValue]
                                                        userInfo:jsonDictionary];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    failureBlock(operationError);
                }];
            }
        } else {
            if (_isDebug) {  NSLog(@"The request could not be completed to %@", url); }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                failureBlock(operationError);
            }];
        }
        
    }];
}

- (NSMutableDictionary *)dictionaryFromJSONData:(NSData *)data error:(NSError **)outError
{
    NSMutableDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonDictionary == nil) {
        NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey : OPUnexpectedError,
                                       OPErrorMessageKey : [NSString stringWithFormat:@"The response from Openpay failed to get parsed into valid JSON."]
                                       };
        if (outError) {
            *outError = [[NSError alloc] initWithDomain:OpenpayDomain
                                                   code:OPAPIError
                                               userInfo:userInfoDict];
        }
        return nil;
    }
    return jsonDictionary;
}

@end
