//
//  NSObject+ModelMapping.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import Foundation;

@interface NSObject (ModelMapping)

+ (NSDictionary *)sfl_objectMapping;

- (instancetype)sfl_setData:(NSDictionary *)dictionary;
- (NSDictionary *)sfl_inverseMapping;

@end