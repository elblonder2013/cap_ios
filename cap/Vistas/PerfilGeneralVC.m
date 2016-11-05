//
//  PerfilGeneralVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/1/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilGeneralVC.h"
#import "GestorV.h"

@interface PerfilGeneralVC ()
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
@property (weak, nonatomic) IBOutlet UIView *vistaCalificacionComoGerente;
@property (weak, nonatomic) IBOutlet UIView *vistaFirma;
@property (weak, nonatomic) IBOutlet UIView *vistaCredencial;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;

@end

@implementation PerfilGeneralVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imgUsuario.clipsToBounds  = YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
     [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:_color];
    _topBar.backgroundColor = _color;
    [[GestorV getGV] ConvertInCircle:_btnReferencias];
    UIView * lastView;
    if ([_tipoUsuario isEqualToString:@"gerentes"]) {
        _lblTitle.text = @"PERFIL DEL GERENTE";
        _vistaGerenteAsignado.hidden = YES;
        _vistaIdGerenteAsig.hidden = YES;
        _vistaCalificaGerente.hidden = YES;
        
        [[GestorV getGV] setViewToBelwOf:_vistaCalificacionComoGerente guideView:_vistaReferencia marginPorciento:0];
        lastView = _vistaCalificacionComoGerente;
    }
    else if([_tipoUsuario isEqualToString:@"promotores"])
    {
        _lblTitle.text = @"PERFIL DEL PROMOTOR";
         _vistaCalificaGerente.hidden = YES;
        _vistaCalificacionComoGerente.hidden = YES;
        lastView = _vistaIdGerenteAsig;
    }
    else if([_tipoUsuario isEqualToString:@"admin"])
    {
        _lblTitle.text = @"PERFIL DEL ADMINISTRADOR";
         _vistaCalificacionComoGerente.hidden = YES;
          [[GestorV getGV] setViewToBelwOf:_vistaCalificaGerente    guideView:_vistaIdGerenteAsig marginPorciento:0];
        lastView = _vistaCalificaGerente;
        
    }
    
    [[GestorV getGV] setViewToBelwOf:_vistaFirma guideView:lastView marginPorciento:0];
     [[GestorV getGV] setViewToBelwOf:_vistaCredencial guideView:_vistaFirma marginPorciento:0];
     [[GestorV getGV] setViewToBelwOf:_vistaComprobante guideView:_vistaCredencial marginPorciento:0];
    
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_vistaComprobante scroll:_scrollContainer bottomSpacing:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
