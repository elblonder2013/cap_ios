//
//  ItemEstandar.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/1/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cliente.h"
#import "Gerente.h"
#import "Promotor.h"
@interface ItemEstandar : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblInicial;
@property (weak, nonatomic) IBOutlet UILabel *lblTopValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomvalue;
@property (weak, nonatomic) IBOutlet UILabel *lblRightValue;
@property (weak, nonatomic) IBOutlet UILabel *lblRightBottomValue;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
-(void)LoadDataForCliente:(Cliente *)cliente;
-(void)LoadDataForGerente:(Gerente *)gerente;
-(void)LoadDataForPromotor:(Promotor *)promotor;
-(void)LoadDataForHistorialCliente:(NSDictionary *)dict;
@end
