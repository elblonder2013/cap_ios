//
//  HomePromotorVC.m
//  cap
//
//  Created by Alexei on 12/09/16.
//  Copyright (c) 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "HomePromotorVC.h"
#import "Promotor.h"
#import "GestorV.h"
@interface HomePromotorVC ()
{
    Promotor * promotor;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *btnActionTop;
@property (weak, nonatomic) IBOutlet UIScrollView *menuLateral;
@property (weak, nonatomic) IBOutlet UIButton *btnBlack;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UIView *lineMenu;

//tabs
@property (weak, nonatomic) IBOutlet UIView *lineTab;
@property (weak, nonatomic) IBOutlet UIButton *btnComisiones;
@property (weak, nonatomic) IBOutlet UIButton *btnClientes;
@property (weak, nonatomic) IBOutlet UIButton *btnAplicaciones;


//vista comisiones
@property (weak, nonatomic) IBOutlet UILabel *lblCantinadNetaMes;
@property (weak, nonatomic) IBOutlet UILabel *lblCantidadBrutaMes;
@property (weak, nonatomic) IBOutlet UILabel *lblImpuestoPorComisiones;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollComisiones;


//VistaClientes
@property (weak, nonatomic) IBOutlet UIScrollView *scrollClientes;
@property (weak, nonatomic) IBOutlet UIView *vistaTitleClientesProximos;
@property (weak, nonatomic) IBOutlet UIView *vistaClientesMorosos;
@property (weak, nonatomic) IBOutlet UIView *vistaTitleClientesMorosos;


//vista aplicaciones
@property (weak, nonatomic) IBOutlet UIScrollView *scrollAplicaciones;
@property (weak, nonatomic) IBOutlet UIView *vistaAplicaciones;
@end

@implementation HomePromotorVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = YES;
    [self PrepararComponentes];
}

-(void)PrepararComponentes
{
    // el menu late/Users/alexei/Documents/Proyectos/cap/cap/HomePromotorVC.mral
    _imgUsuario.clipsToBounds =  YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(255, 255, 255)];
    
    _lblCantinadNetaMes.clipsToBounds = _lblCantidadBrutaMes.clipsToBounds = _lblImpuestoPorComisiones.clipsToBounds = YES;
    [[GestorV getGV] ConvertInCircle:_lblCantidadBrutaMes];
    [[GestorV getGV] ConvertInCircle:_lblCantinadNetaMes];
    [[GestorV getGV] ConvertInCircle:_lblImpuestoPorComisiones];
    
    [[GestorV getGV] setViewToRightOf:_scrollClientes guideView:_scrollComisiones marginPorciento:0];
    [[GestorV getGV] setViewToRightOf:_vistaAplicaciones guideView:_scrollClientes marginPorciento:0];
    _scrollContainer.contentSize = CGSizeMake(CGRectGetMaxX(_vistaAplicaciones.frame), _scrollContainer.frame.size.height);
    _scrollContainer.pagingEnabled = YES;
    
}

#pragma mark - ACCIONES
- (IBAction)ActionTop:(id)sender {
    if (_btnBlack.hidden==YES) {
        [self ShowMenu];
    }
    else
    {
        [self HideMenu];
    }
}

- (IBAction)pickComisiones:(id)sender {
}
- (IBAction)pickClientes:(id)sender {
}
- (IBAction)pickAplicaciones:(id)sender {
}

- (IBAction)pickBlackButton:(id)sender {
     [self HideMenu];
}

- (IBAction)GoToPerfil:(id)sender {
}
- (IBAction)GoToInicio:(id)sender {
}
- (IBAction)GoToReplicarCredito:(id)sender {
}
- (IBAction)GoToHistorialDePago:(id)sender {
}
- (IBAction)GoToClientes:(id)sender {
}
- (IBAction)GotoValorar:(id)sender {
}
- (IBAction)GoToCompartir:(id)sender {
}
- (IBAction)GoToAcercaDe:(id)sender {
}
- (IBAction)CerrarSession:(id)sender {
}


//clientes

- (IBAction)AddClienteProximopagar:(id)sender {
}
- (IBAction)AddClienteMoroso:(id)sender {
}




-(void)ShowMenu
{
    _btnActionTop.enabled = NO;
    _btnBlack.hidden =  NO;
    [UIView animateWithDuration:0.4 animations:^{
        _menuLateral.alpha = 1;
        [[GestorV getGV] aliniarInzquierda:_menuLateral porcentMargenLeft:0];
        _imgMenu.alpha = 0;
        _imgBack.alpha = 1;
        _btnBlack.alpha = 0.68;
        
    } completion:^(BOOL finished)
     {
         
         _btnActionTop.enabled = YES;
     }];
}
-(void)HideMenu
{
    _btnActionTop.enabled = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        _menuLateral.alpha = 1;
        
        CGRect rect = _menuLateral.frame;
        rect.origin.x = -1*rect.size.width;
        _menuLateral.frame=rect;
        
        
        
        //[[GestorV getGV] alignViewInLeftOf:_menuLateral guideView:_topBar porcentMargenLeft:0];
        _imgMenu.alpha = 1;
        _imgBack.alpha = 0;
        _btnBlack.alpha = 0;
        
    } completion:^(BOOL finished)
     {
         _btnBlack.hidden =  YES;
         _btnActionTop.enabled = YES;
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
