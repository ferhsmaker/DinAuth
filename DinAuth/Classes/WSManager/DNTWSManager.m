//
//  DNTWSManager.m
//  DinAuth
//
//  Created by Fernando on 08/03/13.
//  Copyright (c) 2013 Fernando. All rights reserved.
//

#import "DNTWSManager.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "DNTAppDelegate.h"
#import "G4WSSvc.h"

/*URLS*/
#define kWSLoginURL                         @""
#define kWSListAuthorizations               @""
#define KWSAuthorizationAnswer              @""
#define kWSConfigureKeyUser                 @""
#define KWSChangeKeyUser                    @""

/*PARAMETERS*/
#define kWSUserKey                          @""
#define kWSPasswordKey                      @""
#define kWSClaveKey                         @""
#define kWSOldClaveKey                      @""
#define kWSNewClaveKey                      @""
#define kWSIdAuthKey                        @""
#define kWSStateAuthKey                     @""
#define kWSSilenceTime                      @""

/*RESPONSES*/
#define kWSResponseKey                      @"response"
#define kWSLoginResponseOK                  0
#define kWSLoginResponseErrorUserPassword   -1

@implementation DNTWSManager

@synthesize queue = _queue;


- (void)llamadaSoap{
    [self processRequest];
    
}

- (void)processRequest{
    
    BasicHttpBinding_IG4WSBinding *binding = [G4WSSvc BasicHttpBinding_IG4WSBinding] ;
    binding.logXMLInOut = YES;
    
    
    BasicHttpBinding_IG4WSBindingOperation* request = [[BasicHttpBinding_IG4WSBindingOperation alloc]init];
    BasicHttpBinding_IG4WSBindingResponse *response = [binding Prueba_ConexionUsingParameters:request];
    NSArray *responseHeaders = response.headers;
    NSArray *responseBodyParts = response.bodyParts;
    
    for(id header in responseHeaders) {
        NSLog(@"header %@",header);
    }
    
    for(id bodyPart in responseBodyParts) {
        NSLog(@"header %@",bodyPart);
    }
}





+ (NSObject *)jsonBySynchRequest:(ASIFormDataRequest *)request {
    if (request == nil)
        return nil;
    request.timeOutSeconds = 8;
    [request startSynchronous];
    NSError *error = [request error];
    if (error){
        NSLog(@"WSError:%@", error);
        return nil;
    }
    
    //    NSString *response = [request responseString];
    NSString *response = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    response = [[response componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@" "];
    NSObject *jsonDict = [response JSONValue];
    
    return jsonDict;
}


+ (BOOL)loginWithUser:(NSString *)username andPassword:(NSString *)password {
    if(!username || [username isEqualToString:@""] || !password || [password isEqualToString:@""]){
        return NO;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kWSLoginURL]];
    [request setPostValue:username forKey:kWSUserKey];
    [request setPostValue:password forKey:kWSPasswordKey];
    
    NSDictionary *loginDict = (NSDictionary *)[DNTWSManager jsonBySynchRequest:request];
    
    if (!loginDict) {
#if DISTRIBUTION
        NSLog(@"Error haciendo login con user:%@", username);
#else
        NSLog(@"Error haciendo login con user:%@ pass:%@", username, password);
#endif
        return NO;
    }
    
    NSNumber *result = [loginDict objectForKey:kWSResponseKey];
    
    //Login correct
    if ([result intValue] == kWSLoginResponseOK){
#if DISTRIBUTION
        NSLog(@"Logueado correctamente con user:%@", username);
#else
        NSLog(@"Logueado correctamente con user:%@ pass:%@", username, password);
#endif
        return YES;
    }
    
    
    if ([result intValue] == kWSLoginResponseErrorUserPassword){
#if DISTRIBUTION
        NSLog(@"Login Error autenticación por user:%@", username);
#else
        NSLog(@"Login Error autenticación por user:%@ pass:%@", username, password);
#endif
        return NO;
    }
    return NO;
}


+ (BOOL)configureUserkey:(NSString *)key WithUser:(NSString *)username andPassword:(NSString *)password {
    if(!username || [username isEqualToString:@""] || !password || [password isEqualToString:@""] || !key || [key isEqualToString:@""]){
        return NO;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kWSConfigureKeyUser]];
    [request setPostValue:username forKey:kWSUserKey];
    [request setPostValue:password forKey:kWSPasswordKey];
    [request setPostValue:key forKey:kWSClaveKey];
    NSDictionary *configureKeyDict = (NSDictionary *)[DNTWSManager jsonBySynchRequest:request];
    
    if (!configureKeyDict) {
#if DISTRIBUTION
        NSLog(@"Configure userKey Error autenticación por user:%@", username);
#else
        NSLog(@"Configure userKey Error autenticación por user:%@ pass:%@ key:%@", username, password, key);
#endif
        return NO;
    }
    
    NSNumber *result = [configureKeyDict objectForKey:kWSResponseKey];
    
    //Login correct
    if ([result intValue] == kWSLoginResponseOK){
#if DISTRIBUTION
        NSLog(@"Configure userKey correctamente por user:%@", username);
#else
        NSLog(@"Configure userKey correctamente por user:%@ pass:%@ key:%@", username, password, key);
#endif
        return YES;
    }
    if ([result intValue] == kWSLoginResponseErrorUserPassword){
#if DISTRIBUTION
        NSLog(@"Configure userKey Error autenticación por user:%@", username);
#else
        NSLog(@"Configure userKey Error autenticación por user:%@ pass:%@ key:%@", username, password, key);
#endif
        return NO;
    }
    return NO;
}

