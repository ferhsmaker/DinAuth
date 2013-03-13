//
//  DNTSqliteManager.h
//  DinAuth
//
//  Created by Fernando Agüero on 3/7/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DNTAutorizacion.h"

enum {
    DNTDBPendientes = 0,
    DNTDBHistoricos
};
typedef NSUInteger DNTDBEstadoAutorizacion;

@interface DNTSqliteManager : NSObject{

    sqlite3 *_database;
    BOOL dbOpened;
}

- (BOOL)openDbAtPath:(NSString *)filePath;
- (void)closeDb;

- (NSArray *)buscarAutorizaciones:(DNTDBEstadoAutorizacion)estado;
- (BOOL)borrarAutorizacion:(DNTAutorizacion *)autorizacion;
- (BOOL)insertarAutorizacion:(DNTAutorizacion *)autorizacion enDB:(DNTDBEstadoAutorizacion)database conEstadoAutorizacion:(DNTEstadoAutorizacion)estadoAutorizacion;
- (BOOL)borrarHistoricos;

@end
