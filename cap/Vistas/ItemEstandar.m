//
//  ItemEstandar.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/1/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "ItemEstandar.h"
#import "GestorV.h"



@implementation ItemEstandar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ItemEstandar"
                                              owner:self options:nil]
                objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        _lblInicial.clipsToBounds = _lblRightBottomValue.clipsToBounds = YES;
        [[GestorV getGV] ConvertInCircle:_lblInicial];
        [[GestorV getGV] ConvertInCircle:_lblRightBottomValue];
        
    }
    
    return self;
}
-(void)LoadDataForCliente:(Cliente *)cliente
{
    _lblTopValue.text = cliente.datosUsuario.fullname;
    _lblInicial.text = @"A";
}
-(void)LoadDataForGerente:(Gerente *)gerente
{
    _lblTopValue.text = gerente.datosUsuario.fullname;
    _lblInicial.text = @"A";
}
-(void)LoadDataForPromotor:(Promotor *)promotor
{
    _lblTopValue.text = promotor.datosUsuario.fullname;
    _lblInicial.text = @"A";
}
-(void)LoadDataForHistorialCliente:(NSDictionary *)dict
{
    [[GestorV getGV] alignViewInTopOf:_lblRightValue guideView:_lblTopValue porcentMargenTop:0];
    _lblRightBottomValue.hidden = NO;
}

@end
