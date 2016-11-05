//
//  Admin.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSerializable.h"
#import "Usuario.h"

@interface Admin : ModelSerializable
- (void)fromDictionary:(NSMutableDictionary *)dict;
@property (nonatomic, strong) NSString * idAdministrador;
@property (nonatomic, strong) NSString * dirTrabajo;
@property (nonatomic, strong) NSString * direccion;
@property (nonatomic, strong) NSString * salario;
@property (nonatomic, strong) Usuario * datosUsuario;
@end
