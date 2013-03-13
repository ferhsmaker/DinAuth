//
//  DNTCambiarViewController.h
//  DinAuth
//
//  Created by Fernando on 07/03/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNTCambiarViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtClaveActual;
@property (strong, nonatomic) IBOutlet UITextField *txtClaveNueva;
- (IBAction)btnCambiarClavePressed;
@end
