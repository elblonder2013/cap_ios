//
//  ModelSerializable.m
//  Bariatrica
//
//  Created by baller on 6/4/14.
//  Copyright (c) 2014 baller. All rights reserved.
//

#import "ModelSerializable.h"

@implementation ModelSerializable

+(id)fromData:(NSData *)data
{
    NSMutableDictionary *dict = [NSMutableDictionary fromData:data];
    return [self fromDictionary:dict];
}

-(NSData *)toJSON
{
    return [[self toDictionary] toJSON];
}

+ (id)fromDictionary:(NSMutableDictionary *)dict
{
    return nil;
}

- (NSMutableDictionary *)toDictionary
{
    return nil;
}
@end
