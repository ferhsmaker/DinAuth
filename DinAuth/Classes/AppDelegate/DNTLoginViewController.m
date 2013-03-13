//
//  DNTLoginViewController.m
//  DinAuth
//
//  Created by Fernando on 14/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTLoginViewController.h"
#import "DNTAppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "DNTWSManager.h"

@interface DNTLoginViewController ()

@end

@implementation DNTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEntrarPressed:(id)sender{
    
    //if([DNTWSManager loginWithUser:self.txtUsr.text andPassword:self.txtPwd.text]){
    if([self.txtUsr.text isEqualToString:@"root"] && [self.txtPwd.text isEqualToString:@"root"]){
        [self cargarAlertaClaveConUsuario:self.txtUsr.text yPassword:self.txtPwd.text];
    }else{
        UIAlertView *alertLoginFailed = [[UIAlertView alloc]initWithTitle:@"Error al autentificarse" message:@"Revise sus datos" delegate:nil cancelButtonTitle:@"Volver a intentarlo" otherButtonTitles: nil];
        [alertLoginFailed show];
    }
}

- (void)cargarAlertaClaveConUsuario:(NSString*)usuario yPassword:(NSString *)password{
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Introduzca su clave" message:@"Esta clave es personal y se le pedirá en cada autorización" delegate:nil cancelButtonTitle:@"Registrarse" otherButtonTitles: nil];
    [alerta setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alerta showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"%@",[[alerta textFieldAtIndex:0] text]);
        if([[[alerta textFieldAtIndex:0] text] isEqualToString:@""]){
            [self cargarAlertaClaveConUsuario:usuario yPassword:password];
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:usuario forKey:kUserLogin];
            [defaults setObject:password forKey:kUserPass];
            [defaults setObject:[[alerta textFieldAtIndex:0] text] forKey:kClave];
            [defaults synchronize];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarController"] animated:YES];
            // Let the device know we want to receive push notifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField == self.txtUsr){
        [self.txtPwd becomeFirstResponder];
    }else if(textField == self.txtPwd){
        [self btnEntrarPressed:nil];
    }
    return NO;
}
@end
