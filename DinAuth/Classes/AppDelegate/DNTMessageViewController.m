//
//  DNTMessageViewController.m
//  DinAuth
//
//  Created by Fernando on 11/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTMessageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DNTMessageViewController ()

@end

@implementation DNTMessageViewController

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
    [self.vistaBordeada.layer setBorderWidth:7.0];
    [self.vistaBordeada.layer setBorderColor:[UIColor blackColor].CGColor];
    [[self.vistaBordeada layer] setMasksToBounds:YES];
    [[self.vistaBordeada layer] setCornerRadius:10.0];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setVistaBordeada:nil];
    [self setImgCheck:nil];
    [super viewDidUnload];
}
@end
