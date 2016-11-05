//
//  PerfilDelClienteVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/31/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PerfilDelClienteVC.h"
#import "GestorV.h"
#import "Common.h"
#import "ItemEstandar.h"
#import "ASIHTTPRequest.h"
#import "RequestManager.h"
#import "SBJsonParser.h"
#import "LoadingView.h"
#import "PagoPendienteVC.h"
@interface PerfilDelClienteVC ()<UIScrollViewDelegate>
{
    Cliente * datosCliente;
}

/*TABS*/
@property (weak, nonatomic) IBOutlet UILabel *lblHistorial;
@property (weak, nonatomic) IBOutlet UILabel *lblDatosPeril;
@property (weak, nonatomic) IBOutlet UILabel *lblGrafica;
@property (weak, nonatomic) IBOutlet UIView *lineTab;
@property (weak, nonatomic) IBOutlet UIButton *btnIconPerfil;
@property (weak, nonatomic) IBOutlet UIButton *btnIconHistorial;
@property (weak, nonatomic) IBOutlet UIButton *btnIconGrafica;
@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblExpediente;
@property (weak, nonatomic) IBOutlet UILabel *lblFechaPago;
@property (weak, nonatomic) IBOutlet UILabel *lblCantidadAprobada;
@property (weak, nonatomic) IBOutlet UILabel *lblEstado;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblCelular;
@property (weak, nonatomic) IBOutlet UILabel *lblLugarTrabajo;
@property (weak, nonatomic) IBOutlet UILabel *lblSaldoMensual;
@property (weak, nonatomic) IBOutlet UILabel *lblNombrePromotor;
@property (weak, nonatomic) IBOutlet UIButton *btnReferencias;
@property (weak, nonatomic) IBOutlet UIButton *btnAval;
@property (weak, nonatomic) IBOutlet UILabel *lblPrendaEmpeno;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirma;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCredencial2;
@property (weak, nonatomic) IBOutlet UIImageView *imComprobnte;
@property (weak, nonatomic) IBOutlet UIView *vistaComprobante;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainerPerfil;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainerHistorial;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainerGrafica;



@end

@implementation PerfilDelClienteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepararComponentes];
    //[self loadHistorialInScroll];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self prepareRequestTogetData];
}
-(void)prepareRequestTogetData
{

    ASIHTTPRequest* request;
    RequestManager* rm = [RequestManager sharedInstance];
    NSString * idUsuario = _cliente.datosUsuario.Id;
    request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token,@"name":@"cliente",@"id_usuario":idUsuario} ruta:@"cliente"];
    
    
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
            datosCliente = [Cliente new];
            [datosCliente fromDictionary:responseDictionary];
            [self LoadClienteData];
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
-(void)LoadClienteData
{
    if (datosCliente!=nil) {
        _lblExpediente.text = [@"No. Exp: " stringByAppendingString:datosCliente.expediente];
        _lblNombre.text = datosCliente.datosUsuario.fullname;
    }
}



-(void)PrepararComponentes
{
    _scrollContainer.delegate = self;
    _imgUsuario.clipsToBounds = _lblEstado.clipsToBounds = _lblFechaPago.clipsToBounds = _lblCantidadAprobada.clipsToBounds = YES;
    [[GestorV getGV] setWidthOfView:_lineTab valor:self.view.frame.size.width/3]
    ;    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertInCircle:_lblFechaPago];
    [[GestorV getGV] ConvertInCircle:_lblCantidadAprobada];
    [[GestorV getGV] ConvertInCircle:_lblEstado];
     [[GestorV getGV] ConvertInCircle:_btnAval];
     [[GestorV getGV] ConvertInCircle:_btnReferencias];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:_lineTab.backgroundColor];
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_lblEstado scroll:_scrollContainerPerfil bottomSpacing:10];
    [[GestorV getGV] setWidthFillParent:_scrollContainer];
    [[GestorV getGV] setWidthFillParent:_scrollContainerPerfil];
    [[GestorV getGV] setWidthFillParent:_scrollContainerHistorial];
    _scrollContainer.pagingEnabled = YES;
    [[GestorV getGV] setViewToRightOf:_scrollContainerHistorial guideView:_scrollContainerPerfil marginPorciento:0];
    [[GestorV getGV] setViewToRightOf:_scrollContainerGrafica guideView:_scrollContainerHistorial marginPorciento:0];
    _scrollContainer.contentSize = CGSizeMake(CGRectGetMaxX(_scrollContainerGrafica.frame), _scrollContainer.frame.size.height);
    _scrollContainerPerfil.contentSize = CGSizeMake(_scrollContainerPerfil.frame.size.width, CGRectGetMaxY(_vistaComprobante.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - ACCIONES
- (IBAction)pickTab1:(id)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] aliniarInzquierda:_lineTab porcentMargenLeft:0];
        _lblDatosPeril.textColor = _btnIconPerfil.tintColor = RGBCOLOR(29, 185, 161);
       _btnIconGrafica.tintColor = _btnIconHistorial.tintColor = _lblGrafica.textColor = _lblHistorial.textColor = RGBCOLOR(115, 115, 155);
    } completion:^(BOOL finished)
     {
         
     }];
    }
