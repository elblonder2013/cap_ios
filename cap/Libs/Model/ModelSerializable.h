//
//  ModelSerializable.h
//  Bariatrica
//
//  Created by baller on 6/4/14.
//  Copyright (c) 2014 baller. All rights reserved.
//

#import "JSONConverter.h"
#import "DictionarySerializable.h"
#import "Constants.h"

@interface ModelSerializable : NSObject <JSONSerializable, DictionarySerializable>

@end
