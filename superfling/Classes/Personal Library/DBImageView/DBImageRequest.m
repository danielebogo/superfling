//
//  DBImageRequest.m
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import "DBImageRequest.h"
#import "DBImageViewCache.h"

@interface DBImageRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) BOOL ended;
@property (nonatomic, copy) DBRequestSuccessHandler successHandler;
@property (nonatomic, copy) DBRequestErrorHandler errorHandler;

@end

@implementation DBImageRequest


- (instancetype)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if ( self ) {
        _request = request;
    }
    return self;
}

- (void)dealloc
{
	[_connection cancel];
}


#pragma mark - Public methods

- (void)downloadImageWithSuccess:(DBRequestSuccessHandler)success error:(DBRequestErrorHandler)error
{
    _successHandler = success;
	_errorHandler = error;
	_receivedData = [NSMutableData data];
	_connection = [NSURLConnection connectionWithRequest:_request delegate:self];
}

- (void)cancel
{
    [self db_endWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}


#pragma mark - Private methods

- (void)db_requestDidEnd
{
    [_connection cancel];
    
    _successHandler = nil;
    _errorHandler = nil;
    _response = nil;
    _receivedData = nil;
}

- (void)db_endWithError:(NSError *)error
{
    if (_ended) {
        return;
    }
    
    _ended = YES;
    
    if (error) {
        if (_errorHandler) {
            (_errorHandler)(error);
        }
    } else {
        if (_successHandler) {
            [[DBImageViewCache cache] saveImageFromName:_request.URL.absoluteString data:_receivedData];
            _successHandler([[UIImage alloc] initWithData:_receivedData], _response);
        }
    }
    
    [self db_requestDidEnd];
}


#pragma mark - NSURLConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self db_endWithError:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self db_endWithError:error];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    if (redirectResponse) {
        NSURL *newURL = [request URL];
        NSMutableURLRequest *newRequest = [_request mutableCopy];
        [newRequest setURL:newURL];
        return newRequest;
    } else {
        return request;
    }
}


@end