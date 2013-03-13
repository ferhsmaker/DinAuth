//
//  LMCustomTabBar.m
//  iMemento
//
//  Created by David Jorge on 06/09/11.
//  Copyright (c) 2011 iphonedroid. All rights reserved.
//

#import "LMCustomTabBarC.h"
#import "LMDebugHelpers.h"
#import "LMPromocionesViewController.h"
#import "LMAppDelegate.h"
#import "GoogleAnalyticsIMemento.h"

const int kScreenWidth = 1024;
const int kScreenHeight = 768;

const int kBtnTabBarWidth = 80;
const int kBtnTabBarHeight = 56;

//Tags de los botones del dashboard
const int kTagBtnDashboard = 100;
const int kTagBtnBuscador = 101;
const int kTagBtnHistorico = 102;
const int kTagBtnActualidadJuridica = 103;
const int kTagBtnTienda = 104;
const int kTagBtnAyuda = 105;
const int kTagBtnConfiguracion = 106;
const int kTagBtnPromocion = 107;

@interface LMCustomTabBarC(){
    UIView *_indexingIndicator;
    UILabel *_indicatorLabel;
}

@end

@implementation LMCustomTabBarC

@synthesize btnsTabBar = _btnsTabBar;
@synthesize indicatorLabel=_indicatorLabel;

-(void)startIndexingIndicator{
    _indexingIndicator.hidden=NO;
}
-(void)stopIndexingIndicator{
    _indexingIndicator.hidden=YES;
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];    
    NSString *eventoGoogle;
    switch (tagNum) {
        case kTagBtnDashboard:
            eventoGoogle = kGMM_TabDashboard;
            break;
        case kTagBtnBuscador:
            eventoGoogle = kGMM_TabBuscador;
            break;
        case kTagBtnHistorico:
            eventoGoogle = kGMM_TabHistorico;
            break;
        case kTagBtnActualidadJuridica:
            eventoGoogle = kGMM_TabActualidad;
            break;
        case kTagBtnTienda:
            eventoGoogle = kGMM_TabTienda;
            break;
        case kTagBtnAyuda:
            eventoGoogle = kGMM_TabAyuda;
            break;
        case kTagBtnConfiguracion:
            eventoGoogle = kGMM_TabConfiguracion;
            break;
        case kTagBtnPromocion:
            eventoGoogle = kGMM_TabPublicidad;
            break;
        default:
            eventoGoogle = nil;
            break;
    }
    [GoogleAnalyticsIMemento trackPageView:eventoGoogle];
    
    self.selectedIndex = tagNum - kTagBtnDashboard;
    
    //Deseleccionamos todos los botones
    if (tagNum!=kTagBtnPromocion) {
        [LMAppDelegate goToRootViewControllerOf:tagNum];
    }
    for (UIButton *btn in self.btnsTabBar) {
        btn.selected = NO;
        if(btn.tag != kTagBtnPromocion)
            btn.alpha = 0.3;
    }
    if(tagNum ==kTagBtnPromocion){
        LMPromocionesViewController *promoVC=[[LMPromocionesViewController alloc] initWithNibName:@"LMPromocionesViewController" bundle:nil];
        promoVC.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self presentModalViewController:promoVC animated:YES];
    }else{
        //Seleccionamos el clickado
        [[self.btnsTabBar objectAtIndex:self.selectedIndex] setSelected:YES];
        [[self.btnsTabBar objectAtIndex:self.selectedIndex] setAlpha:1.0];
    }
}


+ (CGFloat)xPosForButtonInPos:(NSInteger)pos
{
    //Los botones van de 80 en 80 pero en el botón de tienda da un salto
    CGFloat posX = 80*pos;
    if (pos > 3) //A partir del tercer botón hay que dar el salto
        posX+=384;
    return posX;
}

