//
//  ZPDFPageModel.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageModel.h"
#import "ZPDFPageController.h"
#import "PDFDocumentOutline.h"
#import "LSYChapterModel.h"
#import "PDFDocumentOutlineItem.h"
@implementation ZPDFPageModel

-(id) initWithPDFDocument:(CGPDFDocumentRef) pdfDoc {
    self = [super init];
    if (self) {
        pdfDocument = pdfDoc;
        //获取目录字典
        _items = [[PDFDocumentOutline alloc]outlineItemsForDocument:pdfDocument];
        super.chapters = [self getChapters:_items];
       super.notes = [NSMutableArray array];
       super.marks = [NSMutableArray array];
        super.record = [[LSYRecordModel alloc] init];
        super.record.chapterModel = super.chapters.firstObject;
        super.record.chapterCount = super.chapters.count;

    }
    return self;
}

-(NSMutableArray*)getChapters:(NSArray*)chapterArray{
    NSMutableArray* chapters = [[NSMutableArray alloc]init];
    for (PDFDocumentOutlineItem* element in chapterArray){
        LSYChapterModel *model = [LSYChapterModel chapterWithPdf:element.title WithPageCount:element.pageNumber];
        [chapters addObject:model];
        
    }
    
    return chapters;
}


- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)pageNO {
    // Return the data view controller for the given index.
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || pageNO >= pageSum+1) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    pageController.pdfDocument = pdfDocument;
    pageController.pageNO  = pageNO;
    return pageController;
}

- (NSUInteger)indexOfViewController:(ZPDFPageController *)viewController {
    return viewController.pageNO;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if ((index == 1) || (index == NSNotFound)) {
        return nil;
    }
    index--;
//    //存储变化的页码
//    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:self.fileName];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    if(_delegate && [_delegate respondsToSelector:@selector(pageChanged:)])
    {
        [_delegate pageChanged:index];
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (index >= pageSum+1) {
        return nil;
    }
//    //存储变化的页码
//    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:self.fileName];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    if(_delegate && [_delegate respondsToSelector:@selector(pageChanged:)])
    {
        [_delegate pageChanged:index];
    }
    return [self viewControllerAtIndex:index];
}


@end
