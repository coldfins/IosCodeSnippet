#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Foundation;
@import UIKit;

@class ImageModel;


@interface ImageDownloader : NSObject

@property (nonatomic, strong) ImageModel *objImages;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
