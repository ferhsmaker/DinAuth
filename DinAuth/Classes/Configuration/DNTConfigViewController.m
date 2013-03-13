//
//  DNTConfigViewController.m
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTConfigViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DNTAppDelegate.h"
#import "DNTSqliteManager.h"
#import "UIAlertView+Blocks.h"
#import "DNTWSManager.h"

@interface DNTConfigViewController ()

@end

@implementation DNTConfigViewController

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
    defaults = [NSUserDefaults standardUserDefaults];
    arrayClavesCeldas = [NSArray arrayWithObjects:@"cellClave",@"cellActivar",@"cellHistorial",nil];//@"cellFirma", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideOrShow:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideOrShow:) name:UIKeyboardWillShowNotification object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayClavesCeldas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[arrayClavesCeldas objectAtIndex:[indexPath row]]];
    if([[cell reuseIdentifier]isEqualToString:@"cellActivar"]){
        switchActivation = (UISwitch *)[cell viewWithTag:101];
        [switchActivation setOn:NO];
    }else if([[cell reuseIdentifier]isEqualToString:@"cellHistorial"]){
        for (UIView *subView in [cell subviews]) {
            for (UIView *buttons in [subView subviews]) {
                if([buttons isKindOfClass:[UIButton class]]){
                    
                    break;
                }
            }
        }
    }else if([[cell reuseIdentifier]isEqualToString:@"cellFirma"]){
        for (UIView *subView in [cell subviews]) {
            for (UIView *textViews in [subView subviews]) {
                if([textViews isKindOfClass:[UITextView class]]){
                    if([defaults objectForKey:kFirma]){
                        [(UITextView *)textViews setTextColor:[UIColor blackColor]];
                        [(UITextView *)textViews setText:[defaults objectForKey:kFirma]];
                        break;
                    }
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[arrayClavesCeldas objectAtIndex:[indexPath row]]];
    return cell.frame.size.height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:kFirma]){
        textView.text = @"";
        [textView setTextColor:[UIColor blackColor]];
        range = NSMakeRange(0, 0);
    }
    [defaults setObject:[textView.text stringByReplacingCharactersInRange:range withString:text] forKey:kFirma];
    [defaults synchronize];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:textField.text forKey:kClave];
    [defaults synchronize];
    return YES;
}

- (void)keyboardWillHideOrShow:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if([note.name isEqual:UIKeyboardWillHideNotification]){
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
            [self.tableViewConfig setFrame:CGRectMake(0, 50, 320, 367)];
        } completion:nil];
        
    }else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
            [self.tableViewConfig setFrame:CGRectMake(0, 44, 320, 464-keyboardFrame.origin.y)];
        } completion:nil];
    }
}


- (IBAction)btnBorrarHistorialPressed:(id)sender {
    
    UIAlertView *alertaBorrarHistorial = [[UIAlertView alloc]initWithTitle:@"¿Está seguro?" message:@"Va a borrar el historial de autorizaciones, esta acción no tiene vuelta a atrás" delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Borrar", nil];
    
    [alertaBorrarHistorial showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 1){
            DNTSqliteManager *sqLite = [[DNTSqliteManager alloc]init];
            NSArray *arrayDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            // Check if the database has already been created in the users filesystem
            NSString *databasePath = [[arrayDocuments objectAtIndex:0] stringByAppendingPathComponent:databaseName];
            [sqLite openDbAtPath:databasePath];
            [sqLite borrarHistoricos];
            [sqLite closeDb];
        }
    }];
}

- (IBAction)valueChangedActivateApp:(id)sender{
    //TODO: La primera opción será activar o no la aplicación que podrá ser temporal o fija
    if(![switchActivation isOn]){
        //TODO: Llamar al webservice indicándole que ya puede enviar notificaciones
    }else{
        UIActionSheet *actionSheetTimeDesactivation = [[UIActionSheet alloc]initWithTitle:@"Desactivar" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"2 horas",@"8 horas",@"1 día",@"1 semana", nil];
        [actionSheetTimeDesactivation showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //TODO: Llamar al webservice indicándole el tiempo en el que no debe enviar notificaciones
    NSLog(@"actionSheet button %d",buttonIndex);
    DNTTimeSilence silenceTime;
    
    switch (buttonIndex) {
        case 0:
            silenceTime = DNTTimeSilence2hours;
            NSLog(@"2 horas desactivado");
            break;
        case 1:
            silenceTime = DNTTimeSilence8hours;
            NSLog(@"8 horas desactivado");
            break;
        case 2:
            silenceTime = DNTTimeSilence1day;
            NSLog(@"1 día desactivado");
            break;
        case 3:
            silenceTime = DNTTimeSilence1week;
            NSLog(@"1 semana desactivado");
            break;
        case 4:
            silenceTime = DNTTimeSilenceOff;
            NSLog(@"Cancelar");
            [switchActivation setOn:NO];
            break;
        default:
            silenceTime = DNTTimeSilenceOff;
            NSLog(@"Cancelar");
            [switchActivation setOn:NO];
            break;
    }
    [DNTWSManager deactivatePushNotifications:silenceTime];
}
@end
