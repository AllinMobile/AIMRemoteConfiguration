//
//  ConfigurableApiRequest.m
//  RemoteConfiguration
//
//  Created by Maciej Gad on 18.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import "ConfigurableApiRequest.h"

@interface ConfigurableApiRequest ()
@property (strong, nonatomic) NSString *path;
@end

@implementation ConfigurableApiRequest

- (instancetype)initWithPath:(NSString *)string {
    self = [super init];
    self.path = string;
    return self;
}

- (void)get {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.path] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (self.failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.failure(error);
                });
            }
            return;
        }
        if (error == nil) {
            id jsonRespone = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (self.success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.success(jsonRespone);
                });
            }
        }
    }];
    [task resume];
}

@end