-(void)addCustomElements
{    
    if (self.btnsTabBar != nil) {
        return;
    }
 
    //Vista contenedora
    CGRect tabBarFrame;
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if([[digits objectAtIndex:0] intValue]>= 5){
        tabBarFrame = CGRectMake(0, kScreenHeight - kBtnTabBarHeight, kScreenWidth, kScreenHeight);
    }else{
        tabBarFrame = CGRectMake(0, 1024 - kBtnTabBarHeight, kScreenWidth, kScreenHeight);
    }
    UIView *myTabBar = [[UIView alloc] initWithFrame:tabBarFrame];
    [myTabBar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    
    //Fondo    
	UIImageView *tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_Bg_Hor.png"]];
	[myTabBar addSubview:tabBarBg];    

    //Creación de los botones
    NSString *icoFilenames = @"tabBar_Dashboard_Ico.png;tabBar_Buscador_Ico.png;tabBar_Historico_Ico.png;tabBar_ActualidadJuridica_Ico.png;tabBar_Tienda_Ico.png;tabBar_Ayuda_Ico.png;tabBar_Configuracion_Ico.png;tabBar_Promocion_Ico.png";
    NSArray *btnImagesFilenames = [icoFilenames componentsSeparatedByString:@";"];
    NSArray *btnTags = [NSArray arrayWithObjects:[NSNumber numberWithInt:kTagBtnDashboard],[NSNumber numberWithInt:kTagBtnBuscador],[NSNumber numberWithInt:kTagBtnHistorico],[NSNumber numberWithInt:kTagBtnActualidadJuridica],[NSNumber numberWithInt:kTagBtnTienda],[NSNumber numberWithInt:kTagBtnAyuda],[NSNumber numberWithInt:kTagBtnConfiguracion],[NSNumber numberWithInt:kTagBtnPromocion], nil];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:[btnTags count]];
    
    NSInteger pos = 0;
    for (NSNumber *btnTag in btnTags) {
        UIButton *btnTabBar = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgTabBar = [UIImage imageNamed:[btnImagesFilenames objectAtIndex:pos]];
        [btnTabBar setImage:imgTabBar forState:UIControlStateNormal];
        btnTabBar.tag = [[btnTags objectAtIndex:pos] intValue];
        if(btnTabBar.tag != kTagBtnPromocion)
            btnTabBar.alpha = 0.3;
        [btnTabBar addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];        
        NSInteger btnPosX = [LMCustomTabBarC xPosForButtonInPos:pos];
        btnTabBar.frame = CGRectMake(btnPosX, 0, kBtnTabBarWidth, kBtnTabBarHeight);
        [myTabBar addSubview:btnTabBar];
        [buttons addObject:btnTabBar];
        pos++;
    }
    
    _indexingIndicator=[[UIView alloc] initWithFrame:CGRectMake([LMCustomTabBarC xPosForButtonInPos:4]-100, 0, 100, myTabBar.bounds.size.height)];
    _indexingIndicator.backgroundColor=[UIColor clearColor];
    if(!_indexing)
        _indexingIndicator.hidden=YES;
    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.center=CGPointMake(50, (activity.frame.size.height/2)+5);
    [activity startAnimating];
    [_indexingIndicator addSubview:activity];
    _indicatorLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, activity.frame.size.height+activity.frame.origin.y, _indexingIndicator.bounds.size.width, kBtnTabBarHeight-(activity.frame.size.height+activity.frame.origin.y))];
    _indicatorLabel.text=@"indexando...";
    _indicatorLabel.backgroundColor=[UIColor clearColor];
    _indicatorLabel.textColor=[UIColor lightTextColor];
    _indicatorLabel.textAlignment=UITextAlignmentCenter;
    _indicatorLabel.font=[UIFont systemFontOfSize:15];
    [_indexingIndicator addSubview:_indicatorLabel];
    [myTabBar addSubview:_indexingIndicator];
    
    [self.view addSubview:myTabBar];
    self.btnsTabBar = buttons;

    //El primer botón seleccionado
    [[self.btnsTabBar objectAtIndex:0] setAlpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addCustomElements];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self addCustomElements];    
}

@end