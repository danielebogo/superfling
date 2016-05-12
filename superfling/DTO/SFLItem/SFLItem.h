//
//  SFLItem.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "NSObject+ModelMapping.h"


@interface SFLItem : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *itemId;
@property (nullable, nonatomic, retain) NSNumber *imageId;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *userName;

@property (nullable, nonatomic, strong) NSString *imagePath;

@end
