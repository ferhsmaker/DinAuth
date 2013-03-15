//
//  DNTAppDelegate.m
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTAppDelegate.h"
#import "UAirship.h"
#import "UAPush.h"
#import "UIAlertView+Blocks.h"
#import "DNTWSManager.h"

@implementation DNTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DNTAppDelegate checkAndCreateDatabase];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *mainViewController;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [defaults objectForKey:kUserPass]);
    if([defaults objectForKey:kUserLogin] && ![[defaults objectForKey:kUserLogin] isEqualToString:@""]
       && [defaults objectForKey:kUserPass] && ![[defaults objectForKey:kUserPass] isEqualToString:@""]){
        mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootTabBarController"];
        // Let the device know we want to receive push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }else{
        mainViewController = [storyboard instantiateInitialViewController];
    }
    [[[DNTWSManager alloc]init] llamadaSoap];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

+ (void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	// Check if the database has already been created in the users filesystem
    NSString *databasePath = [[arrayDocuments objectAtIndex:0] stringByAppendingPathComponent:databaseName];
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already existdatabasePathn without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Nombre de usuario:       %@", [defaults objectForKey:kUserLogin]);
    NSLog(@"Contraseña de usuario:   %@", [defaults objectForKey:kUserPass]);
    NSLog(@"clave de usuario:        %@", [defaults objectForKey:kClave]);
    NSLog(@"Mi device token:         %@", deviceToken);
    if(![defaults objectForKey:kClave]){
        [self cargarAlertaClave];
    }
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Notificaciones desactivadas" message:@"Tiene las notificaciones desactivadas, no se le avisará de sus autorizaciones, para activarlas: Ajustes>Notificaciones>DinAuth>Centro de notificaciones" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
    }
    
}

- (void)cargarAlertaClave{
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Introduzca su clave" message:@"Esta clave es personal y se le pedirá en cada autorización" delegate:nil cancelButtonTitle:@"Registrarse" otherButtonTitles: nil];
    [alerta setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alerta showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"%@",[[alerta textFieldAtIndex:0] text]);
        if([[[alerta textFieldAtIndex:0] text] isEqualToString:@""]){
            [self cargarAlertaClave];
        }else if([[[alerta textFieldAtIndex:0] text] length]>=4 && [[[alerta textFieldAtIndex:0] text] length]<=6){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[alerta textFieldAtIndex:0] text] forKey:kClave];
            [defaults synchronize];
            //TODO: Enviar al webservice el usuario, contraseña, clave y token
        }else{
            UIAlertView *alerta2 = [[UIAlertView alloc]initWithTitle:@"Código erróneo" message:@"La clave debe tener entre 4 y 6 carácteres" delegate:nil cancelButtonTitle:@"Reintentar" otherButtonTitles: nil];
            [alerta2 showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self cargarAlertaClave];
            }];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //TODO: Analizaremos la notificación, refrescaremos la pantalla de autorizaciones pendientes, buscaremos el id de la autorización en la lista y haremos un pushViewController para mostrarla en pantalla
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end