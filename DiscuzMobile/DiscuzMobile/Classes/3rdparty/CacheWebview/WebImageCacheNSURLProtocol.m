//
//  WebImageCacheNSURLProtocol.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/17.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "WebImageCacheNSURLProtocol.h"

static NSString *WebImageCacheURLProtocolHandledKey1 = @"WebImageCacheURLProtocolHandledKey";

@implementation WebImageCacheNSURLProtocol
/*
 （1）.处理返回YES，不处理返回NO
 （2）.打标签，已经处理过的不在处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    NSString *url = self.request.URL.absoluteString;
    
    if ([url containsString:@".jpg"] || [url containsString:@".jpeg"] || [url containsString:@".png"])  {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:url];
            
            if (image) {
                //            [SDWebImageCodersManager sharedManager]
                //            [SDWebImageCodersManager sharedManager] saveImageToCache:<#(nullable UIImage *)#> forURL:<#(nullable NSURL *)#>
                //            NSData *data = [[SDWebImageCodersManager sharedManager] encodedDataWithImage:image format:SDImageFormatUndefined];
                NSData *data = UIImagePNGRepresentation(image);
                NSURLResponse *res = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/*;q=0.8" expectedContentLength:data.length textEncodingName:nil];
                
                [self.client URLProtocol:self didReceiveResponse:res cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                [self.client URLProtocol:self didLoadData:data];
                [self.client URLProtocolDidFinishLoading:self];
            } else {
                
                //request处理过的放进去
                [NSURLProtocol setProperty:@YES forKey:WebImageCacheURLProtocolHandledKey1 inRequest:mutableReqeust];
                
                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:self.request.URL options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                    if (error) {
                        [self.client URLProtocol:self didFailWithError:error];
                    } else {
                        [[SDWebImageManager sharedManager].imageCache storeImageDataToDisk:data forKey:url];
                        
                        NSURLResponse *res = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/*;q=0.8" expectedContentLength:data.length textEncodingName:nil];
                        [self.client URLProtocol:self didReceiveResponse:res cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                        [self.client URLProtocol:self didLoadData:data];
                        [self.client URLProtocolDidFinishLoading:self];
                    }
                    
                }];
            }
        });
    }
}

@end
