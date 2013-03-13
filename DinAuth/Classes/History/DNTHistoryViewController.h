//
//  DNTFirstViewController.h
//  DinAuth
//
//  Created by Fernando on 08/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNTHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{

    NSMutableArray *_arrayHistory;
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *arrayHistory;

@end
