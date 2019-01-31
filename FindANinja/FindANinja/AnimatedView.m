//
//  AnimatedView.m
//  FindANinja
//
//  Created by Sam Meech-Ward on 2019-01-31.
//  Copyright © 2019 meech-ward. All rights reserved.
//

#import "AnimatedView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@implementation AnimatedView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media.giphy.com/media/ErdfMetILIMko/giphy.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    [self addSubview:imageView];
  }
  return self;
}

@end
