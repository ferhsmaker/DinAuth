//
//  DNTCurrentViewController.m
//  DinAuth
//
//  Created by Fernando on 25/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTCurrentViewController.h"
#import "DNTAuthorizationViewController.h"
#import "DNTCellHistory.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "DNTAutorizacion.h"
#import "DNTSqliteManager.h"
#import "DNTAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DNTWSManager.h"


@interface DNTCurrentViewController ()
- (void)dataDidRefresh:(NSArray *)data;
- (void)dataDidLoadMore:(NSArray *)data;
@end

@implementation DNTCurrentViewController
@synthesize arrayCurrent = _arrayCurrent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DNTCurrentViewController *me = self;
    [_table setPullToRefreshHandler:^{
        
        /**
         Note: Here you should deal perform a webservice request, CoreData query or
         whatever instead of this dummy code ;-)
         */
        
        [me performSelector:@selector(dataDidRefresh:) withObject:me.arrayCurrent afterDelay:1.0];
    }];
    
    // Set the pull to laod more handler block
    [_table setPullToLoadMoreHandler:^{
        
        /**
         Note: Here you should deal perform a webservice request, CoreData query or
         whatever instead of this dummy code ;-)
         */
        [me performSelector:@selector(dataDidLoadMore:) withObject:me.arrayCurrent afterDelay:1.0];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cargarDatosDB];
    [_table reloadData];
}

- (void)cargarDatosDB{
    
    _arrayCurrent = [DNTWSManager listAuthorizations];
    //Si el servicio devuelve error, tiramos de base de datos, "Modo offline"
    
    if(!_arrayCurrent){
        DNTSqliteManager *sqLite = [[DNTSqliteManager alloc]init];
        NSArray *arrayDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        // Check if the database has already been created in the users filesystem
        NSString *databasePath = [[arrayDocuments objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        [sqLite openDbAtPath:databasePath];
        _arrayCurrent = [sqLite buscarAutorizaciones:DNTDBPendientes];
        [sqLite closeDb];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayCurrent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DNTCellHistory *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHistory"];
    DNTAutorizacion *autorizacion = [_arrayCurrent objectAtIndex:[indexPath row]];
    cell.labelCell.text  = autorizacion.titulo;
    [cell.labelCell setBackgroundColor:[UIColor clearColor]];
    cell.subLabelCell.text = autorizacion.texto;
    cell.dateLabelCell.text = autorizacion.date;
    cell.viewAccesoryCell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNTAuthorizationViewController *authVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DNTAuthorizationViewController"];
    [authVC setAutorizacion:[_arrayCurrent objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:authVC animated:YES];
}

#pragma mark - Private methods

- (void)dataDidRefresh:(NSArray *)data {
    // Warn the table view that the refresh did finish
    [self cargarDatosDB];
    [_table refreshFinished];
    [_table reloadData];
}

- (void)dataDidLoadMore:(NSArray *)data {
    // Warn the table view that the refresh did finish
    [_table loadMoreFinished];
}
@end