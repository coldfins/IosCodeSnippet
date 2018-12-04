//
//  ImageModel.h
//  MusicMaprApplication
//
//  Created by Coldfin Lab on 2/27/14.
//  Copyright (c) 2014 ved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import UIKit;

@interface ImageModel : NSObject

//image downloading
@property (nonatomic, retain) UIImage *itemImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURLString;

@end
