//
//  DNTSecondViewController.m
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTAuthorizationViewController.h"
#import "DNTMessageViewController.h"
#import "UIAlertView+Blocks.h"
#import "DNTAppDelegate.h"
#import "DNTSqliteManager.h"
#import "DNTWSManager.h"

@interface DNTAuthorizationViewController ()

@end

@implementation DNTAuthorizationViewController

@synthesize autorizacion = _autorizacion;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self textAuth]setText:_autorizacion.texto];
    [self setTitle:_autorizacion.titulo];
    [self.lblDate setText:_autorizacion.date];
    [self.lblEmisor setText:_autorizacion.emisor];
    if(_autorizacion.estadoAutorizacion != DNTEstadoAutorizacionPendiente){
        if(_autorizacion.estadoAutorizacion == DNTEstadoAutorizacionAutorizada){
            [self.btnAutorizar setEnabled:NO];
            [self.btnAutorizar setTitle:@"Autorizada" forState:UIControlStateNormal];
            [self.btnDenegar setHidden:YES];
        }else if (_autorizacion.estadoAutorizacion == DNTEstadoAutorizacionDenegada){
            [self.btnAutorizar setHidden:YES];
            [self.btnDenegar setEnabled:NO];
            [self.btnDenegar setTitle:@"Denegada" forState:UIControlStateNormal];
        }else{
            [self.btnAutorizar setHidden:YES];
            [self.btnDenegar setHidden:YES];
        }
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnAutorizarPressed:(id)sender{
    [self cargarAlertaClaveAutorizada:DNTEstadoAutorizacionAutorizada];
}

- (IBAction)btnDenegarPressed:(id)sender{
    [self cargarAlertaClaveAutorizada:DNTEstadoAutorizacionDenegada];
    
}
- (IBAction)btnPosponerPressed:(id)sender{
    [self cargarAlertaClaveAutorizada:DNTEstadoAutorizacionPospuesta];
}

- (void)cargarAlertaClaveAutorizada:(DNTEstadoAutorizacion)autorizada{
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Introduzca su clave" message:@"Esta clave es personal y se le pedirá en cada autorización" delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Autorizar",nil];
    [alerta setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alerta showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 1){
            if([[[alerta textFieldAtIndex:0] text] isEqualToString:@""]){
                [self cargarAlertaClaveAutorizada:autorizada];
            }else if([[[alerta textFieldAtIndex:0]text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kClave]]){
                
                if([DNTWSManager authorization:self.autorizacion responsedWithState:autorizada]){
                    DNTSqliteManager *sqLite = [[DNTSqliteManager alloc]init];
                    NSArray *arrayDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                    // Check if the database has already been created in the users filesystem
                    NSString *databasePath = [[arrayDocuments objectAtIndex:0] stringByAppendingPathComponent:databaseName];
                    [sqLite openDbAtPath:databasePath];
                    if([sqLite borrarAutorizacion:self.autorizacion] && [sqLite insertarAutorizacion:self.autorizacion enDB:DNTDBHistoricos conEstadoAutorizacion:autorizada]){
                        DNTMessageViewController *message = [[DNTMessageViewController alloc]initWithNibName:@"DNTMessageViewController" bundle:nil];
                        message.view.center = self.view.center;
                        [self.view addSubview:message.view];
                        [UIView animateWithDuration:1.0 animations:^{
                            [message.view setAlpha:0.0];
                        } completion:^(BOOL finished) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }];
                    }
                    [sqLite closeDb];
                }else{
                    UIAlertView *alertaFalloEnvio = [[UIAlertView alloc]initWithTitle:@"Fallo de envío" message:@"Ha ocurrido un error al enviar la respuestas a la autorización" delegate:nil cancelButtonTitle:@"Volver" otherButtonTitles: nil];
                    [alertaFalloEnvio show];
                }
            }else{
                [self cargarAlertaClaveAutorizada:autorizada];
            }
        }
    }];
}

- (void)viewDidUnload {
    [self setTextAuth:nil];
    [super viewDidUnload];
}
@end
