//
//  DNTLoginViewController.h
//  DinAuth
//
//  Created by Fernando on 14/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNTLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtUsr;
@property (nonatomic, strong) IBOutlet UITextField *txtPwd;

- (IBAction)btnEntrarPressed:(id)sender;
@end
