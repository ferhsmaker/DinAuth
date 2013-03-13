//
//  DNTSqliteManager.m
//  DinAuth
//
//  Created by Fernando Agüero on 3/7/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTSqliteManager.h"
#import "DNTAutorizacion.h"

#define kDB_AutorizacionResultColumns @"DATE,TEXTO,TITULO,EMISOR,IDENTIFICADOR,ESTADO"
#define kDB_Texto @"TEXTO"
#define kDB_Titulo @"TITULO"
#define kDB_Emisor @"EMISOR"
#define kDB_Identificador @"IDENTIFICADOR"
#define kDB_Estado @"ESTADO"
#define kDB_Date @"DATE"

#define kDB_SelectPendientes @"SELECT * FROM PENDIENTES"
#define kDB_DeletePendiente @"DELETE FROM PENDIENTES WHERE IDENTIFICADOR = \"%@\""
#define kDB_SelectHistoricos @"SELECT * FROM HISTORICO"
#define kDB_DeleteHistoricos @"DELETE FROM HISTORICO"
#define kDB_InsertHistorico @"INSERT INTO HISTORICO (DATE,TEXTO,TITULO,EMISOR,ESTADO) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %d)"
#define kDB_InsertPendiente @"INSERT INTO PENDIENTES (DATE,TEXTO,TITULO,EMISOR,ESTADO) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %d)"

@implementation DNTSqliteManager



- (void)dealloc {
	if (dbOpened)
		[self closeDb];
}

#pragma mark -
#pragma mark open and close DB methods
- (BOOL)openDbAtPath:(NSString *)filePath {
	if (filePath == nil)
		return NO;
	
	if (dbOpened)
		return YES;
	
	_database = nil;
    dbOpened = sqlite3_open_v2([filePath UTF8String], &_database, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK;
	return dbOpened;
}

- (void)closeDb {
	if (dbOpened) {
		sqlite3_close(_database);
		dbOpened = NO;
	}
}

- (NSArray *)buscarAutorizaciones:(DNTDBEstadoAutorizacion)estado{
    if (!dbOpened)
        return nil;
	NSMutableArray* autorizaciones = [[NSMutableArray alloc] init];
    NSString *selectColumns = kDB_AutorizacionResultColumns;
    NSArray *columns = [selectColumns componentsSeparatedByString:@","];
    NSString *sqlStatement;
    switch (estado) {
        case DNTDBHistoricos:
            sqlStatement = kDB_SelectHistoricos;
            break;
        case DNTDBPendientes:
            sqlStatement = kDB_SelectPendientes;
        default:
            break;
    }
    NSLog(@"sql searchMarginalesWithText: %@", sqlStatement); /* DEBUG LOG */
    
	// Setup the SQL Statement and compile it for faster access
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(_database, [sqlStatement UTF8String], [sqlStatement lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &compiledStatement, NULL) == SQLITE_OK) {
		int cols = sqlite3_column_count(compiledStatement);
		
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			DNTAutorizacion *result = [[DNTAutorizacion alloc] init];
			for (int col = 0; col < cols; col++) {
				NSString *key = [columns objectAtIndex:col]; //Load key
				NSString *value = nil; //Load value
				const char *text = (const char*)sqlite3_column_text(compiledStatement, col);
				if (text != nil)
					value = [NSString stringWithUTF8String:text];
                if([[key lowercaseString] isEqualToString:[kDB_Texto lowercaseString]]){
                    result.texto = value;
                }else if([[key lowercaseString] isEqualToString:[kDB_Titulo lowercaseString]]){
                    result.titulo = value;
                }else if([[key lowercaseString] isEqualToString:[kDB_Emisor lowercaseString]]){
                    result.emisor = value;
                }else if([[key lowercaseString] isEqualToString:[kDB_Identificador lowercaseString]]){
                    result.identificador = value;
                }else if([[key lowercaseString] isEqualToString:[kDB_Estado lowercaseString]]){
                    result.estadoAutorizacion = [value intValue];
                }else if([[key lowercaseString] isEqualToString:[kDB_Date lowercaseString]]){
                    result.date = value;
                }
			}
			[autorizaciones addObject:result];
			result = nil;
		}
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
    
    return autorizaciones;
}

- (BOOL)borrarAutorizacion:(DNTAutorizacion *)autorizacion{
    if (!dbOpened)
        return NO;
    NSString *sqlStatement = [NSString stringWithFormat:kDB_DeletePendiente,autorizacion.identificador];
    NSLog(@"sql searchMarginalesWithText: %@", sqlStatement); /* DEBUG LOG */
    
	// Setup the SQL Statement and compile it for faster access
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(_database, [sqlStatement UTF8String], [sqlStatement lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &compiledStatement, NULL) == SQLITE_OK) {
        if(sqlite3_step(compiledStatement) == SQLITE_DONE){
            sqlite3_finalize(compiledStatement);
            return YES;
        }else if(sqlite3_step(compiledStatement) == SQLITE_ERROR){
            sqlite3_finalize(compiledStatement);
            return NO;
        }
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
    
    return NO;
}

- (BOOL)insertarAutorizacion:(DNTAutorizacion *)autorizacion enDB:(DNTDBEstadoAutorizacion)database conEstadoAutorizacion:(DNTEstadoAutorizacion)estadoAutorizacion{
    if (!dbOpened)
        return NO;
    NSString *sqlStatement;
    switch (database) {
        case DNTDBHistoricos:
            sqlStatement = kDB_InsertHistorico;
            break;
        case DNTDBPendientes:
            sqlStatement = kDB_InsertPendiente;
        default:
            break;
    }
    sqlStatement = [NSString stringWithFormat:sqlStatement,autorizacion.date,autorizacion.texto,autorizacion.titulo,autorizacion.emisor,estadoAutorizacion];
    NSLog(@"sql searchMarginalesWithText: %@", sqlStatement); /* DEBUG LOG */
    
	// Setup the SQL Statement and compile it for faster access
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(_database, [sqlStatement UTF8String], [sqlStatement lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &compiledStatement, NULL) == SQLITE_OK) {
        if(sqlite3_step(compiledStatement) == SQLITE_DONE){
            sqlite3_finalize(compiledStatement);
            return YES;
        }else if(sqlite3_step(compiledStatement) == SQLITE_ERROR){
            sqlite3_finalize(compiledStatement);
            return NO;
        }
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
    
    return NO;
}

- (BOOL)borrarHistoricos{
    if (!dbOpened)
        return NO;
    NSString *sqlStatement = kDB_DeleteHistoricos;
    NSLog(@"sql searchMarginalesWithText: %@", sqlStatement); /* DEBUG LOG */
    
	// Setup the SQL Statement and compile it for faster access
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(_database, [sqlStatement UTF8String], [sqlStatement lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &compiledStatement, NULL) == SQLITE_OK) {
        if(sqlite3_step(compiledStatement) == SQLITE_DONE){
            sqlite3_finalize(compiledStatement);
            return YES;
        }else if(sqlite3_step(compiledStatement) == SQLITE_ERROR){
            sqlite3_finalize(compiledStatement);
            return NO;
        }
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
    
    return NO;
}



@end
