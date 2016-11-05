//
//  Cliente.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/25/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSerializable.h"
#import "Usuario.h"

@interface Cliente : ModelSerializable
@property (nonatomic, strong) NSString *idCliente;
@property (nonatomic, strong) NSString *expediente;
@property (nonatomic, strong) Usuario * datosUsuario;
- (void)fromDictionary:(NSMutableDictionary *)dict;
@end
