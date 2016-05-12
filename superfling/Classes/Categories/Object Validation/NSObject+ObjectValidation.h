//
//  NSObject+ObjectValidation.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.


@import Foundation;

@interface NSObject (ObjectValidation)

- (BOOL)sfl_isValidObject;
- (BOOL)sfl_isValidString;

@end