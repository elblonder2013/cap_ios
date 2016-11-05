//
//  Gerente.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/26/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSerializable.h"
#import "Usuario.h"

@interface Gerente : ModelSerializable
@property (nonatomic, strong) NSString *idGerente;
@property (nonatomic, strong) NSString *expediente;
@property (nonatomic, strong) Usuario * datosUsuario;
@property (nonatomic, strong) NSString *direccion;
@property (nonatomic, strong) NSString *direccionTrabajo;
@property (nonatomic, strong) NSString *telefono;
@property (nonatomic, strong) NSString *telefonoMovil;
@property (nonatomic, strong) NSString * salario;
- (void)fromDictionary:(NSMutableDictionary *)dict;

@end
