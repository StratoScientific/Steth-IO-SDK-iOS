//
//  GraphSnapshot.h
//  StethIO
//
//  Created by naveen on 22/03/22.
//  Copyright © 2022 StethIO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "CoreGraphics/CoreGraphics.h"
#import "GLStethView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GraphSnapshot : NSObject
+(UIImage*)antialiasedHighResImage:(glsteth_obj*)obj
                              size:(CGSize)inSize
                         startTime:(double)startTime
                           endTime:(double)endTime
                          isHeart:(BOOL)isHeart;

@end

NS_ASSUME_NONNULL_END
