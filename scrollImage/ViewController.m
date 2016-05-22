//
//  ViewController.m
//  scrollImage
//
//  Created by 鹏 刘 on 16/5/15.
//  Copyright © 2016年 鹏 刘. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView *scroll;
@property (nonatomic) UIImageView *image;
@property (nonatomic,copy) NSArray *imageArray;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic,strong)NSMutableArray *contentViews;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"dog 1"],[UIImage imageNamed:@"dog 2"],[UIImage imageNamed:@"dog 3"],[UIImage imageNamed:@"dog 4"], nil];
    
    self.totalPage = self.imageArray.count;
    self.currentPage = 0;
    
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 550)];
    self.scroll.backgroundColor = [UIColor grayColor];
    self.scroll.contentSize = CGSizeMake((self.scroll.frame.size.width * self.imageArray.count), self.scroll.frame.size.height);
    self.scroll.contentOffset = CGPointMake(CGRectGetWidth(self.view.frame), 0);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.pagingEnabled = YES;
    [self.view addSubview:self.scroll];

    for (int i = 0; i < self.imageArray.count; i ++) {
        CGRect rect = self.scroll.bounds;
        rect.origin.x = CGRectGetWidth(self.scroll.bounds) * i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = i + 10;
        NSInteger page = [self getValidNextPage:-1 + i];
        imageView.image = [self.imageArray objectAtIndex:page];
        [self.scroll addSubview:imageView];
    }

}

- (void)setContentViewDataSource
{
    NSInteger previousPage = [self getValidNextPage:self.currentPage - 1];
    NSInteger rearPage = [self getValidNextPage:self.currentPage + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
    }
    
    [self.contentViews removeAllObjects];
   
    [self.contentViews addObject:[self.imageArray objectAtIndex:previousPage]];
    [self.contentViews addObject:[self.imageArray objectAtIndex:self.currentPage]];
    [self.contentViews addObject:[self.imageArray objectAtIndex:rearPage]];

}

- (void)configContentView
{
    [self setContentViewDataSource];
    
    for (int i = 0; i < self.contentViews.count; i ++) {
        UIImage *image = [self.contentViews objectAtIndex:[self getValidNextPage:i]];
        UIImageView *imageView = (UIImageView *)[self.scroll viewWithTag:10 + i];
    
    if (imageView) {
        imageView.image = image;
    }
  
  }
 
    [self.scroll setContentOffset:CGPointMake(CGRectGetWidth(self.scroll.frame), 0)];
}



- (NSInteger)getValidNextPage:(NSInteger)currentPage
{
    if (currentPage == -1) {
        return self.totalPage - 1;
    }
    else if (currentPage == self.totalPage) {
        return 0;
    }
    else {
    return  currentPage;
  }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / CGRectGetWidth(self.scroll.bounds);
    
    if (page == 2) {
        self.currentPage = [self getValidNextPage:_currentPage + 1];
        [self configContentView];
    }
    else if (page == 0) {
        self.currentPage = [self getValidNextPage:_currentPage - 1];
        [self configContentView];
    }
}


@end