+ (NSArray *)listAuthorizations{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kWSListAuthorizations]];
    [request setPostValue:[defaults objectForKey:kUserLogin] forKey:kWSUserKey];
    [request setPostValue:[defaults objectForKey:kUserPass] forKey:kWSPasswordKey];
    NSArray *list = (NSArray *)[DNTWSManager jsonBySynchRequest:request];
    if (list == nil  || ![list isKindOfClass:[NSArray class]]) {
        NSLog(@"Error descargando la lista de autorizaciones");
        return nil;
    }
    if([list isKindOfClass:[NSArray class]] && [list count]>0 && [[[list objectAtIndex:0]objectForKey:kWSResponseKey]isEqualToString:@""]){
        NSLog(@"Error descargando la lista de libros ¿lista vacía?");
        return nil;
    }
    return list;
}

+ (BOOL)authorization:(DNTAutorizacion *) autorizacion responsedWithState:(DNTEstadoAutorizacion)estadoAutorizacion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KWSAuthorizationAnswer]];
    [request setPostValue:[defaults objectForKey:kUserLogin] forKey:kWSUserKey];
    [request setPostValue:[defaults objectForKey:kUserPass] forKey:kWSPasswordKey];
    [request setPostValue:[defaults objectForKey:kClave] forKey:kWSClaveKey];
    [request setPostValue:autorizacion.identificador forKey:kWSIdAuthKey];
    [request setPostValue:[NSNumber numberWithInt:estadoAutorizacion] forKey:kWSIdAuthKey];
    
    NSDictionary *authKeyDict = (NSDictionary *)[DNTWSManager jsonBySynchRequest:request];
    if (!authKeyDict) {
#if DISTRIBUTION
        NSLog(@"Autorizacion Error con user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Autorizacion Error por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%d", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], autorizacion.identificador, estadoAutorizacion);
#endif
        return NO;
    }
    
    NSNumber *result = [authKeyDict objectForKey:kWSResponseKey];
    //Login correct
    if ([result intValue] == kWSLoginResponseOK){
#if DISTRIBUTION
        NSLog(@"Autorizado correctamente por user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Autorizado correctamente por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%d", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], autorizacion.identificador, estadoAutorizacion);
#endif
        return YES;
    }
    if ([result intValue] == kWSLoginResponseErrorUserPassword){
#if DISTRIBUTION
        NSLog(@"Autorización Error por user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Autorización Error autenticación por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%d", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], autorizacion.identificador, estadoAutorizacion);
#endif
        return NO;
    }
    return NO;
}



+ (BOOL)changeUserKey:(NSString *)currentUserKey withNewKey:(NSString *)newUserKey{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KWSChangeKeyUser]];
    [request setPostValue:[defaults objectForKey:kUserLogin] forKey:kWSUserKey];
    [request setPostValue:[defaults objectForKey:kUserPass] forKey:kWSPasswordKey];
    [request setPostValue:newUserKey forKey:kWSNewClaveKey];
    [request setPostValue:currentUserKey forKey:kWSOldClaveKey];
    
    NSDictionary *authKeyDict = (NSDictionary *)[DNTWSManager jsonBySynchRequest:request];
    if (!authKeyDict) {
#if DISTRIBUTION
        NSLog(@"Cambio de clave Error con user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Cambio de clave Error por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%@", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], newUserKey, currentUserKey);
#endif
        return NO;
    }
    
    NSNumber *result = [authKeyDict objectForKey:kWSResponseKey];
    //Login correct
    if ([result intValue] == kWSLoginResponseOK){
#if DISTRIBUTION
        NSLog(@"Cambio de clave correcto por user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Cambio de clave correcto por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%@", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], newUserKey, currentUserKey);
#endif
        
        return YES;
    }
    if ([result intValue] == kWSLoginResponseErrorUserPassword){
#if DISTRIBUTION
        NSLog(@"Cambio de clave Error por user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Cambio de clave Error autenticación por user:%@ pass:%@ key:%@ idAutorizacion;%@ estadoAutorizacion:%@", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], [defaults objectForKey:kClave], newUserKey, currentUserKey);
#endif
        return NO;
    }
    return NO;
}


+ (BOOL) deactivatePushNotifications:(DNTTimeSilence)valor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KWSChangeKeyUser]];
    [request setPostValue:[defaults objectForKey:kUserLogin] forKey:kWSUserKey];
    [request setPostValue:[defaults objectForKey:kUserPass] forKey:kWSPasswordKey];
    [request setPostValue:[NSNumber numberWithInt:valor] forKey:kWSSilenceTime];
    
    NSDictionary *timeKeyDict = (NSDictionary *)[DNTWSManager jsonBySynchRequest:request];
    if (!timeKeyDict) {
#if DISTRIBUTION
        NSLog(@"Silenciar Error con user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Silenciar Error por user:%@ pass:%@ timeValor:%d", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], valor);
#endif
        return NO;
    } 
    NSNumber *result = [timeKeyDict objectForKey:kWSResponseKey];
    //Login correct
    if ([result intValue] == kWSLoginResponseOK){
#if DISTRIBUTION
        NSLog(@"Silenciado correcto por user:%@", [defaults objectForKey:kUserLogin]);
#else
        NSLog(@"Silenciado correcto por user:%@ pass:%@ timeValor:%d", [defaults objectForKey:kUserLogin], [defaults objectForKey:kUserPass], valor);
#endif
        return YES;
    }

    return NO;
}

@end
