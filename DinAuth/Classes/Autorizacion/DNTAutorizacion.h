//
//  DNTAutorizacion.h
//  DinAuth
//
//  Created by Fernando on 03/03/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    DNTEstadoAutorizacionPendiente = 0,
    DNTEstadoAutorizacionAutorizada,
    DNTEstadoAutorizacionDenegada,
    DNTEstadoAutorizacionPospuesta
};
typedef NSUInteger DNTEstadoAutorizacion;

@interface DNTAutorizacion : NSObject{

    NSString *_texto;
    NSString *_titulo;
    NSString *_identificador;
    NSString *_emisor;
    NSString *_date;
    DNTEstadoAutorizacion _estadoAutorizacion;
}

@property (nonatomic, strong) NSString *texto;
@property (nonatomic, strong) NSString *titulo;
@property (nonatomic, strong) NSString *identificador;
@property (nonatomic, strong) NSString *emisor;
@property (nonatomic, strong) NSString *date;
@property (nonatomic) DNTEstadoAutorizacion estadoAutorizacion;


@end