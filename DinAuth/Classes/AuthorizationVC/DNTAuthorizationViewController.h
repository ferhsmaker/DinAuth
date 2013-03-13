//
//  DNTAuthorizationViewController.h
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTAutorizacion.h"

@interface DNTAuthorizationViewController : UIViewController{
    DNTAutorizacion *_autorizacion;
}

@property (strong, nonatomic) DNTAutorizacion *autorizacion;
@property (strong, nonatomic) IBOutlet UITextView *textAuth;
@property (nonatomic, strong) IBOutlet UIButton *btnAutorizar;
@property (nonatomic, strong) IBOutlet UIButton *btnDenegar;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblEmisor;

- (IBAction)btnAutorizarPressed:(id)sender;
- (IBAction)btnDenegarPressed:(id)sender;
@end
