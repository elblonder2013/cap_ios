//
//  Usuario.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSerializable.h"
@interface Usuario : ModelSerializable
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *fecha_nac;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fecha_ultimo_acc;

@property (nonatomic, strong) NSArray *idRoles;

@property (nonatomic) BOOL bloqueado;
- (void)fromDictionary:(NSMutableDictionary *)dict;
@end
