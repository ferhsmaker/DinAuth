#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xsd.h"
#import "G4WSSvc.h"
#import "ns1.h"
@class BasicHttpBinding_IG4WSBinding;
@interface G4WSSvc : NSObject {
	
}
+ (BasicHttpBinding_IG4WSBinding *)BasicHttpBinding_IG4WSBinding;
@end
@class BasicHttpBinding_IG4WSBindingResponse;
@class BasicHttpBinding_IG4WSBindingOperation;
@protocol BasicHttpBinding_IG4WSBindingResponseDelegate <NSObject>
- (void) operation:(BasicHttpBinding_IG4WSBindingOperation *)operation completedWithResponse:(BasicHttpBinding_IG4WSBindingResponse *)response;
@end
@interface BasicHttpBinding_IG4WSBinding : NSObject <BasicHttpBinding_IG4WSBindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval defaultTimeout;
	NSMutableArray *cookies;
	BOOL logXMLInOut;
	BOOL synchronousOperationComplete;
	NSString *authUsername;
	NSString *authPassword;
}
@property (copy) NSURL *address;
@property (assign) BOOL logXMLInOut;
@property (assign) NSTimeInterval defaultTimeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSString *authUsername;
@property (nonatomic, retain) NSString *authPassword;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(BasicHttpBinding_IG4WSBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (BasicHttpBinding_IG4WSBindingResponse *)Get_FinancialMarginUsingParameters:(id)aParameters ;
- (void)Get_FinancialMarginAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Get_Client_XMLUsingParameters:(id)aParameters ;
- (void)Get_Client_XMLAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Get_ClientProvUsingParameters:(id)aParameters ;
- (void)Get_ClientProvAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Set_DocumentUsingParameters:(id)aParameters ;
- (void)Set_DocumentAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Prueba_ConexionUsingParameters:(id)aParameters ;
- (void)Prueba_ConexionAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Get_AllowNewDeliveryNoteExUsingParameters:(id)aParameters ;
- (void)Get_AllowNewDeliveryNoteExAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Get_AllowNewDeliveryNoteEx_ArdUsingParameters:(id)aParameters ;
- (void)Get_AllowNewDeliveryNoteEx_ArdAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Sync_EnviarUsingParameters:(id)aParameters ;
- (void)Sync_EnviarAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
- (BasicHttpBinding_IG4WSBindingResponse *)Sync_RecibirUsingParameters:(id)aParameters ;
- (void)Sync_RecibirAsyncUsingParameters:(id)aParameters  delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)responseDelegate;
@end
@interface BasicHttpBinding_IG4WSBindingOperation : NSOperation {
	BasicHttpBinding_IG4WSBinding *binding;
	BasicHttpBinding_IG4WSBindingResponse *response;
	id<BasicHttpBinding_IG4WSBindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (retain) BasicHttpBinding_IG4WSBinding *binding;
@property (readonly) BasicHttpBinding_IG4WSBindingResponse *response;
@property (nonatomic, assign) id<BasicHttpBinding_IG4WSBindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate;
@end
@interface BasicHttpBinding_IG4WSBinding_Get_FinancialMargin : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id) aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Get_Client_XML : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Get_ClientProv : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Set_Document : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Prueba_Conexion : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Get_AllowNewDeliveryNoteEx : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Get_AllowNewDeliveryNoteEx_Ard : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Sync_Enviar : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_Sync_Recibir : BasicHttpBinding_IG4WSBindingOperation {
}
@property (nonatomic, strong) id  parameters;
- (id)initWithBinding:(BasicHttpBinding_IG4WSBinding *)aBinding delegate:(id<BasicHttpBinding_IG4WSBindingResponseDelegate>)aDelegate
	parameters:(id)aParameters
;
@end
@interface BasicHttpBinding_IG4WSBinding_envelope : NSObject {
}
+ (BasicHttpBinding_IG4WSBinding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements;
@end
@interface BasicHttpBinding_IG4WSBindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (retain) NSArray *headers;
@property (retain) NSArray *bodyParts;
@property (retain) NSError *error;
@end
