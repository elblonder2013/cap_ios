//
//  ListadoBuscarVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/27/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "ListadoBuscarVC.h"
#import "GestorV.h"
#import "Common.h"
#import "ItemEstandar.h"
#import "PerfilDelClienteVC.h"
#import "PerfilGeneralVC.h"
#import "ASIHTTPRequest.h"
#import "RequestManager.h"
#import "SBJsonParser.h"
#import "LoadingView.h"
#import "Cliente.h"
#import "Gerente.h"
#import "PerfilGerenteVC.h"
#import "Promotor.h"
#import "PerfilPromotorVC.h"
@interface ListadoBuscarVC ()<UISearchBarDelegate>
{
    UIButton * buttonSelected;
    int indexTab;
    NSMutableArray * arrDatos;
    BOOL yaSeListo;
}
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *vistaTab;
@property (weak, nonatomic) IBOutlet UIView *lineTab;
@property (weak, nonatomic) IBOutlet UIView *vistaTitulos;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView * scrollContainer;

@end

@implementation ListadoBuscarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    yaSeListo = NO;
    arrDatos = [[NSMutableArray alloc] init];
    [self PrepararComponentes];
    [self LoadTabs];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (yaSeListo==NO) {
        [self PrepareRequestToGetData];
    }
    
    
}

-(void)PrepareRequestToGetData
{
    ASIHTTPRequest* request;
    RequestManager* rm = [RequestManager sharedInstance];
    if ([_ACTION isEqualToString:@"SHOW_ALL_CLIENTS"]) {
        request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token} ruta:@"clientes"];
         request.tag = 1;
    }
    else if ([_ACTION isEqualToString:@"SHOW_PROMOTOR_CLIENTS"]) {
        request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token,@"id_usuario":_idUsuario} ruta:@"promotorcliente"];
        request.tag = 1;
    }
    else if ([_ACTION isEqualToString:@"SHOW_ADMIN_GERENTES"]||[_ACTION isEqualToString:@"SHOW_ALL_GERENTES"]) {
        request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token} ruta:@"gerentes"];
        request.tag = 2;
    }
    if ([_ACTION isEqualToString:@"SHOW_ALL_PROMOTORS"]||[_ACTION isEqualToString:@"SHOW_GERENTE_PROMOTORS"]) {//ESTE SE
        request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token} ruta:@"promotores"];
        request.tag = 3;
    }
    if ([_ACTION isEqualToString:@"SHOW_ALL_APPLICATION"]) {//ESTE SE
        request = [rm prepareRequestToGetWithDictionary:@{@"x-access-token":[GestorV getGV].token} ruta:@"aplicasiones"];
        request.tag = 4;
    }
    
    
    [LoadingView showLoadingView:@"Cargando..." parentView:self.view backColor:YES];
    [request setDelegate:self];
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
        NSMutableArray * arrayAux = (NSMutableArray *)responseDictionary;
        for (int i = 0; i<arrayAux.count; i++) {
            NSMutableDictionary * dict = [arrayAux objectAtIndex:i];            
            if (request.tag==1) {//listando clientes
                Cliente * c =[Cliente new];
                [c fromDictionary:dict];
                [arrDatos addObject:c];
            }
            else if (request.tag==2)
            {
                Gerente * c = [Gerente new];
                [c fromDictionary:dict];
                [arrDatos addObject:c];
            }
            else if (request.tag==3)
            {
                Promotor * c = [Promotor new];
                [c fromDictionary:dict];
                [arrDatos addObject:c];
            }
            else if(request.tag == 4)
            {
                //adicionar las aplicaciones
            }
        }
        [self LoadDatos];
        [LoadingView hideLoadingView:self.view];
    }
    else
    {
        [LoadingView hideLoadingView:self.navigationController.view];
        [[GestorV getGV] ShowError:@"Network failed" vistaControlador:self.navigationController];
        //error de conexion
    }
}