- (IBAction)pickTab2:(id)sender {
    [_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] centrarHorizontal:_lineTab];
        _lblHistorial.textColor = _btnIconHistorial.tintColor = RGBCOLOR(29, 185, 161);
        _lblGrafica.textColor = _lblDatosPeril.textColor = _btnIconGrafica.tintColor = _btnIconPerfil.tintColor = RGBCOLOR(115, 115, 155);
        
        
    } completion:^(BOOL finished)
     {
        // if (_scrollContainerHistorial.subviews.count==0) {
             [self loadHistorialInScroll];
        // }
     }];

}
- (IBAction)pickTab3:(id)sender {
    [_scrollContainer setContentOffset:CGPointMake(640, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] aliniarDerecha:_lineTab porcentMargenWidth:0];
        _lblGrafica.textColor = _btnIconGrafica.tintColor =  RGBCOLOR(29, 185, 161);
       _btnIconHistorial.tintColor = _btnIconPerfil.tintColor = _lblHistorial.textColor = _lblDatosPeril.textColor = RGBCOLOR(115, 115, 155);
    } completion:^(BOOL finished)
     {
         
     }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView ==_scrollContainer) {
        CGPoint punto =  scrollView.contentOffset;
        int width = self.view.frame.size.width;
        int x = punto.x;
        //int realX = x%width;
        int newx = (int)x/width;
        NSLog(@" aqui va %i",newx);
        if (newx==0) {
            [UIView animateWithDuration:0.3 animations:^{
                [[GestorV getGV] aliniarInzquierda:_lineTab porcentMargenLeft:0];
                _lblDatosPeril.textColor = _btnIconPerfil.tintColor = RGBCOLOR(29, 185, 161);
                _btnIconGrafica.tintColor = _btnIconHistorial.tintColor = _lblGrafica.textColor = _lblHistorial.textColor = RGBCOLOR(115, 115, 155);
            } completion:^(BOOL finished)
             {
                 
             }];
        }
        else if (newx==1)
        {
            //[_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [[GestorV getGV] centrarHorizontal:_lineTab];
                _lblHistorial.textColor = _btnIconHistorial.tintColor = RGBCOLOR(29, 185, 161);
                _lblGrafica.textColor = _lblDatosPeril.textColor = _btnIconGrafica.tintColor = _btnIconPerfil.tintColor = RGBCOLOR(115, 115, 155);
                
                
            } completion:^(BOOL finished)
             {
                 
             }];
        }
        else if (newx==2)
        {
            //[_scrollContainer setContentOffset:CGPointMake(960, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [[GestorV getGV] aliniarDerecha:_lineTab porcentMargenWidth:0];
                _lblGrafica.textColor = _btnIconGrafica.tintColor =  RGBCOLOR(29, 185, 161);
                _btnIconHistorial.tintColor = _btnIconPerfil.tintColor = _lblHistorial.textColor = _lblDatosPeril.textColor = RGBCOLOR(115, 115, 155);
            } completion:^(BOOL finished)
             {
                 
             }];

        }
    }
}


- (IBAction)pickPagoPendiente:(id)sender {
}
- (IBAction)pickBloqueaPromotor:(id)sender {
}

- (IBAction)GOBACK:(id)sender {
    [GestorV GoBack:self ];
}

#pragma mark - FUNCIONES NECESARIAS
-(void)loadHistorialInScroll
{
    while (_scrollContainerHistorial.subviews.count>1) {
        [_scrollContainerHistorial.subviews.lastObject removeFromSuperview];
    }
    float yMax = 40;
    for (int i = 0; i<15; i++) {
        
        ItemEstandar * vista = [[ItemEstandar alloc] initWithFrame:CGRectMake(0, yMax, self.view.frame.size.width, 71)];
        vista.btnAction.tag = i;
        [vista LoadDataForHistorialCliente:nil];
        [vista.btnAction addTarget:self action:@selector(GotoController:) forControlEvents:UIControlEventTouchUpInside];
        //[vista PrepararParaCalendario:[arregloCalendario objectAtIndex:i]];
        [_scrollContainerHistorial addSubview:vista];
        yMax  = CGRectGetMaxY(vista.frame);
    }
    _scrollContainerHistorial.contentSize = CGSizeMake( CGRectGetWidth(_scrollContainerHistorial.frame),yMax+10 );
}
-(void)GotoController:(id)sender
{
    PagoPendienteVC * vc = [[PagoPendienteVC alloc] initWithNibName:@"PagoPendienteVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
