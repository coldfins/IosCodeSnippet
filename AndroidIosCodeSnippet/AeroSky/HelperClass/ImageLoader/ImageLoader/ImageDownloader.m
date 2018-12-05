
#import "ImageDownloader.h"
//#import "ImageModel.h"

#import "HouseCheap-swift.h"

#define kAppIconSize 50

@interface ImageDownloader ()

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end


@implementation ImageDownloader

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
  //  NSLog(@"image url in icon download.%@",self.objImages.imageURLString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.objImages.imageURLString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}
#pragma end

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // NSLog(@"image  in down loader data...%@",data);
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   //  NSLog(@"image  in down loader error...%@",error);
    
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set userImage and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    self.objImages.itemImage = image;
   // NSLog(@"image  in down loader...%@",image);
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}
#pragma end

@end

