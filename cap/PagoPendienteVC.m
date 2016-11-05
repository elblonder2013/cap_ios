//
//  PagoPendienteVC.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/25/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "PagoPendienteVC.h"
#import "GestorV.h"
#import "Common.h"
@interface PagoPendienteVC ()
{
    UIButton * buttonSelected;
    int indexTab;
    UIColor * color;
}

@property (weak, nonatomic) IBOutlet UIView *lineTab;
@property (weak, nonatomic) IBOutlet UIButton * btnTab1;
@property (weak, nonatomic) IBOutlet UIButton * btnTap2;
@property (weak, nonatomic) IBOutlet UIScrollView * scrollContainer;
@property (weak, nonatomic) IBOutlet UIScrollView * scroll1;
@property (weak, nonatomic) IBOutlet UIScrollView * scroll2;
@property (weak, nonatomic) IBOutlet UIButton * btnRealizarPago;
@property (weak, nonatomic) IBOutlet UIView *lastView1;
@property (weak, nonatomic) IBOutlet UIView *lastView2;

//RECIBO DEL PROMOTOR
@property (weak, nonatomic) IBOutlet UILabel *lblReciboDelPromotor;

@property (weak, nonatomic) IBOutlet UILabel *lblReciboTipoPago;
@property (weak, nonatomic) IBOutlet UILabel *lblReciboCantidadAPagar;
@property (weak, nonatomic) IBOutlet UILabel *lblReciboFechaDepago;
@property (weak, nonatomic) IBOutlet UILabel *lblReciboPersonalEjecuta;
@property (weak, nonatomic) IBOutlet UILabel *lblReciboNumeroIdentificacion;
@property (weak, nonatomic) IBOutlet UIButton *btnReciboAceptar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollRecibo;
@property (weak, nonatomic) IBOutlet UIView *vistaRecibo;
@end

@implementation PagoPendienteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    color = RGBCOLOR(29, 185, 161);
    buttonSelected = _btnTab1;
    [[GestorV getGV] ConvertInCircle:_btnRealizarPago];
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_lastView1 scroll:_scroll1 bottomSpacing:0];
     [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_lastView2 scroll:_scroll2 bottomSpacing:0];
    
    //preparando el recibo
    [[GestorV getGV] setContentSizeToScrollWithBottomOfView:_btnReciboAceptar scroll:_scrollRecibo bottomSpacing:10];
    [[GestorV getGV] ConvertInCircle:_btnReciboAceptar];
    _lblReciboDelPromotor.clipsToBounds = YES;
    [[GestorV getGV] ConvertInCircle:_lblReciboDelPromotor];
}
-(IBAction) ActiveTab:(id)sender
{
    [buttonSelected setTitleColor:RGBCOLOR(142, 142, 142) forState:UIControlStateNormal];
    buttonSelected = sender;
    [buttonSelected setTitleColor:color forState:UIControlStateNormal];
    int indiceTab = (int)buttonSelected.tag;
    indexTab = indiceTab;
   
    
    [UIView animateWithDuration:0.3 animations:^{
        [[GestorV getGV] setWidthOfView:_lineTab valor:buttonSelected.frame.size.width];
        [[GestorV getGV] alignViewInLeftOf:_lineTab guideView:buttonSelected porcentMargenLeft:0];
    } completion:^(BOOL finished)
     {
         if (buttonSelected.tag==1) {
             [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
         }
         else
         {
             [_scrollContainer setContentOffset:CGPointMake(320, 0) animated:YES];
             
         }
     }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RealizarPago:(id)sender {
    _vistaRecibo.hidden = NO;
}
- (IBAction)AceptarReciboDePago:(id)sender {
    _vistaRecibo.hidden = YES;
}
- (IBAction)EnviarPDFPorCorreo:(id)sender {
    _vistaRecibo.hidden = YES;
}
- (IBAction)GOBACK:(id)sender {
    [GestorV GoBack:self ];
}

@end
