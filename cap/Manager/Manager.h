//
//  Manager.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"
@interface Manager : NSObject
{
    
}
+ (Manager *) getM;

@property ( nonatomic) BOOL isLogguedUser;
@property ( nonatomic) NSString * token;
@property ( nonatomic) NSString * uid;
@property ( nonatomic) NSString * rolId;
@property ( nonatomic) NSString * rol;
@property ( nonatomic) Usuario * user;
@property ( nonatomic) NSObject * userAutenticado;
@end
