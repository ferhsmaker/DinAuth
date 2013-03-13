//
//  DNTConfigViewController.h
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum _DNTTimeSilence {
    DNTTimeSilenceOff = 0,
    DNTTimeSilence2hours,
    DNTTimeSilence8hours,
    DNTTimeSilence1day,
    DNTTimeSilence1week
}DNTTimeSilence;

@interface DNTConfigViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>{
    NSUserDefaults *defaults;
    NSArray *arrayClavesCeldas;
    UISwitch *switchActivation;
}

@property (nonatomic, strong) IBOutlet UITableView *tableViewConfig;
- (IBAction)btnBorrarHistorialPressed:(id)sender;
- (IBAction)valueChangedActivateApp:(id)sender;
@end
