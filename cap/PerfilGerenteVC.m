//
//  PerfilGerenteVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/26/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilGerenteVC.h"
#import "GestorV.h"
#import "Common.h"
#import "ASIHTTPRequest.h"
#import "RequestManager.h"
#import "SBJsonParser.h"
#import "LoadingView.h"
#import "Gerente.h"
#import "ListadoBuscarVC.h"
#import "Util.h"
@interface PerfilGerenteVC ()
{
    
    Gerente * datosGerente;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbllNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblNumeroExpediente;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCelular;
@property (weak, nonatomic) IBOutlet UILabel *lblLugarTrabajo;
@property (weak, nonatomic) IBOutlet UILabel *lblFechaUltimaApp;
@property (weak, nonatomic) IBOutlet UIButton *btnReferencias;

@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirma;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial2;
@property (weak, nonatomic) IBOutlet UIImageView *imgComprobanteDomicilio;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;


//recibo del pago al promotor


@end

@implementation PerfilGerenteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepararCompontes];
}
-(void)PrepararCompontes
{
    _imgUsuario.clipsToBounds  = YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(235, 171, 60)];
    
    [[GestorV getGV] ConvertInCircle:_btnReferencias];
   
    
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_vistaComprobante scroll:_scrollContainer bottomSpacing:10];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (datosGerente==nil) {
         [self prepareRequestTogetData];
    }
   
}
-(void)prepareRequestTogetData
{
    
    ASIHTTPRequest* request;
    RequestManager* rm = [RequestManager sharedInstance];
    NSString * idUsuario = _gerente.datosUsuario.Id;
    request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token,@"name":@"cliente",@"id_usuario":idUsuario} ruta:@"gerente"];
    
    
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
            datosGerente = [Gerente new];
            [datosGerente fromDictionary:responseDictionary];
            [self LoadGerenteData];
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
-(void)LoadGerenteData
{
    if (datosGerente!=nil) {
        _lblNumeroExpediente.text = [@"No. Exp: " stringByAppendingString:datosGerente.expediente];
        _lbllNombre.text = datosGerente.datosUsuario.fullname;
        _lblDireccion.text = datosGerente.direccion;
        _lblTelefono.text = datosGerente.telefono;
        _lblCelular.text = datosGerente.telefonoMovil;
        _lblLugarTrabajo.text = datosGerente.direccionTrabajo;
        NSString * avatarUrl = datosGerente.datosUsuario.avatar;
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
- (IBAction)GoPromoteresDelGerente:(id)sender {
    
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(53, 152, 220);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"promotores";
    vc.ACTION = @"SHOW_GERENTE_PROMOTORS";
    [self.navigationController pushViewController:vc animated:YES];

}


@end
