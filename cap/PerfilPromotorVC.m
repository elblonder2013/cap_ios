//
//  PerfilPromotorVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/26/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilPromotorVC.h"
#import "GestorV.h"
#import "Common.h"
#import "ASIHTTPRequest.h"
#import "RequestManager.h"
#import "SBJsonParser.h"
#import "LoadingView.h"
#import "Promotor.h"
#import "ListadoBuscarVC.h"
#import "Util.h"
@interface PerfilPromotorVC ()
{
    Promotor * datosPromotor;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbllNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblNumeroExpediente;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCelular;
@property (weak, nonatomic) IBOutlet UILabel *lblLugarTrabajo;
@property (weak, nonatomic) IBOutlet UILabel *lblFechaUltimaApp;
@property (weak, nonatomic) IBOutlet UILabel *lblGerenteAsignado;
@property (weak, nonatomic) IBOutlet UILabel *lblIdGerenteAsig;
@property (weak, nonatomic) IBOutlet UIButton *btnReferencias;

@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirma;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial2;
@property (weak, nonatomic) IBOutlet UIImageView *imgComprobanteDomicilio;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@end

@implementation PerfilPromotorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepararCompontes];
}
-(void)PrepararCompontes
{
    _imgUsuario.clipsToBounds  = YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(27, 96, 172)];
    [[GestorV getGV] ConvertInCircle:_btnReferencias];
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_vistaComprobante scroll:_scrollContainer bottomSpacing:10];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self prepareRequestTogetData];
}
-(void)prepareRequestTogetData
{
    
    ASIHTTPRequest* request;
    RequestManager* rm = [RequestManager sharedInstance];
    NSString * idUsuario = _promotor.datosUsuario.Id;
    request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token,@"id_usuario":idUsuario} ruta:@"promotor"];
    
    
    [LoadingView showLoadingView:@"Cargando..." parentView:self.view backColor:YES];
    [request setDelegate:self];
    request.tag = 1;//opteeniendo los upcomings events
    [request startAsynchronous];
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [LoadingView hideLoadingView:self.navigationController.view];
    [[GestorV getGV] ShowError:@"Network error..." vistaControlador:self];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    int codeStatus =  [request responseStatusCode];
    if (codeStatus==200) {
        NSString * response = [request responseString];
        SBJsonParser* myParser = [[SBJsonParser alloc] init];
        NSMutableDictionary* responseDictionary = [myParser objectWithString:response];
        if ([responseDictionary isKindOfClass:[NSNull class]] || responseDictionary == nil)
        {
            [LoadingView hideLoadingView:self.view];
            [[GestorV getGV] ShowError:@"Server internal error" vistaControlador:self.navigationController];
            return;
        }
        
        if (request.tag==1) {
            datosPromotor = [Promotor new];
            [datosPromotor fromDictionary:responseDictionary];
            [self LoadPromotorData];
            [LoadingView hideLoadingView:self.view];
            
            
            
        }
        
        
    }
    else
    {
        [LoadingView hideLoadingView:self.navigationController.view];
        [[GestorV getGV] ShowError:@"Network failed" vistaControlador:self.navigationController];
        //error de conexion
    }
}
-(void)LoadPromotorData
{
    if (datosPromotor!=nil) {
        if (datosPromotor.expediente!=nil) {
            _lblNumeroExpediente.text = [@"No. Exp: " stringByAppendingString:datosPromotor.expediente];
        }
        
        _lbllNombre.text = datosPromotor.datosUsuario.fullname;
        _lblTelefono.text = datosPromotor.telefonoFijo;
        _lblCelular.text = datosPromotor.telefonoMovil;
        _lblDireccion.text = datosPromotor.direccion;
        _lblLugarTrabajo.text = datosPromotor.dirTrabajo;
        
        NSString * avatarUrl = datosPromotor.datosUsuario.avatar;
        if (avatarUrl!=nil && ![avatarUrl isEqualToString:@""]) {
            NSString * urlDescargar = [NSString stringWithFormat:@"%@/%@/%@",WebUrlPateon,@"avatars",avatarUrl];
            [Util DownloadImageForImageViewWithUrl:urlDescargar imgeview:_imgUsuario];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Goback:(id)sender {
    [GestorV GoBack:self];
}
- (IBAction)GoClientesdelPromotor:(id)sender {
   ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(29, 185, 161);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"clientes";
    vc.ACTION = @"SHOW_PROMOTOR_CLIENTS";
    vc.idUsuario = datosPromotor.idPromotor;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
