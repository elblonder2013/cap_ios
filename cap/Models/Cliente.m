//
//  Cliente.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/25/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "Cliente.h"

@implementation Cliente
- (void)fromDictionary:(NSMutableDictionary *)dict
{
    if([dict objectForKey:@"_id"]!=nil)
        _idCliente = [dict objectForKey:@"_id"];
    if([dict objectForKey:@"expediente"]!=nil)
        _expediente = [NSString stringWithFormat:@"%i",[[dict objectForKey:@"expediente"] intValue]];
   
    Usuario * u = [Usuario new];
    NSMutableDictionary * dictUsuario = [dict valueForKey:@"id_usuario"];
    [u fromDictionary:dictUsuario];
    _datosUsuario = u;
    
}
@end
