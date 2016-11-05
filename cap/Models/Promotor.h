//
//  Promotor.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/26/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSerializable.h"
#import "Usuario.h"

@interface Promotor : NSObject
@property (nonatomic, strong) NSString *idPromotor;
@property (nonatomic, strong) NSString *telefonoMovil;
@property (nonatomic, strong) NSString *telefonoFijo;
@property (nonatomic, strong) NSString *dirTrabajo;
@property (nonatomic, strong) NSString *direccion;
@property (nonatomic, strong) NSString *salario;
@property (nonatomic, strong) NSString *expediente;
@property (nonatomic, strong) Usuario * datosUsuario;

- (void)fromDictionary:(NSMutableDictionary *)dict;
@end
