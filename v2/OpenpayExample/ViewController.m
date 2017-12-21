//
//  ViewController.m
//  OpenpayExample
//
//  Created by Heber Lazcano on 6/23/14.
//  Copyright (c) 2014 Openpay S.A.P.I. de C.V. All rights reserved.
//

#import "ViewController.h"
#import "Openpay.h"

#define MERCHANT_ID @"mi93pk0cjumoraf08tqt"
#define API_KEY @"pk_92e31f7c77424179b7cd451d21fbb771"

@interface ViewController ()

@property (nonatomic) Openpay *openpayAPI;
@property NSString *sessionId;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _openpayAPI = [[Openpay alloc] initWithMerchantId:MERCHANT_ID apyKey:API_KEY isProductionMode:NO isDebug: YES];
    _sessionId= [_openpayAPI createDeviceSessionId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitCardInfo {
    
    OPCard *card = [[OPCard alloc]init];
    card.holderName = [self.txtName text];
    card.number = [self.txtNumber text];
    card.expirationMonth = [self.txtExpMonth text];
    card.expirationYear = [self.txtExpYear text];
    card.cvv2 = [self.txtCVV2 text];
    

    [_openpayAPI createTokenWithCard:card
        success:^(OPToken *token) {
            [self setActivityIndicatorEnabled:NO];
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                      token.id, @"id",
                                                      _sessionId, @"device_session_id",
                                                      [token.card asMutableDictionary], @"card", nil];
            [self.txtResponseView setTextColor:[UIColor blueColor]];
            [self.txtResponseView setText:[mutableDictionary description]];
        } failure:^(NSError *error) {
            [self setActivityIndicatorEnabled:NO];

            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%ld", (long)[error code]], @"code",
                                                      [error userInfo], @"info", nil];
            [self.txtResponseView setTextColor:[UIColor redColor]];
            [self.txtResponseView setText:[mutableDictionary description]];
    }];
}


- (IBAction) btnClick:(id)sender
{
    [self.view endEditing:YES];
    [self setActivityIndicatorEnabled:YES];
    [self submitCardInfo];
}

- (IBAction) btnReset:(id)sender {
    [self setActivityIndicatorEnabled:NO];
    [self resetForm];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)resetForm {
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField*)view setText:@""];
        }
    }
    [self.txtResponseView setText:@""];
}

- (void)setActivityIndicatorEnabled:(BOOL)enabled {
    if (enabled) {
        [self.btnAction setHidden:YES];
        [self.btnReset setHidden:YES];
        [self.loadingIndicator startAnimating];
        [self.loadingIndicator setHidden:NO];
    }
    else {
        [self.btnAction setHidden:NO];
        [self.btnReset setHidden:NO];
        [self.loadingIndicator startAnimating];
        [self.loadingIndicator setHidden:NO];
    }
}

@end
