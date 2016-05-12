//
//  DBImageView.m
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import "DBImageView.h"
#import "DBImageRequest.h"
#import "DBImage.h"
#import "DBImageViewCache.h"


static BOOL DBImageShouldDownload = YES;
static NSString *const kDBImageViewShouldStartDownload = @"kDBImageViewShouldStartDownload";

@interface DBImageView () {
    DBImageRequest *_currentRequest;
    UIImageView *_imageView;
    UIActivityIndicatorView *_spinner;
}

@property (nonatomic, strong) DBImage *remoteImage;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end


@implementation DBImageView


#pragma mark - Factory Methods

+ (void)clearCache
{
    [[DBImageViewCache cache] clearCache];
}

+ (void)triggerImageRequests:(BOOL)start
{
    if (start != DBImageShouldDownload) {
		DBImageShouldDownload = start;
		
        if (start) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kDBImageViewShouldStartDownload object:nil];
        }
	}
}


#pragma mark - Life cicle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self db_buildUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self db_buildUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self db_buildUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currentRequest cancel];
}


#pragma mark - Override Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _spinner.center = (CGPoint){ CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) };
}

- (void)setClipsToBounds:(BOOL)clipsToBounds
{
    [super setClipsToBounds:clipsToBounds];

    [_imageView setClipsToBounds:clipsToBounds];
}

- (void) setContentMode:(UIViewContentMode)contentMode
{
    _imageView.contentMode = contentMode;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (void)setPlaceHolder:(UIImage *)placeHolder
{
    if (![placeHolder isEqual:_placeHolder]) {
        
        _placeHolder = placeHolder;
        _imageView.image = placeHolder;
    }
}

- (void)setImageViewcontentMode:(UIViewContentMode)imageViewcontentMode
{
    _imageView.contentMode = imageViewcontentMode;
}

- (void)setRemoteImage:(DBImage *)remoteImage
{
    if (remoteImage != _remoteImage) {
        [_currentRequest cancel];
        _currentRequest = nil;
        
        _remoteImage = remoteImage;
        
        if ( _placeHolder ) {
            _imageView.image = _placeHolder;
        } else {
            _imageView.image = nil;
        }
        
        [self db_startDownloadImage];
    }
}

- (void)setImageWithPath:(NSString *)imageWithPath
{
    if ([_imageWithPath isEqualToString:imageWithPath]) {
        return;
    }
    
    _imageWithPath = imageWithPath;
    
    [self setRemoteImage:[DBImage imageWithPath:_imageWithPath]];
}

- (UIActivityIndicatorView *)spinner
{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.translatesAutoresizingMaskIntoConstraints = NO;
        _spinner.hidesWhenStopped = YES;
        _spinner.hidden = YES;
    }
    return _spinner;
}


#pragma mark - Private Methods

- (void)db_buildUI
{
    self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
 
    _imageView = [[UIImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_imageView];
    [self addSubview:self.spinner];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|"
                                                                 options:0 metrics:nil views:@{ @"_imageView":_imageView }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|"
                                                                 options:0 metrics:nil views:@{ @"_imageView":_imageView }]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(db_shouldStartDownload:) name:kDBImageViewShouldStartDownload object:nil];
}


#pragma mark - Private Methods

- (void)db_stopSpinner
{
	[self.spinner stopAnimating];
	
    self.spinner.hidden = YES;
}

- (void)db_shouldStartDownload:(NSNotification *)notification
{
    [self db_startDownloadImage];
}

- (void)db_startDownloadImage
{
    if (_currentRequest) {
        return;
    }
    
    if (!_remoteImage) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[DBImageViewCache cache] imageForURL:_remoteImage.imageURL found:^(UIImage *image) {
        __strong typeof(weakSelf) blockSelf = weakSelf;
        blockSelf->_imageView.image = image;
        
    } notFound:^{
        __strong typeof(weakSelf) blockSelf = weakSelf;
        
        if (!DBImageShouldDownload) {
            return;
        }
        
        [blockSelf.spinner startAnimating];
        blockSelf.spinner.hidden = NO;

        blockSelf->_currentRequest = _remoteImage.imageRequest;
        [blockSelf->_currentRequest downloadImageWithSuccess:^(UIImage *image, NSHTTPURLResponse *response) {
            [blockSelf db_stopSpinner];
            
            blockSelf->_imageView.image = image;
            blockSelf->_currentRequest = nil;
            blockSelf->_imageWithPath = nil;
        } error:^(NSError *error) {
            [blockSelf db_stopSpinner];
            
            blockSelf->_currentRequest = nil;
            blockSelf->_imageWithPath = nil;
        }];
    }];
}


@end
