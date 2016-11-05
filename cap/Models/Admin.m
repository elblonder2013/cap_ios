//
//  Admin.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "Admin.h"

@implementation Admin
- (void)fromDictionary:(NSMutableDictionary *)dict
{
    if([dict objectForKey:@"_id"]!=nil)
        _idAdministrador = [dict objectForKey:@"_id"];
    if([dict objectForKey:@"dir_trabajo"]!=nil)
        _dirTrabajo = [dict objectForKey:@"dir_trabajo"];
    if([dict objectForKey:@"direccion"]!=nil)
        _direccion = [dict objectForKey:@"direccion"];
    if([dict objectForKey:@"salario"]!=nil)
        _salario = [dict objectForKey:@"salario"];
    Usuario * u = [Usuario new];
    NSMutableDictionary * dictUsuario = [dict valueForKey:@"id_usuario"];
    [u fromDictionary:dictUsuario];
    _datosUsuario = u;
}
@end
