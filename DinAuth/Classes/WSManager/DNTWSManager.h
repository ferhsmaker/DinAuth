//
//  DNTWSManager.h
//  DinAuth
//
//  Created by Fernando on 08/03/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNTAutorizacion.h"
#import "DNTConfigViewController.h"

@interface DNTWSManager : NSObject{

    NSOperationQueue *_queue;
}

@property (nonatomic, strong) NSOperationQueue *queue;
//- (NSString *)pruebaLlamadaWS;

+ (BOOL)loginWithUser:(NSString *)username andPassword:(NSString *)password;
+ (NSArray *)listAuthorizations;
+ (BOOL)configureUserkey:(NSString *)key WithUser:(NSString *)username andPassword:(NSString *)password;
+ (BOOL)authorization:(DNTAutorizacion *) autorizacion responsedWithState:(DNTEstadoAutorizacion)estadoAutorizacion;
+ (BOOL)changeUserKey:(NSString *)currentUserKey withNewKey:(NSString *)newUserKey;
+ (BOOL)deactivatePushNotifications:(DNTTimeSilence)valor;
@end
