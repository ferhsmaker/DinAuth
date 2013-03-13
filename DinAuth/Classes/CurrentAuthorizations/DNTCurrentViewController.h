//
//  DNTCurrentViewController.h
//  DinAuth
//
//  Created by Fernando on 25/02/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNTCurrentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *_arrayCurrent;
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *arrayCurrent;

@end
