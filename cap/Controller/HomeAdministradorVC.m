//
//  HomeAdministradorVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/27/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "HomeAdministradorVC.h"
#import "GestorV.h"
#import "ListadoBuscarVC.h"
#import "Common.h"
#import "PerfilGeneralVC.h"
#import "LoadingView.h"
#import "ASIHTTPRequest.h"
#import "RequestManager.h"
#import "SBJsonParser.h"
#import "Admin.h"
#import "PerfilAdminVCViewController.h"
#import "Util.h"
@interface HomeAdministradorVC ()
{
    BOOL perfilLoaded;
    Admin * admin;
}
@property (weak, nonatomic) IBOutlet UIView *vistaClientes;
@property (weak, nonatomic) IBOutlet UIView *vistaPromotores;
@property (weak, nonatomic) IBOutlet UIView *vistaGerentes;
@property (weak, nonatomic) IBOutlet UIView *vistaAplicaciones;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *btnActionTop;
@property (weak, nonatomic) IBOutlet UIView *menuLateral;
@property (weak, nonatomic) IBOutlet UIButton *btnBlack;
@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@end

@implementation HomeAdministradorVC

-(void)GetPhotoPerfil:(NSString *)imageUrl
{
    NSArray * arr = [imageUrl componentsSeparatedByString:@"/"];
    NSString * nombreImagen = arr.lastObject;
    NSString* pathToImage = [Util existResource:nombreImagen];
    
    if (![pathToImage isEqualToString:@""])
    {
        UIImage* imgEvent = [UIImage imageWithContentsOfFile:pathToImage];
        _imgUsuario.image = [Util imageForImageView:imgEvent sizeImage:imgEvent.size sizeImageView:_imgUsuario.frame.size];
        
        _imgUsuario.image = imgEvent;
        
        //[CommonsUtils getCommonUtil].avatarDataLoaded = YES;
    }
    else
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *imgData = [NSData dataWithContentsOfURL:url];
            
            if(imgData!=nil)
            {
                UIImage* imgUser = [UIImage imageWithData:imgData];
                NSMutableData* dataMutable = [NSMutableData dataWithData:imgData];
                [Util saveResource:nombreImagen withData:dataMutable];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _imgUsuario.image = [Util imageForImageView:imgUser sizeImage:imgUser.size sizeImageView:_imgUsuario.frame.size];
                    
                    
                    // [CommonsUtils getCommonUtil].avatarDataLoaded = YES;
                });
            }
            else
            {
                
                //_ivAvatar.image = [UIImage imageNamed:@"avatar.png"];
            }
        });
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    perfilLoaded = NO;
        self.navigationController.navigationBar.hidden = YES;
    [self PrepararComponentes];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (perfilLoaded==NO) {
        [self PrepareRequestToGetPerfilData];
    }
}
-(void)PrepareRequestToGetPerfilData
{
    //mandando a descargar la foto de perfil    
    RequestManager* rm = [RequestManager sharedInstance];
    ASIHTTPRequest* request = [rm prepareRequestToAdminDataWithToken:[GestorV getGV].token idUsuario:[GestorV getGV].uid];
    [request setDelegate:self];
    request.tag = 1;//opteeniendo los upcomings events
    [request startAsynchronous];

}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [LoadingView hideLoadingView:self.navigationController.view];
    [[GestorV getGV] ShowError:@"Network error..." vistaControlador:self.navigationController];
    
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
            [LoadingView hideLoadingView:self.navigationController.view];
            [[GestorV getGV] ShowError:@"Server internal error" vistaControlador:self.navigationController];
            return;
        }
        
        if (request.tag==1) {
            //todo correcto
            admin = [Admin new];
            [admin fromDictionary:responseDictionary];
            [GestorV getGV].userAutenticado = admin;
            [self InitializeData];
            perfilLoaded = YES;
            
        }
        
        
    }
    else
    {
        [LoadingView hideLoadingView:self.navigationController.view];
        [[GestorV getGV] ShowError:@"Network failed" vistaControlador:self.navigationController];
        //error de conexion
    }
}
-(void)InitializeData
{
    _lblNombre.text = [GestorV getGV].user.fullname;
    if (admin!=nil&&(![admin.datosUsuario.avatar isEqualToString:@""])) {
        NSString * avatarUrl = admin.datosUsuario.avatar;
        NSString * urlDescargar = [NSString stringWithFormat:@"%@/%@/%@",WebUrlPateon,@"avatars",avatarUrl];
        [self GetPhotoPerfil:urlDescargar];
    }
    
}

/*LA NAVEGACION*/
- (IBAction)GoToPerfilAdmin:(id)sender {
    [self HideMenu];
    PerfilAdminVCViewController * vc = [[PerfilAdminVCViewController alloc] initWithNibName:@"PerfilAdminVCViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)GoToinicio:(id)sender {
    [self HideMenu];
}
- (IBAction)GoToListadoGerente:(id)sender {
    [self HideMenu];
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(235, 171, 60);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"gerentes";
    vc.ACTION = @"SHOW_ADMIN_GERENTES";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)GotoValorar:(id)sender {
}
- (IBAction)Compartir:(id)sender {
}
- (IBAction)GotoAcercaDe:(id)sender {
}








-(void)PrepararComponentes
{
    _imgUsuario.clipsToBounds =  YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(255, 255, 255)];

    [[GestorV getGV] ConvertInCircle:_vistaClientes];
    [[GestorV getGV] ConvertInCircle:_vistaPromotores];
    [[GestorV getGV] ConvertInCircle:_vistaGerentes];
    [[GestorV getGV] ConvertInCircle:_vistaAplicaciones];
    _scrollContainer.contentSize = CGSizeMake(_scrollContainer.frame.size.width, CGRectGetMaxY(_vistaAplicaciones.frame)+20);
}

- (IBAction)PickClientes:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(29, 185, 161);
     vc.tabsArray = @[];
    vc.tipoUsuario = @"clientes";
    vc.ACTION = @"SHOW_ALL_CLIENTS";
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)PickPromotores:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(53, 152, 220);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"promotores";
    vc.ACTION = @"SHOW_ALL_PROMOTORS";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pickGerentes:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(235, 171, 60);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"gerentes";
    vc.ACTION = @"SHOW_ALL_GERENTES";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pickAplicaciones:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(248, 172, 43);
    vc.tabsArray = @[@"EMPRESARIALES",@"PERSONAL"];
     vc.ACTION = @"SHOW_ALL_APPLICATION";
    vc.tipoUsuario = @"aplicaciones";
    [self.navigationController pushViewController:vc animated:YES];
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
- (IBAction)ActionBlackButton:(id)sender
{
    [self HideMenu];
    
}
- (IBAction)ActionTop:(id)sender {
    if (_btnBlack.hidden==YES) {
        [self ShowMenu];
    }
    else
    {
        [self HideMenu];
    }
    
}
- (IBAction)CerrarSesion:(id)sender {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) showLogin:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
