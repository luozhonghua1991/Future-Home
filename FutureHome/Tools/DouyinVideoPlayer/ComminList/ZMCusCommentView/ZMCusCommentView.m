//
//  ZMCusCommentView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentView.h"
#import "UIView+Frame.h"
#import "FHAppDelegate.h"
#import "FHCommentListModel.h"

#define TOOL_VIEW_HEIGHT 47

@interface ZMCusCommentView() <ZMCusCommentListViewDelegate>
@property (nonatomic, strong) UIControl *maskView;
@property (nonatomic, strong) UIControl *topMaskView;
@property (nonatomic, strong) NSString *historyText;
@property (nonatomic, assign) CGRect historyFrame;
@property (nonatomic, assign) BOOL isKeyBoardShow;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *commentListArrs;
/** <#copy属性注释#> */
@property (nonatomic, strong) FHCommentListModel *commentModel;

@end

@implementation ZMCusCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0x000000, 0.5);
        [self addSubview:self.toolView];
        [self layoutUI];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}
- (void)layoutUI{
    if (!_maskView) {
        _maskView = [[UIControl alloc] initWithFrame:self.frame];
        _maskView.backgroundColor = [UIColor clearColor];
        [_maskView addTarget:self action:@selector(maskViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
            
        }];
    }
    if (!_commentListView) {
        _commentListView = [[ZMCusCommentListView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _commentListView.delegate = self;
        @weakify(self)
        _commentListView.closeBtnBlock = ^{
            @strongify(self)
            [self hideView];
        };
        _commentListView.tapBtnBlock = ^{
            @strongify(self)
            if (!self.isKeyBoardShow) {
                [self showCommentToolView];
            }
     
            
        };
        _commentListView.replyBtnBlock = ^{
            @strongify(self)
            if (!self.isKeyBoardShow) {
                [self showCommentToolView];
            }
        };
        [self addSubview:_commentListView];
    }
    if (!_topMaskView) {
        _topMaskView = [[UIControl alloc] initWithFrame:self.frame];
        _topMaskView.backgroundColor = [UIColor clearColor];
        _topMaskView.hidden = YES;
        [_topMaskView addTarget:self action:@selector(topMaskViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topMaskView];
        [_topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
            
        }];
    }
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:swipeGestureRecognizer];


}

- (void)fh_ZMCusCommentListViewDelegateSelectComment:(FHCommentListModel *)commentModel {
    [SingleManager shareManager].isCommentComment = YES;
    self.commentModel = commentModel;
}

- (ZMCusCommentToolView *)toolView{
    if (!_toolView) {
        self.historyFrame = CGRectMake(0, 0, SCREEN_WIDTH, TOOL_VIEW_HEIGHT);
        _toolView = [[ZMCusCommentToolView alloc] initWithFrame:self.historyFrame];
        _toolView.hidden = YES;
        @weakify(self)
        _toolView.sendBtnBlock = ^(NSString *text){
            @strongify(self)
            //点击发送的事件
            /** 判断是回复评论还是评论 */
            if ([SingleManager shareManager].isCommentComment) {
                /** 回复评论 */
                
            } else {
                [self addCommentWithContent:text];
            }
        };
        
        _toolView.changeTextBlock = ^(NSString *text, CGRect frame) {
            @strongify(self)
            self.historyText = @"";
            self.historyFrame = frame;
        };
    }
    return _toolView;
}

/** 给视频添加评论 */
- (void)addCommentWithContent:(NSString *)content {
    /** 添加视频评论 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(account.user_id),@"from_uid",
                               @"2",@"topic_type",
                               self.videoTopicId,@"topic_id",
                               content,@"content",
                               nil];
    
    [AFNetWorkTool post:@"shop/addComment" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.commentListView.commmentCount = [responseObj[@"data"] integerValue];
            weakSelf.historyText = @"";
            [weakSelf hideCommentToolView];
            /** 刷新评论列表 */
            WS(weakSelf);
            Account *account = [AccountStorage readAccount];
            NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @(account.user_id),@"user_id",
                                       self.videoTopicId,@"id",
                                       @(1),@"page",
                                       @(2),@"type",
                                       [SingleManager shareManager].ordertype,@"ordertype",
                                       nil];
            
            [AFNetWorkTool get:@"shop/getComments" params:paramsDic success:^(id responseObj) {
                if ([responseObj[@"code"] integerValue] == 1) {
                    weakSelf.commentListArrs = [[NSMutableArray alloc] init];
                    NSArray *arr = responseObj[@"data"][@"list"];
                    weakSelf.commentListView.commentListDataArrs = [FHCommentListModel mj_objectArrayWithKeyValuesArray:arr];
                } else {
                    
                }
            } failure:^(NSError *error) {
                
            }];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showCommentToolView {
    self.topMaskView.hidden = NO;
    self.toolView.hidden = NO;
    self.toolView.textView.inputAccessoryView = self.toolView;

    [self.toolView showTextView];
    if (self.historyFrame.size.height != TOOL_VIEW_HEIGHT) {
        self.toolView.frame = self.historyFrame;
    }
    if (self.toolView.textView.text.length<=0) {
        self.historyFrame = CGRectMake(0, 0, SCREEN_WIDTH, TOOL_VIEW_HEIGHT);
        [self.toolView resetView];
        self.toolView.frame = self.historyFrame;
    }

}
- (void)hideCommentToolView{
    self.topMaskView.hidden = YES;
    self.toolView.hidden = YES;

    [self.toolView hideTextView];
    [self addSubview:self.toolView];
}

- (void)maskViewClick{
    [self hideView];
}
- (void)topMaskViewClick{
    [self hideCommentToolView];
}
- (void)hideView {
    [SingleManager shareManager].isCommentComment = NO;
    [self hideCommentToolView];
    [UIView animateWithDuration:0.2 animations:^{
        self.commentListView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }];
    
}
- (void)showView{
    [UIView animateWithDuration:0.2 animations:^{
        self.commentListView.frame = CGRectMake(0, ZMCusCommentViewTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
//        self.commentListView.frame = CGRectMake(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        [self hideView];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    }

}
- (void)keyboardDidShow
{
    NSLog(@"键盘弹出");
    self.isKeyBoardShow = YES;
}
- (void)keyboardDidHide
{
    NSLog(@"键盘隐藏");
    self.isKeyBoardShow = NO;
}
@end

@implementation ZMCusCommentManager

+(instancetype)shareManager{
    static ZMCusCommentManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[ZMCusCommentManager alloc] init];
    });
    return instance;
}

- (void)showCommentWithSourceId:(NSString *)sourceId
                       dataArrs:(NSMutableArray *)commentListArrs
                   tableData:(ZFTableData *)data {
    ZMCusCommentView *view = [[ZMCusCommentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.commentListView.commentListDataArrs = commentListArrs;
    view.commentListView.headerView.commmentCount = [data.comment intValue];
    view.commentListView.videoTopicId = data.dataID;
    view.videoTopicId = data.dataID;
    FHAppDelegate *delegate = (FHAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:view];
    [view showView];
}

@end
