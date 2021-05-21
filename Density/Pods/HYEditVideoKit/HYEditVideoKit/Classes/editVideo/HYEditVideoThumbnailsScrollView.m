//
//  HYEditVideoThumbnailsScrollView.m
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/3/31.
//

#import "HYEditVideoThumbnailsScrollView.h"
#import "HYEditVideoThumbnail.h"
#import "HYUtilsMacro.h"
@interface HYEditVideoThumbnailsScrollView ()

@property (strong, nonatomic) NSArray      *thumbnails;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HYEditVideoThumbnailsScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

- (void)updateThumbnailsView:(NSArray *)thumbnails totalTime:(double)totalTime {

    self.thumbnails = thumbnails;
    
//    CGSize size = [(UIImage *)[[self.thumbnails firstObject] image] size];

    
    CGFloat _sliderLeftRight_w = 31;
    CGFloat currentX = _sliderLeftRight_w;

    CGFloat size_w = (KHYScreenWidth - 2*_sliderLeftRight_w)/10;// 图片的宽度是余下的10等份
    CGFloat size_h = 60;
    
    CGSize imageSize = CGSizeMake(size_w, size_h);
    CGRect imageRect = CGRectMake(currentX, 0, imageSize.width, imageSize.height);
    CGFloat imageWidth = CGRectGetWidth(imageRect) * self.thumbnails.count + 2*currentX;
    
    self.scrollView.contentSize = CGSizeMake(imageWidth, 0);

    for (NSUInteger i = 0; i < self.thumbnails.count; i++) {
        HYEditVideoThumbnail *timedImage = self.thumbnails[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = timedImage.image;
        imageView.frame = CGRectMake(currentX, 0, imageSize.width, imageSize.height);
        imageView.tag = i;
        [self.scrollView addSubview:imageView];
        currentX += imageSize.width;
    }
}


@end
