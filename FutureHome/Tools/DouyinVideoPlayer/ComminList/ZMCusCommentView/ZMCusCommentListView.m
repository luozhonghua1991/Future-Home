//
//  ZMCusCommentListView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentListView.h"

#import "ZMCusCommentListContentCell.h"
#import "ZMCusCommentListReplyContentCell.h"


@interface ZMCusCommentListView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isSelect;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommentListModel *commentListModel;

@end


@implementation ZMCusCommentListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = RGBHexColor(0xffffff, 1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;
        [self layoutUI];
        
    }
    return self;
}

- (void)setCommmentCount:(NSInteger)commmentCount {
    _commmentCount = commmentCount;
    _headerView.commmentCount = self.commmentCount;
}

- (void)layoutUI{
    
    if (!_headerView) {
        _headerView = [[ZMCusCommentListTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _headerView.commmentCount = self.commmentCount;
        @weakify(self)
        _headerView.closeBtnBlock = ^{
            @strongify(self)
            if (self.closeBtnBlock) {
                self.closeBtnBlock();
            }
        };
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(70);
        }];
    }

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 10000;
        [_tableView registerClass:[ZMCusCommentListContentCell class] forCellReuseIdentifier:NSStringFromClass([ZMCusCommentListContentCell class])];
        [_tableView registerClass:[ZMCusCommentListReplyContentCell class] forCellReuseIdentifier:NSStringFromClass([ZMCusCommentListReplyContentCell class])];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(70,0, ZMCusComentBottomViewHeight+ZMCusCommentViewTopHeight+SAFE_AREA_BOTTOM, 0));
        }];
    }
    
    
    if (!_bottomView) {
        _bottomView = [[ZMCusCommentBottomView alloc] init];
        @weakify(self)
        _bottomView.tapBtnBlock = ^{
            @strongify(self)
            if (self.tapBtnBlock) {
                self.tapBtnBlock();
            }
        };
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(ZMCusCommentViewTopHeight+SAFE_AREA_BOTTOM));
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(ZMCusComentBottomViewHeight);
        }];
    }
    
}

- (void)setCommentListDataArrs:(NSMutableArray *)commentListDataArrs {
    _commentListDataArrs = commentListDataArrs;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentListDataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果你需要做成多级回复的话，可以改一下tableview为section 的形式去做
//    FHCommentListModel *model = self.commentListDataArrs[indexPath.row];
//    if (IS_NULL_ARRAY(model.child)) {
        ZMCusCommentListContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZMCusCommentListContentCell class]) forIndexPath:indexPath];
        FHCommentListModel *model = self.commentListDataArrs[indexPath.row];
        cell.commentListModel = model;
        return cell;
//    } else {
//        ZMCusCommentListReplyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZMCusCommentListReplyContentCell class]) forIndexPath:indexPath];
//        [cell configData:nil];
//        return cell;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //防止重复点击
    if (!self.isSelect) {
        self.isSelect = YES;
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:1.0f];
        FHCommentListModel *commentMoel = self.commentListDataArrs[indexPath.row];
        /** 回复评论 */
        if (_delegate !=nil && [_delegate respondsToSelector:@selector(fh_ZMCusCommentListViewDelegateSelectComment:)]) {
            [_delegate fh_ZMCusCommentListViewDelegateSelectComment:commentMoel];
        }
        
        if (self.replyBtnBlock) {
            self.replyBtnBlock();
        }
    }

}

- (void)repeatDelay{
    self.isSelect = NO;
}

@end
