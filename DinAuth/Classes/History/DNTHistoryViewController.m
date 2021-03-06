//
//  DNTFirstViewController.m
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTHistoryViewController.h"
#import "DNTAuthorizationViewController.h"
#import "DNTCellHistory.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "DNTAutorizacion.h"
#import <QuartzCore/QuartzCore.h>
#import "DNTSqliteManager.h"
#import "DNTAppDelegate.h"

#define keyTitle @"keyTitle"
#define keyState @"keyState"

@interface DNTHistoryViewController ()
- (void)dataDidRefresh:(NSArray *)data;
- (void)dataDidLoadMore:(NSArray *)data;
@end

@implementation DNTHistoryViewController
@synthesize arrayHistory = _arrayHistory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DNTHistoryViewController *me = self;
    [_table setPullToRefreshHandler:^{
        
        /**
         Note: Here you should deal perform a webservice request, CoreData query or
         whatever instead of this dummy code ;-)
         */

        [me performSelector:@selector(dataDidRefresh:) withObject:me.arrayHistory afterDelay:1.0];
    }];
    
    // Set the pull to laod more handler block
    [_table setPullToLoadMoreHandler:^{
        
        /**
         Note: Here you should deal perform a webservice request, CoreData query or
         whatever instead of this dummy code ;-)
         */
        [me performSelector:@selector(dataDidLoadMore:) withObject:me.arrayHistory afterDelay:1.0];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cargarDatosDB];
    [_table reloadData];
}

- (void)cargarDatosDB{
    
    DNTSqliteManager *sqLite = [[DNTSqliteManager alloc]init];
    NSArray *arrayDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	// Check if the database has already been created in the users filesystem
    NSString *databasePath = [[arrayDocuments objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    [sqLite openDbAtPath:databasePath];
    _arrayHistory = [NSMutableArray arrayWithArray:[sqLite buscarAutorizaciones:DNTDBHistoricos]];
    [sqLite closeDb];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DNTCellHistory *cell = [tableView dequeueReusableCellWithIdentifier:@"cellHistory"];
    DNTAutorizacion *autorizacion = [_arrayHistory objectAtIndex:[indexPath row]];
    cell.labelCell.text  = autorizacion.titulo;
    [cell.labelCell setBackgroundColor:[UIColor clearColor]];
    cell.subLabelCell.text = autorizacion.texto;
    cell.dateLabelCell.text = autorizacion.date;
    switch (autorizacion.estadoAutorizacion) {
        case 1:
            cell.viewAccesoryCell.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:193.0/255.0 blue:52.0/255.0 alpha:1.0];
            [cell.viewAccesoryCell.layer setCornerRadius:10.0];
            break;
        case 2:
            cell.viewAccesoryCell.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:62.0/255.0 blue:63.0/255.0 alpha:1.0];
            [cell.viewAccesoryCell.layer setCornerRadius:10.0];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNTAuthorizationViewController *authVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DNTAuthorizationViewController"];
    [authVC setAutorizacion:[_arrayHistory objectAtIndex:indexPath.row]];
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