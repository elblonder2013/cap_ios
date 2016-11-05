//
//  HomeUsuario.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/1/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "HomeUsuario.h"
#import "GestorV.h"
#import "Common.h"
#import "ItemEstandar.h"

@interface HomeUsuario ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *btnActionTop;
@property (weak, nonatomic) IBOutlet UIView *menuLateral;
@property (weak, nonatomic) IBOutlet UIButton *btnBlack;
@property (weak, nonatomic) IBOutlet UIImageView *imgUsuario;


@property (weak, nonatomic) IBOutlet UILabel *lblHistorial;

@property (weak, nonatomic) IBOutlet UILabel *lblGanancia;
@property (weak, nonatomic) IBOutlet UIView *lineTab;

@property (weak, nonatomic) IBOutlet UIButton *btnIconHistorial;
@property (weak, nonatomic) IBOutlet UIButton *btnIconGanacia;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainerGanancias;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContainerHistorial;

@property (weak, nonatomic) IBOutlet UIView *vistaHistorial;



@end

@implementation HomeUsuario

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self PrepararComponentes];
    [self loadHistorialInScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)PrepararComponentes
{
    _scrollContainer.delegate = self;
    _imgUsuario.clipsToBounds =  YES;
    [[GestorV getGV] ConvertInCircle:_imgUsuario];
    [[GestorV getGV] ConvertirEnAnillo:_imgUsuario borderWidth:2 color:RGBCOLOR(255, 255, 255)];
    [[GestorV getGV] setWidthOfView:_lineTab valor:self.view.frame.size.width/2]
    ;
    
    [[GestorV getGV] setWidthFillParent:_scrollContainer];
    [[GestorV getGV] setWidthFillParent:_vistaHistorial];
    [[GestorV getGV] setWidthFillParent:_scrollContainerHistorial];
    _scrollContainer.pagingEnabled = YES;
    [[GestorV getGV] setViewToRightOf:_vistaHistorial guideView:_scrollContainerGanancias marginPorciento:0];
    
    _scrollContainer.contentSize = CGSizeMake(CGRectGetMaxX(_vistaHistorial.frame), _scrollContainer.frame.size.height);
}


#pragma mark - ACCIONES
- (IBAction)pickTab1:(id)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] aliniarInzquierda:_lineTab porcentMargenLeft:0];
        _lblGanancia.textColor = _btnIconGanacia.tintColor = _lineTab.backgroundColor;
       _btnIconHistorial.tintColor =  _lblHistorial.textColor = RGBCOLOR(115, 115, 155);
    } completion:^(BOOL finished)
     {
         
     }];
}
- (IBAction)pickTab2:(id)sender {
    [_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] aliniarDerecha:_lineTab porcentMargenWidth:0];
        _lblHistorial.textColor = _btnIconHistorial.tintColor = _lineTab.backgroundColor;
       _lblGanancia.textColor =  _btnIconGanacia.tintColor = RGBCOLOR(115, 115, 155);
        
        
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
                _lblGanancia.textColor = _btnIconGanacia.tintColor = _lineTab.backgroundColor;
                _btnIconHistorial.tintColor = _lblHistorial.textColor = RGBCOLOR(119, 119, 119);
            } completion:^(BOOL finished)
             {
                 
             }];
        }
        else if (newx==1)
        {
            //[_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [[GestorV getGV] centrarHorizontal:_lineTab];
                _lblHistorial.textColor = _btnIconHistorial.tintColor = _lineTab.backgroundColor;
                _lblGanancia.textColor = _btnIconGanacia.tintColor = RGBCOLOR(119, 119, 119);
                
                
            } completion:^(BOOL finished)
             {
                 
             }];
        }
        else if (newx==2)
        {
            //[_scrollContainer setContentOffset:CGPointMake(960, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [[GestorV getGV] aliniarDerecha:_lineTab porcentMargenWidth:0];
                               _btnIconHistorial.tintColor = _btnIconGanacia.tintColor = _lblHistorial.textColor = _lblGanancia.textColor = RGBCOLOR(119, 119, 119);
            } completion:^(BOOL finished)
             {
                 
             }];
            
        }
    }
}



#pragma mark - MENU LATERAL

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


#pragma mark - FUNCIONES NECESARIAS
-(void)loadHistorialInScroll
{
    while (_scrollContainerHistorial.subviews.count>0) {
        [_scrollContainerHistorial.subviews.lastObject removeFromSuperview];
    }
    float yMax = 0;
    for (int i = 0; i<15; i++) {
        
        ItemEstandar * vista = [[ItemEstandar alloc] initWithFrame:CGRectMake(0, yMax, self.view.frame.size.width, 71)];
        vista.btnAction.tag = i;
        
        [vista.btnAction addTarget:self action:@selector(GotoController:) forControlEvents:UIControlEventTouchUpInside];
        //[vista PrepararParaCalendario:[arregloCalendario objectAtIndex:i]];
        [_scrollContainerHistorial addSubview:vista];
        yMax  = CGRectGetMaxY(vista.frame);
    }
    _scrollContainerHistorial.contentSize = CGSizeMake( CGRectGetWidth(_scrollContainerHistorial.frame),yMax+10 );
}


@end
