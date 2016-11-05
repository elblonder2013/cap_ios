//
//  PerfilAdminVCViewController.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/25/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilAdminVCViewController.h"
#import "GestorV.h"
#import "Common.h"
#import "Admin.h"
#import "Usuario.h"
#import "ListadoBuscarVC.h"
#import "Util.h"
#import "Constants.h"
@interface PerfilAdminVCViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbllNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblNumeroExpediente;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCelular;
@property (weak, nonatomic) IBOutlet UILabel *lblLugarTrabajo;
@property (weak, nonatomic) IBOutlet UILabel *lblFechaUltimaApp;
@property (weak, nonatomic) IBOutlet UIButton *btnReferencias;
@property (weak, nonatomic) IBOutlet UILabel *lblGerenteAsignado;
@property (weak, nonatomic) IBOutlet UILabel *lblIdGerenteAsignado;
@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirma;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial2;
@property (weak, nonatomic) IBOutlet UIImageView *imgComprobanteDomicilio;
@property (weak, nonatomic) IBOutlet UIView *vistaReferencia;
@property (weak, nonatomic) IBOutlet UIView *vistaGerenteAsignado;
@property (weak, nonatomic) IBOutlet UIView *vistaIdGerenteAsig;
@property (weak, nonatomic) IBOutlet UIView *vistaCalificaGerente;
@property (weak, nonatomic) IBOutlet UIView *vistaFirma;
@property (weak, nonatomic) IBOutlet UIView *vistaCredencial;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@end

@implementation PerfilAdminVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepararComponentes];
    [self LoadData];
}
-(void)LoadData
{
    Usuario * user = [GestorV getGV].user;
    Admin  * admin = (Admin *)[GestorV getGV].userAutenticado;
    _lbllNombre.text = user.fullname;
    _lblDireccion.text = admin.direccion;
    _lblLugarTrabajo.text = admin.dirTrabajo;
    _lblFechaUltimaApp.text = user.fecha_ultimo_acc;
     NSString * avatarUrl = admin.datosUsuario.avatar;
    if (avatarUrl!=nil && ![avatarUrl isEqualToString:@""]) {
       
        NSString * urlDescargar = [NSString stringWithFormat:@"%@/%@/%@",WebUrlPateon,@"avatars",avatarUrl];
        
        [Util DownloadImageForImageViewWithUrl:urlDescargar imgeview:_imgUsuario];
    }
}
-(void)PrepararComponentes
{
    _imgUsuario.clipsToBounds  = YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(27, 96, 172)];
    [[GestorV getGV] ConvertInCircle:_btnReferencias];
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_vistaComprobante scroll:_scrollContainer bottomSpacing:10];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)GoBack:(id)sender
{
    [GestorV GoBack:self];
}
-(IBAction)GoToGerentes:(id)sender
{
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(235, 171, 60);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"gerentes";
    vc.ACTION = @"SHOW_ADMIN_GERENTES";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
