//
//  ViewController.h
//  OpenpayExample
//
//  Created by Heber Lazcano on 6/23/14.
//  Copyright (c) 2014 Openpay S.A.P.I. de C.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtCVV2;
@property (weak, nonatomic) IBOutlet UITextField *txtExpMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtExpYear;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (weak, nonatomic) IBOutlet UITextView *txtResponseView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction) btnClick:(id)sender;

- (IBAction) btnReset:(id)sender;

@end
