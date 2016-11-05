//
//  HomeSocioInversionistaVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/1/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "HomeSocioInversionistaVC.h"
#import "GestorV.h"
#import "ListadoBuscarVC.h"
#import "Common.h"
#import "PerfilGeneralVC.h"
@interface HomeSocioInversionistaVC ()
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
@end

@implementation HomeSocioInversionistaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgUsuario.clipsToBounds =  YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(255, 255, 255)];
    self.navigationController.navigationBar.hidden = YES;
    [self PrepararComponentes];
    
}
-(void)PrepararComponentes
{
    [[GestorV getGV] ConvertInCircle:_vistaClientes];
    [[GestorV getGV] ConvertInCircle:_vistaPromotores];
    [[GestorV getGV] ConvertInCircle:_vistaGerentes];
    [[GestorV getGV] ConvertInCircle:_vistaAplicaciones];
    _scrollContainer.contentSize = CGSizeMake(_scrollContainer.frame.size.width, CGRectGetMaxY(_vistaAplicaciones.frame)+20);
    
    //CARGANDO LOS TABS
}


- (IBAction)PickClientes:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(29, 185, 161);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"clientes";
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)PickPromotores:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(53, 152, 220);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"promotores";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pickGerentes:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(235, 171, 60);
    vc.tabsArray = @[];
    vc.tipoUsuario = @"gerentes";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pickAplicaciones:(id)sender {
    ListadoBuscarVC * vc = [[ListadoBuscarVC alloc] initWithNibName:@"ListadoBuscarVC" bundle:nil];
    vc.color = RGBCOLOR(248, 172, 43);
    vc.tabsArray = @[@"EMPRESARIALES",@"PERSONAL"];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