-(void)PrepararComponentes
{
    NSString * textDelante = @"LISTADO";
    _lblTitle.text = [NSString stringWithFormat:@"%@ DE %@",textDelante,[_tipoUsuario uppercaseString]];
    
    _topBar.backgroundColor = _searchBar.backgroundColor =  _searchBar.barTintColor = _lineTab.backgroundColor = _color;
    _searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShowNoData
{
    UILabel * lblNoHayDatos = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    lblNoHayDatos.text = @"No hay elementos para mostrar";
    [_scrollContainer addSubview:lblNoHayDatos];
    [lblNoHayDatos sizeToFit];
    [[GestorV getGV] centrarEnPadre:lblNoHayDatos];
}
-(void)LoadDatos
{
    while (_scrollContainer.subviews.count>0) {
        [_scrollContainer.subviews.firstObject removeFromSuperview];
    }
    if (arrDatos.count==0||arrDatos==nil) {
        [self ShowNoData];
        return;
    }
    
    float yMax = 0;
    for (int i = 0; i<arrDatos.count; i++) {
        
        ItemEstandar * vista = [[ItemEstandar alloc] initWithFrame:CGRectMake(0, yMax, self.view.frame.size.width, 71)];
         if ([_ACTION isEqualToString:@"SHOW_ALL_CLIENTS"]||[_ACTION isEqualToString:@"SHOW_PROMOTOR_CLIENTS"])
         {
             Cliente * c = [arrDatos objectAtIndex:i];
             [vista LoadDataForCliente:c];
         }
        else if ([_ACTION isEqualToString:@"SHOW_ADMIN_GERENTES"]||[_ACTION isEqualToString:@"SHOW_ALL_GERENTES"])
        {
            Gerente * c = [arrDatos objectAtIndex:i];
            [vista LoadDataForGerente:c];
        }
        else if ([_ACTION isEqualToString:@"SHOW_ALL_PROMOTORS"]||[_ACTION isEqualToString:@"SHOW_GERENTE_PROMOTORS"])
        {
            Promotor * p = [arrDatos objectAtIndex:i];
            [vista LoadDataForPromotor:p];
        }       
        
        vista.btnAction.tag = i;
        
        [vista.btnAction addTarget:self action:@selector(GotoController:) forControlEvents:UIControlEventTouchUpInside];
        //[vista PrepararParaCalendario:[arregloCalendario objectAtIndex:i]];
        [_scrollContainer addSubview:vista];
        yMax  = CGRectGetMaxY(vista.frame);
    }
    _scrollContainer.contentSize = CGSizeMake( CGRectGetWidth(_scrollContainer.frame),yMax+10 );
    yaSeListo = YES;
}
-(void)GotoController:(id)sender
{
    UIButton * btn = sender;
    int pos = (int)btn.tag;
   
    if ([_ACTION isEqualToString:@"SHOW_ALL_CLIENTS"]||[_ACTION isEqualToString:@"SHOW_PROMOTOR_CLIENTS"]) {
        PerfilDelClienteVC * vc = [[PerfilDelClienteVC alloc] initWithNibName:@"PerfilDelClienteVC" bundle:nil];
        Cliente * cliente = [arrDatos objectAtIndex:pos];
        vc.cliente = cliente;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_ACTION isEqualToString:@"SHOW_ADMIN_GERENTES"]||[_ACTION isEqualToString:@"SHOW_ALL_GERENTES"]) {
        PerfilGerenteVC * vc = [[PerfilGerenteVC alloc] initWithNibName:@"PerfilGerenteVC" bundle:nil];
        Gerente * gerente = [arrDatos objectAtIndex:pos];
        vc.gerente = gerente;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_ACTION isEqualToString:@"SHOW_ALL_PROMOTORS"]||[_ACTION isEqualToString:@"SHOW_GERENTE_PROMOTORS"]) {
        PerfilPromotorVC * vc = [[PerfilPromotorVC alloc] initWithNibName:@"PerfilPromotorVC" bundle:nil];
        Promotor * promotor = [arrDatos objectAtIndex:pos];
        vc.promotor = promotor;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    else
    {
        PerfilGeneralVC * vc = [[PerfilGeneralVC alloc] initWithNibName:@"PerfilGeneralVC" bundle:nil];
        vc.tipoUsuario = _tipoUsuario;
        vc.color = _color;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
    
}

//LOS TABS
-(void) LoadTabs
{
    
    if (_tabsArray.count==0) {
        _vistaTab.hidden = YES;
        [[GestorV getGV] setViewToBelwOf:_vistaTitulos guideView:_searchBar marginPorciento:0];
        [[GestorV getGV]setHeightOfView:_scrollContainer valor:self.view.frame.size.height-CGRectGetMaxY(_vistaTitulos.frame)];
        [[GestorV getGV] setViewToBelwOf:_scrollContainer guideView:_vistaTitulos marginPorciento:0];
    }
    else{
    float xMax = 0;
    for (int i = 0; i < _tabsArray.count; i++) {
        float ancho = self.view.frame.size.width/_tabsArray.count;
        UIButton * buttonTap = [[UIButton alloc] initWithFrame:CGRectMake(xMax, 0, ancho, _vistaTab.frame.size.height)];
        
        [buttonTap setTitle:[_tabsArray objectAtIndex:i] forState:UIControlStateNormal];
        [buttonTap setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
        [buttonTap setTitleColor:RGBCOLOR(142, 142, 142) forState:UIControlStateNormal];
        buttonTap.tag = i;
        [buttonTap addTarget:self action:@selector(ActiveTab:) forControlEvents:UIControlEventTouchUpInside];
        [_vistaTab addSubview:buttonTap];
        
        
        if (i == 0)
        {
            buttonSelected = buttonTap;
            [buttonTap setTitleColor:_color forState:UIControlStateNormal];
            [[GestorV getGV] setWidthOfView:_lineTab valor:buttonTap.frame.size.width];
            
        }
        xMax = CGRectGetMaxX(buttonTap.frame);
    }
    }
    
}

-(void) ActiveTab:(id)sender
{
    [buttonSelected setTitleColor:RGBCOLOR(142, 142, 142) forState:UIControlStateNormal];
    buttonSelected = sender;
   [buttonSelected setTitleColor:_color forState:UIControlStateNormal];
    int indiceTab = (int)buttonSelected.tag;
    indexTab = indiceTab;
    
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] setWidthOfView:_lineTab valor:buttonSelected.frame.size.width];
        [[GestorV getGV] alignViewInLeftOf:_lineTab guideView:buttonSelected porcentMargenLeft:0];
    } completion:^(BOOL finished)
     {
     
     }];
    
}

/*LOS DELEGADOS DE LA VISTA DE BUSQUEDA*/
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(IBAction)GoBack:(id)sender
{
    [GestorV GoBack:self];
}
@end
