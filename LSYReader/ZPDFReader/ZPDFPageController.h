//
//  ZPDFPageController.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "LSYReadView.h"
#import "LSYReadViewController.h"
@interface ZPDFPageController : UIViewController

@property (assign, nonatomic) CGPDFDocumentRef pdfDocument;
@property (assign, nonatomic) long pageNO;
@property(assign,nonatomic)long chapterNO;

@end
