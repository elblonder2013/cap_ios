//
//  PerfilInversionistaVC.m
//  cap
//
//  Created by Alexei on 04/11/16.
//  Copyright (c) 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilInversionistaVC.h"
#import "GestorV.h"
#import "Common.h"
#import "Constants.h"
@interface PerfilInversionistaVC ()
@property (weak, nonatomic) IBOutlet UILabel *lbllNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblNumeroExpediente;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCelular;
@property (weak, nonatomic) IBOutlet UILabel *lblLugarTrabajo;
@property (weak, nonatomic) IBOutlet UILabel *lblSueldoMensual;
@property (weak, nonatomic) IBOutlet UIButton *btnReferencias;
@property (weak, nonatomic) IBOutlet UIButton *btnAval;
@property (weak, nonatomic) IBOutlet UILabel *lblPrendaEmpeno;

@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirma;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial2;
@property (weak, nonatomic) IBOutlet UIImageView *imgComprobanteDomicilio;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@end

@implementation PerfilInversionistaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgUsuario.clipsToBounds  = YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(243, 130, 54)];
    [[GestorV getGV] ConvertInCircle:_btnReferencias];
    [[GestorV getGV] ConvertInCircle:_btnAval];
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_vistaComprobante scroll:_scrollContainer bottomSpacing:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GoBack:(id)sender {
    [GestorV GoBack:self];
}

@end
