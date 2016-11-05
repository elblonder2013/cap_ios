//
//  Usuario.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario
- (void)fromDictionary:(NSMutableDictionary *)dict
{
    if([dict objectForKey:@"_id"]!=nil)
        _Id = [dict objectForKey:@"_id"];
    if([dict objectForKey:@"avatar"]!=nil)
        _avatar = [dict objectForKey:@"avatar"];
    if([dict objectForKey:@"fecha_nac"]!=nil)
        _fecha_nac = [dict objectForKey:@"fecha_nac"];
    if([dict objectForKey:@"email"]!=nil)
        _email = [dict objectForKey:@"email"];
    if([dict objectForKey:@"fullname"]!=nil)
        _fullname = [dict objectForKey:@"fullname"];
    if([dict objectForKey:@"name"]!=nil)
        _name = [dict objectForKey:@"name"];    
    if([dict objectForKey:@"fecha_ultimo_acc"]!=nil)
        _fecha_ultimo_acc = [dict objectForKey:@"fecha_ultimo_acc"];
    if([dict objectForKey:@"idRoles"]!=nil)
        _idRoles = [dict objectForKey:@"idRoles"];
    if([dict objectForKey:@"bloqueado"]!=nil)
        _bloqueado = [[dict objectForKey:@"bloqueado"] boolValue];
    
  
   
}
@end
