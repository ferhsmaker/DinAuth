//
//  DNTCambiarViewController.m
//  DinAuth
//
//  Created by Fernando on 07/03/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTCambiarViewController.h"
#import "DNTAppDelegate.h"
#import "UIAlertView+Blocks.h"

@interface DNTCambiarViewController ()

@end

@implementation DNTCambiarViewController

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

- (void)viewDidUnload {
    [self setTxtClaveActual:nil];
    [self setTxtClaveNueva:nil];
    [super viewDidUnload];
}
- (IBAction)btnCambiarClavePressed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mensaje;
    NSString *titulo = @"Error al cambiar la clave";
    BOOL manejarAlerta = NO;
    if(self.txtClaveActual.text.length > 0 && self.txtClaveNueva.text.length > 0){
        if([self.txtClaveActual.text isEqualToString:[defaults objectForKey:kClave]]){
            if(self.txtClaveNueva.text.length >= 4 && self.txtClaveNueva.text.length <=6){
                [defaults setObject:self.txtClaveNueva.text forKey:kClave];
                [defaults synchronize];
                mensaje = @"Clave cambiada con éxito";
                titulo = @"Hecho!";
                manejarAlerta = YES;
            }else{
                mensaje = @"La nueva clave debe tener entre 4 y 6 carácteres";
            }
        }else{
            mensaje = @"La clave actual no es correcta";
        }
    }else{
        mensaje = @"Introduzca su clave actual y su nueva clave";
    }
    if (mensaje) {
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:titulo message:mensaje delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        if(manejarAlerta){
            [alerta showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [alerta show];
        }
        
    }
}
@end
