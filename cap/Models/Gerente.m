//
//  Gerente.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/26/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "Gerente.h"

@implementation Gerente
- (void)fromDictionary:(NSMutableDictionary *)dict
{
    if([dict objectForKey:@"_id"]!=nil)
        _idGerente = [dict objectForKey:@"_id"];
    if([dict objectForKey:@"expediente"]!=nil)
        _expediente = [NSString stringWithFormat:@"%i",[[dict objectForKey:@"expediente"] intValue]];
    
    
    if([dict objectForKey:@"dir_trabajo"]!=nil)
        _direccionTrabajo = [dict objectForKey:@"dir_trabajo"];
    if([dict objectForKey:@"direccion"]!=nil)
        _direccion = [dict objectForKey:@"direccion"];
    
    if([dict objectForKey:@"telefono_f"]!=nil)
        _telefono = [dict objectForKey:@"telefono_f"];
    if([dict objectForKey:@"telefono_m"]!=nil)
        _telefonoMovil = [dict objectForKey:@"telefono_m"];
    if([dict objectForKey:@"salario"]!=nil)
        _salario = [dict objectForKey:@"salario"];
    
    
    Usuario * u = [Usuario new];
    NSMutableDictionary * dictUsuario = [dict valueForKey:@"id_usuario"];
    [u fromDictionary:dictUsuario];
    _datosUsuario = u;
    
}
@end
