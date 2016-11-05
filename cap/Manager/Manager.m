//
//  Manager.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 8/24/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "Manager.h"

@implementation Manager
static Manager *sharedPool = nil;
+ (Manager *) getM {
    @synchronized(self)
    {
        if (sharedPool == nil)
        {
              [[self alloc] init];
        }
    }
    
    return sharedPool;
}

@end
