//
//  CXEditLabel.m
//  SDMarketingManagement
//
//  Created by lancely on 5/20/16.
//  Copyright © 2016 slovelys. All rights reserved.
//


#import "CXEditLabel.h"
#import "CXStaticDataHelper.h"
#import "CXTextView.h"
#import "SDCustomDatePicker2.h"
#import "SDCustomTextPicker.h"
#import "SDScopeTableViewController.h"
#import "SDSelectContactViewController.h"
//#import "SDSendRangeViewController.h"
#import "HttpTool.h"
#import "YYModel.h"
//#import "ERPCustomerModel.h"
#import "UIView+YYAdd.h"
#import "CXMiddleActionSheetSelectView.h"
#import "CXDatePickerView.h"
#import "UIImage+YYAdd.h"
#import "CXUserSelectController.h"
#import "NSAttributedString+YYText.h"
#import "NSString+PinYin4Cocoa.h"

#import "CXBussinessSelectView.h"
NSString *const CXEditLabelCustomPickerTextKey = @"text";
NSString *const CXEditLabelCustomPickerValueKey = @"value";

NSInteger const kSHButtonTag = 88812;

static CGFloat height;

@interface CXEditLabel () <CXTextViewDelegate>

/** 文字样式 */
//@property (nonatomic, strong) NSMutableParagraphStyle* textStyle;

@property(nonatomic, strong) NSMutableParagraphStyle *titleStyle;
@property(nonatomic, strong) NSMutableParagraphStyle *contentStyle;

/** 静态数据 */
@property(nonatomic, copy) NSArray<CXStaticDataModel *> *staticDatas;

/** 月份数据 */
@property(nonatomic, copy) NSArray<NSArray<NSString *> *> *monthPickerData;
/** 年份数据 */
@property(nonatomic, copy) NSArray<NSString *> *yearPickerData;

/** 文字label */
@property(nonatomic, strong) UILabel *internalLabel;
/** 下拉箭头图标 */
@property(nonatomic, strong) UIImageView *dropdownImageView;

@property(nonatomic, strong) CXBussinessSelectView *selectView;

@property(nonatomic, strong) CXMiddleActionSheetSelectView *sheetSelectView;

/** 短横线 - */
@property(nonatomic, strong) UIButton *shButton;

/** 占位label */
@property(nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation CXEditLabel {
    NSString *_content;

    // 抄送
    NSArray *_selectedCCContacts;
    NSArray *_selectedCCDeptIdArray;
    NSArray *_selectedCCDeptArray;
}

#pragma mark - Get Set
//- (NSMutableParagraphStyle*)textStyle
//{
//    if (!_textStyle) {
//        _textStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    }
//    return _textStyle;
//}

- (void)setScale:(BOOL)scale {
    if (scale) {
        self.internalLabel.numberOfLines = 0;
    }
    _scale = scale;
}

- (NSMutableParagraphStyle *)titleStyle {
    if (!_titleStyle) {
        _titleStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return _titleStyle;
}

- (NSMutableParagraphStyle *)contentStyle {
    if (!_contentStyle) {
        _contentStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return _contentStyle;
}

//- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
//{
//    [super setLineBreakMode:lineBreakMode];
//    self.textStyle.lineBreakMode = lineBreakMode;
//}

//- (void)setTextAlignment:(NSTextAlignment)textAlignment
//{
//    [super setTextAlignment:textAlignment];
//    self.textStyle.alignment = textAlignment;
//}

//- (void)setHeadIndent:(NSInteger)headIndent
//{
//    self->_headIndent = headIndent;
//    self.textStyle.firstLineHeadIndent = headIndent;
//    self.textStyle.headIndent = headIndent;
//}
//
//- (void)setTailIndent:(NSInteger)tailIndent
//{
//    self->_tailIndent = tailIndent;
//    self.textStyle.tailIndent = tailIndent;
//}
//
//- (void)setSpacing:(CGFloat)spacing
//{
//    self.textStyle.lineSpacing = spacing;
//}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.content = _content;
}

- (NSString *)content {
    if (self.isRequired) {
        return [self.internalLabel.attributedText.string substringFromIndex:self.title.length + 1];
    }
    return [self.internalLabel.attributedText.string substringFromIndex:self.title.length];
}

const NSString *flagStr = @"  ";

- (void)setContent:(NSString *)content {
    content = [content length] ? content : @"";
    if (self.maxLength > 0 && content.length > self.maxLength) {
        content = [content substringToIndex:self.maxLength - 1];
    }
    _content = content;
    if (content.length > 0) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
    //    if ([self.title length]) {
    //        content = [self.title stringByAppendingString:content];
    //    }
    //    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:content attributes:@{ NSParagraphStyleAttributeName : self.textStyle }];
    //    self.attributedText = attrText;
    if ([_title length] == 0) {
        _title = @"";
    }
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    // 必填添加星号标识
    if (self.isRequired) {
        NSAttributedString *asteriskAttr = [[NSAttributedString alloc] initWithString:@"*" attributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: self.titleFont}];
        [attrText appendAttributedString:asteriskAttr];
    }
    NSAttributedString *titleAttr = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName: self.titleFont}];
    [attrText appendAttributedString:titleAttr];

    if (self.inputType == CXEditLabelInputTypeApproval) {
        // TODO:此功能用于云境CRM临时报告添加这个界面
        if ([_content containsString:flagStr]) {
            int idx = [_content indexOfString:flagStr];
            NSRange range = NSMakeRange(idx, _content.length - idx);
            NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:_content];
            contentAttr.yy_font = self.contentFont;
            [contentAttr yy_setFont:[UIFont systemFontOfSize:12.f] range:range];
            [contentAttr yy_setColor:[UIColor lightGrayColor] range:range];
            [attrText appendAttributedString:contentAttr];
        }
    } else {
        NSAttributedString *contentAttr = [[NSAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName: self.contentFont}];
        [attrText appendAttributedString:contentAttr];
    }

    self.internalLabel.attributedText = attrText;
    [self relayout];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.content = _content;
}

- (void)setContentFont:(UIFont *)contentFont {
    _contentFont = contentFont;
    self.content = _content;
}

//- (void)setText:(NSString *)text {
//    NSAssert(NO, @"不要用这个方法了，亲");
//}

- (NSArray<CXStaticDataModel *> *)staticDatas {
    if (!_staticDatas) {
        _staticDatas = [[CXStaticDataHelper sharedInstance] getStaticDataWithType:self.staticDataType];
    }
    return _staticDatas;
}

- (void)setDetailCCData:(NSArray<id> *)detailCCData {
    self->_detailCCData = detailCCData;
    if (detailCCData.count == 1) {
        self.content = [detailCCData.firstObject valueForKey:@"userName"] ? [detailCCData.firstObject valueForKey:@"userName"] : [detailCCData.firstObject valueForKey:@"name"];
    } else if (detailCCData.count > 1) {
        self.content = [NSString stringWithFormat:@"%zd人", detailCCData.count];
    }
}

- (void)setDetailStaticDataValue:(NSString *)detailStaticDataValue {
    self->_detailStaticDataValue = detailStaticDataValue;
    self.content = [[CXStaticDataHelper sharedInstance] getNameByValue:detailStaticDataValue ofType:self.staticDataType];
}

- (NSArray<NSArray<NSString *> *> *)monthPickerData {
    if (!_monthPickerData) {
        NSMutableArray *yearArray = [NSMutableArray array];
        NSMutableArray *monthArray = [NSMutableArray array];
        //获取当前年
        NSInteger yearNum = [NSDate date].year;
        for (NSInteger i = yearNum - 150; i < yearNum + 150; i++) {
            NSString *yearStr = [NSString stringWithFormat:@"%zd年", i];
            [yearArray addObject:yearStr];
        }

        for (NSInteger i = 1; i < 13; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%zd月", i];
            [monthArray addObject:monthStr];
        }
        _monthPickerData = @[
                [yearArray copy],
                [monthArray copy]
        ];
    }
    return _monthPickerData;
}

- (NSArray<NSString *> *)yearPickerData {
    if (!_yearPickerData) {
        NSMutableArray *arr = [NSMutableArray array];
        NSInteger yearNum = [NSDate date].year;
        for (NSInteger i = yearNum - 10; i < yearNum + 10; i++) {
            NSString *yearStr = [NSString stringWithFormat:@"%zd年", i];
            [arr addObject:yearStr];
        }
        _yearPickerData = [arr copy];
    }
    return _yearPickerData;
}

- (void)setInputType:(CXEditLabelInputType)inputType {
    self->_inputType = inputType;
    NSArray<NSNumber *> *showDropdownTypes = @[@(CXEditLabelInputTypeStaticData), @(CXEditLabelInputTypeCustomPicker)];
    if ([showDropdownTypes containsObject:@(inputType)]) {
        self.showDropdown = YES;
    }
}

- (void)setShowDropdown:(BOOL)showDropdown {
    self->_showDropdown = showDropdown;
    self->_dropdownImageView.hidden = !showDropdown;
}

- (void)setShowWhiteDropdown:(BOOL)showWhiteDropdown {
    self->_showWhiteDropdown = showWhiteDropdown;
    self.dropdownImageView.image = Image(@"whiteDropdown");
    self.dropdownImageView.highlightedImage = Image(@"whiteDropdown");
    self->_dropdownImageView.hidden = !_showWhiteDropdown;
}

- (UIImageView *)dropdownImageView {
    if (!_dropdownImageView) {
        _dropdownImageView = [[UIImageView alloc] initWithImage:Image(@"dropdown")];
        [self addSubview:_dropdownImageView];
    }
    return _dropdownImageView;
}
- (void)setShowNewDropdown:(BOOL)showNewDropdown{
    _showDropdown = showNewDropdown;
    _dropdownImageView.hidden = !showNewDropdown;
    self.dropdownImageView.image = Image(@"arrow_spread");
    self.dropdownImageView.highlightedImage = Image(@"arrow_spread");
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}
- (void)setRequired:(BOOL)required {
    self->_required = NO;
//    self->_required = required;
    self.title = self.title;
}

- (UIButton *)shButton {
    if (!_shButton) {
        _shButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"-" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(shButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = kSHButtonTag;
            button;
        });
    }
    return _shButton;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = kColorWithRGB(191, 191, 191);
        _placeholderLabel.font = [UIFont systemFontOfSize:kFontSizeForDetail.pointSize];
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.internalLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label;
    });

    // 设置默认
    self.internalLabel.font = kFontOfSize(kFontSizeValueForForm);
    self.textColor = [UIColor blackColor];
//    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.internalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    self.headIndent = 0;
    //    self.tailIndent = 0;
    self.allowEditing = YES;
    self.showDropdown = NO;
    _titleFont = kFontSizeForDetail;
    _contentFont = kFontSizeForForm;

    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textLabelTapped:)]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

__weak static CXEditLabel *activedLabel;

- (void)keyboardDidShow:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (activedLabel.inputType == CXEditLabelInputTypeCustomPhone) {
//        double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        NSInteger cnt = [[UIApplication sharedApplication] windows].count;
//        id win = [[UIApplication sharedApplication] windows];
        UIWindow *keyboardWindow = [self getKeyboardWindow];

        if (keyboardWindow) {
            CGFloat buttonW = kbSize.width / 3;
            CGFloat buttonH = kbSize.height / 4;
            self.shButton.frame = CGRectMake(0, keyboardWindow.frame.size.height - buttonH + 1, buttonW - 2, buttonH - 1);
            if ([keyboardWindow viewWithTag:kSHButtonTag] == nil) {
                [keyboardWindow addSubview:self.shButton];
            }
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    UIWindow *keyboardWindow = [self getKeyboardWindow];
    if (keyboardWindow) {
        for (UIView *view in keyboardWindow.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                if ([btn.currentTitle isEqualToString:@"-"]) {
                    [btn removeFromSuperview];
                    btn = nil;
                }
            }
        }
    }
}

#pragma mark - 布局

- (void)relayout {
    if (self.internalLabel.numberOfLines == 0) {
        CGRect frame = self.frame;
        CGFloat h = [self.internalLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX)].height;

        if (self.scale == NO) {
            if (h != self.internalLabel.font.lineHeight) {
                h = h + kLineHeight - self.internalLabel.font.lineHeight;
            }
            frame.size.height = MAX(h, frame.size.height);
        } else {
            if (h > frame.size.height) {
                frame.size.height = h;
            }
        }if(self.fitSize){
            if(h)
            frame.size.height = h;
        }
        self.frame = frame;
        if (self.needUpdateFrameBlock) {
            self.needUpdateFrameBlock(self, CGRectGetHeight(self.frame));
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self->_dropdownImageView.hidden = !self.showDropdown;
    if (self.showDropdown) {
        // 图标位置
        [self.dropdownImageView sizeToFit];
        self.dropdownImageView.right = GET_WIDTH(self) - 5;
        self.dropdownImageView.centerY = GET_HEIGHT(self) * .5;
        // label位置
        self.internalLabel.frame = CGRectMake(0, 0, GET_MIN_X(self.dropdownImageView), GET_HEIGHT(self));
    } else {
        self.internalLabel.frame = self.bounds;
    }
    if (_placeholderLabel) {
        CGFloat titleWidth = [self.title sizeWithAttributes:@{NSFontAttributeName: self.titleFont}].width;
        self.placeholderLabel.left = titleWidth;
        self.placeholderLabel.centerY = GET_HEIGHT(self) * .5;
    }
}

#pragma mark - Action

- (void)textLabelTapped:(UIGestureRecognizer *)gesture {
    activedLabel = self;

    if (self.customActionBlock) {
        if (self.isAllowEditing) {
            self.customActionBlock(self);
        }
    } else {
        // 键盘输入
        if (self.inputType < 100) {
            if (self.isAllowEditing) {
                CXTextView *textView = [[CXTextView alloc] initWithKeyboardType:(UIKeyboardType) self.inputType];
                textView.delegate = self;
                [KEY_WINDOW addSubview:textView];
            }
        }
            // 业务
        else {
            DECLARE_WEAK_SELF;
            switch (self.inputType) {
                // 审批人
                case CXEditLabelInputTypeApproval: {
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = AllMembersType;
                        selectVC.title = @"选择批审人";
                        selectVC.multiSelect = NO;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.selectedCCUsers;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                                weakSelf.content = [NSString stringWithFormat:@"%@%@%@", users.firstObject.name, flagStr, users.firstObject.job];
                            } else if (users.count > 1) {
                                weakSelf.content = [NSString stringWithFormat:@"%zd人", users.count];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }
                    break;
                }
                    // 抄送
                case CXEditLabelInputTypeCC: {
                    // 编辑
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = AllMembersType;
                        selectVC.title = self.syrViewTitle.length ? self.syrViewTitle : @"选择抄送人";
                        selectVC.multiSelect = YES;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.selectedCCUsers;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                            } else if (users.count > 1) {
                                weakSelf.content = [NSString stringWithFormat:@"%zd人", users.count];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }
                        // 详情
                    else {
                        if (self.detailCCData.count) {
                            // 只有一人则不跳转
                            if (self.detailCCData.count == 1) {
                                return;
                            }
                            CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                            selectVC.selectType = AllMembersType;
                            selectVC.title = self.syrViewTitle.length ? self.syrViewTitle : @"选择抄送人";;
                            selectVC.multiSelect = NO;
                            selectVC.displayOnly = YES;
                            NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
                            [self.detailCCData enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[CXUserModel class]]) {
                                    [users addObject:obj];
                                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                                    NSNumber *uid = obj[@"eid"] ?: obj[@"userId"];
                                    CXUserModel *u = [[CXUserModel alloc] init];
                                    u.eid = uid.integerValue;
                                    u.name = obj[@"name"] ?: obj[@"userName"];
                                    [users addObject:u];
                                }
                            }];
                            selectVC.selectedUsers = users;
                            [self.getNavigationController pushViewController:selectVC animated:YES];
//                            SDScopeTableViewController *sendRangeVC = [[SDScopeTableViewController alloc] init];
//                            NSMutableArray<NSString *> *detailCCIdArr = [NSMutableArray array];
//                            [self.detailCCData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                NSString *userId = [[obj valueForKey:@"userId"] stringValue];
//                                [detailCCIdArr addObject:userId];
//                            }];
//                            sendRangeVC.dataArr = detailCCIdArr;
//                            sendRangeVC.type = scopeId;
//                            [self.getNavigationController pushViewController:sendRangeVC animated:YES];
                        }
                    }
                    break;
                }
                    // 使用人
                case CXEditLabelInputTypeSYR: {
                    // 编辑
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = AllMembersType;
                        selectVC.title = self.syrViewTitle ? self.syrViewTitle : @"选择使用人";
                        selectVC.multiSelect = NO;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.selectedCCUsers;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                            } else if (users.count > 1) {
                                weakSelf.content = [NSString stringWithFormat:@"%zd人", users.count];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }

                        // 详情
                    else {
                        if (self.detailCCData.count) {
                            CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                            selectVC.title = self.syrViewTitle ? self.syrViewTitle : @"选择使用人";
                            selectVC.selectType = AllMembersType;
                            selectVC.multiSelect = NO;
                            selectVC.displayOnly = YES;
                            NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
                            [self.detailCCData enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[CXUserModel class]]) {
                                    [users addObject:obj];
                                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                                    NSNumber *uid = obj[@"eid"] ?: obj[@"userId"];
                                    CXUserModel *u = [[CXUserModel alloc] init];
                                    u.eid = uid.integerValue;
                                    u.name = obj[@"name"] ?: obj[@"userName"];
                                    [users addObject:u];
                                }
                            }];
                            selectVC.selectedUsers = users;
                            [self.getNavigationController pushViewController:selectVC animated:YES];
                            //                            SDScopeTableViewController *sendRangeVC = [[SDScopeTableViewController alloc] init];
                            //                            NSMutableArray<NSString *> *detailCCIdArr = [NSMutableArray array];
                            //                            [self.detailCCData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            //                                NSString *userId = [[obj valueForKey:@"userId"] stringValue];
                            //                                [detailCCIdArr addObject:userId];
                            //                            }];
                            //                            sendRangeVC.dataArr = detailCCIdArr;
                            //                            sendRangeVC.type = scopeId;
                            //                            [self.getNavigationController pushViewController:sendRangeVC animated:YES];
                        }
                    }
                    break;
                }
                    // 使用人
                case CXEditLabelInputTypeXS: {
                    // 编辑
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = SubordinateType;
                        selectVC.title = self.syrViewTitle ? self.syrViewTitle : @"选择下属";
                        selectVC.multiSelect = NO;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.detailCCData;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                            } else if (users.count > 1) {
                                weakSelf.content = [NSString stringWithFormat:@"%zd人", users.count];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }

                        // 详情
                    else {
                        if (self.detailCCData.count) {
                            CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                            selectVC.title = self.syrViewTitle ? self.syrViewTitle : @"选择下属";
                            selectVC.selectType = SubordinateType;
                            selectVC.multiSelect = NO;
                            selectVC.displayOnly = YES;
                            NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
                            [self.detailCCData enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[CXUserModel class]]) {
                                    [users addObject:obj];
                                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                                    NSNumber *uid = obj[@"eid"] ?: obj[@"userId"];
                                    CXUserModel *u = [[CXUserModel alloc] init];
                                    u.eid = uid.integerValue;
                                    u.name = obj[@"name"] ?: obj[@"userName"];
                                    [users addObject:u];
                                }
                            }];
                            selectVC.selectedUsers = users;
                            [self.getNavigationController pushViewController:selectVC animated:YES];
                            //                            SDScopeTableViewController *sendRangeVC = [[SDScopeTableViewController alloc] init];
                            //                            NSMutableArray<NSString *> *detailCCIdArr = [NSMutableArray array];
                            //                            [self.detailCCData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            //                                NSString *userId = [[obj valueForKey:@"userId"] stringValue];
                            //                                [detailCCIdArr addObject:userId];
                            //                            }];
                            //                            sendRangeVC.dataArr = detailCCIdArr;
                            //                            sendRangeVC.type = scopeId;
                            //                            [self.getNavigationController pushViewController:sendRangeVC animated:YES];
                        }
                    }
                    break;
                }
                    // 客户
                case CXEditLabelInputTypeClient: {
                    if (self.isAllowEditing) {}
                    break;
                }
                    // 静态数据
                case CXEditLabelInputTypeStaticData: {
                    if (self.isAllowEditing) {
                        SDCustomTextPicker *picker = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil].lastObject;
                        NSMutableArray<NSString *> *pickerData = [NSMutableArray array];
                        [self.staticDatas enumerateObjectsUsingBlock:^(CXStaticDataModel *obj, NSUInteger idx, BOOL *stop) {
                            [pickerData addObject:obj.name];
                        }];
                        picker.pickerData = [pickerData copy];
                        if (self.selectedStaticDataModel) {
                            NSInteger idx = [self.staticDatas indexOfObject:self.selectedStaticDataModel];
                            if (idx != NSNotFound) {
                                [picker.pickerView selectRow:idx inComponent:0 animated:NO];
                            }
                        }
                        picker.selectCallBack = ^(NSString *text, NSInteger idx) {
                            weakSelf.content = text;
                            _selectedStaticDataModel = weakSelf.staticDatas[idx];
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [KEY_WINDOW addSubview:picker];
                    }
                    break;
                }
                    // 日期
                case CXEditLabelInputTypeDate: {
                    if (self.isAllowEditing) {
                        CXDatePickerView *picker = [[CXDatePickerView alloc] init];
                        picker.datePickerMode = UIDatePickerModeDate;
                        picker.dateContent = self.content;
                        picker.selectDateCallBack = ^(NSString *selectDate) {
                            weakSelf.content = selectDate;
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [picker show];
                        /*{
                            SDCustomDatePicker2 *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomDatePicker2.class) owner:nil options:nil] lastObject];
                            picker.datePicker.datePickerMode = UIDatePickerModeDate;
                            NSDate *date = [NSDate date];
                            if (trim(self.content).length) {
                                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                                fmt.dateFormat = @"yyyy-MM-dd";
                                date = [fmt dateFromString:trim(self.content)];
                            }
                            picker.myDate = date;
                            picker.selectCallBackModeDate2 = ^(NSString *date) {
                                weakSelf.content = date;
                                if (weakSelf.didFinishEditingBlock) {
                                    weakSelf.didFinishEditingBlock(weakSelf);
                                }
                            };
                            [KEY_WINDOW addSubview:picker];
                        }*/
                    }
                    break;
                }

                    // 日期和时间
                case CXEditLabelInputTypeDateAndTime: {
                    if (self.isAllowEditing) {
                        CXDatePickerView *picker = [[CXDatePickerView alloc] init];
                        picker.datePickerMode = UIDatePickerModeDateAndTime;
                        picker.dateContent = self.content;
                        picker.selectDateCallBack = ^(NSString *selectDate) {
                            weakSelf.content = selectDate;
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [picker show];
                        /*{
                         SDCustomDatePicker2 *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomDatePicker2.class) owner:nil options:nil] lastObject];
                         picker.datePicker.datePickerMode = UIDatePickerModeDate;
                         NSDate *date = [NSDate date];
                         if (trim(self.content).length) {
                         NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                         fmt.dateFormat = @"yyyy-MM-dd";
                         date = [fmt dateFromString:trim(self.content)];
                         }
                         picker.myDate = date;
                         picker.selectCallBackModeDate2 = ^(NSString *date) {
                         weakSelf.content = date;
                         if (weakSelf.didFinishEditingBlock) {
                         weakSelf.didFinishEditingBlock(weakSelf);
                         }
                         };
                         [KEY_WINDOW addSubview:picker];
                         }*/
                    }
                    break;
                }

                    // 年月
                case CXEditLabelInputTypeYearMonth: {
                    if (self.isAllowEditing) {
                        SDCustomTextPicker *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil] lastObject];
                        picker.pickerData = self.monthPickerData;
                        NSDate *dateNow = [NSDate date];
                        NSString *yearMonth = [NSString stringWithFormat:@"%zd-%02zd", dateNow.year, dateNow.month];
                        if (trim(self.content).length) {
                            yearMonth = self.content;
                        }
                        NSString *year = [[yearMonth substringToIndex:4] stringByAppendingString:@"年"];
                        NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
                        month = [NSString stringWithFormat:@"%zd月", month.integerValue];
                        NSInteger yIndex = [self.monthPickerData.firstObject indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            return [obj isEqualToString:year];
                        }];
                        NSInteger mIndex = [self.monthPickerData.lastObject indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            return [obj isEqualToString:month];
                        }];
                        if (yIndex != NSNotFound && mIndex != NSNotFound) {
                            [picker.pickerView selectRow:yIndex inComponent:0 animated:NO];
                            [picker.pickerView selectRow:mIndex inComponent:1 animated:NO];
                        }
                        picker.yearMonthCallBack = ^(NSString *year, NSString *month) {
                            year = [year stringByReplacingOccurrencesOfString:@"年" withString:@""];
                            month = [month stringByReplacingOccurrencesOfString:@"月" withString:@""];
                            month = [NSString stringWithFormat:@"%02zd", month.integerValue];
                            weakSelf.content = [NSString stringWithFormat:@"%@-%@", year, month];
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [KEY_WINDOW addSubview:picker];
                    }
                    break;
                }
                    // 年份
                case CXEditLabelInputTypeYear: {
                    if (self.isAllowEditing) {
                        if (self.isAllowEditing) {
                            SDCustomTextPicker *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil] lastObject];
                            picker.pickerData = self.yearPickerData;
                            NSDate *dateNow = [NSDate date];
                            NSString *year = [NSString stringWithFormat:@"%zd年", dateNow.year];
                            if (trim(self.content).length) {
                                year = trim(self.content);
                                NSInteger idx = [self.yearPickerData indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                    return [obj isEqualToString:year];
                                }];
                                if (idx != NSNotFound) {
                                    [picker.pickerView selectRow:idx inComponent:0 animated:NO];
                                }
                            }
                            picker.selectCallBack = ^(NSString *text, NSInteger idx) {
                                weakSelf.content = [text stringByReplacingOccurrencesOfString:@"年" withString:@""];
                                if (weakSelf.didFinishEditingBlock) {
                                    weakSelf.didFinishEditingBlock(weakSelf);
                                }
                            };
                            [KEY_WINDOW addSubview:picker];
                        }
                        break;
                    }
                    break;
                }
                    // 自定义选择器
                case CXEditLabelInputTypeCustomPicker: {
                    if (self.isAllowEditing) {
                        NSString *selected = [self.pickerTextArray count] ? self.pickerTextArray.firstObject : nil;
                        if (self.selectedPickerData) {
                            selected = self.selectedPickerData[CXEditLabelCustomPickerTextKey];
                        }
                        self.sheetSelectView= [[CXMiddleActionSheetSelectView alloc] initWithSelectArray:self.pickerTextArray Title:[self.selectViewTitle ? self.selectViewTitle : self.title componentsSeparatedByString:@"："].firstObject AndSelectData:selected];
                        CXWeakSelf(self)
                        self.sheetSelectView.selectDataCallBack = ^(NSString *selectedData) {
                            if (selectedData == nil) {
                                CXStrongSelf(self)
                                TTAlert([NSString stringWithFormat:@"暂无%@", [self.selectViewTitle ? self.selectViewTitle : self.title componentsSeparatedByString:@"："].firstObject]);
                                return;
                            }
                            weakSelf.content = selectedData;
                            NSInteger idx = [weakSelf.pickerTextArray indexOfObject:selectedData];
                            id value;
                            if (weakSelf.pickerValueArray.count > idx) {
                                value = weakSelf.pickerValueArray[idx];
                            }
                            _selectedPickerData = @{
                                    CXEditLabelCustomPickerTextKey: selectedData,
                                    CXEditLabelCustomPickerValueKey: value ? value : [NSNull null]
                            };
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };

//                         SDCustomTextPicker *textPicker = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil].lastObject;
////                         textPicker.titleLabel.text = [self.title componentsSeparatedByString:@"："].firstObject;
//                         textPicker.pickerData = self.pickerTextArray;
//                         if (self.selectedPickerData) {
//                             NSInteger index = NSNotFound;
//                             NSString *text = self.selectedPickerData[CXEditLabelCustomPickerTextKey];
//                             id value = self.selectedPickerData[CXEditLabelCustomPickerValueKey];
//                             if (text) {
//                                 index = [self.pickerTextArray indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//                                     return [obj isEqualToString:text];
//                                 }];
//                             }
//                             else if (value) {
//                                 index = [self.pickerValueArray indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                     return [obj isEqual:value];
//                                 }];
//                             }
//                             if (index != NSNotFound) {
//                                 [textPicker.pickerView selectRow:index inComponent:0 animated:NO];
//                             }
//                         }
//                         textPicker.selectCallBack = ^(NSString *text, NSInteger idx) {
//                             weakSelf.content = text;
//                             id value;
//                             if (weakSelf.pickerValueArray.count > idx) {
//                                 value = weakSelf.pickerValueArray[idx];
//                             }
//                             _selectedPickerData = @{
//                                                     CXEditLabelCustomPickerTextKey: text,
//                                                     CXEditLabelCustomPickerValueKey: value ? value : [NSNull null]
//                                                     };
//                             if (weakSelf.didFinishEditingBlock) {
//                                    weakSelf.didFinishEditingBlock(weakSelf);
//                             }
//                         };
//                         [KEY_WINDOW addSubview:textPicker];
                    }

                    break;
                }
                case CXEditLabelInputTypeCity:{
                    if (self.isAllowEditing) {
                        NSString *selected = [self.pickerTextArray count] ? self.pickerTextArray.firstObject : nil;
                        if (self.selectedPickerData) {
                            selected = self.selectedPickerData[CXEditLabelCustomPickerTextKey];
                        }
                        self.selectView = [[CXBussinessSelectView alloc] initWithSelectArray:self.pickerTextArray Title:[self.selectViewTitle ? self.selectViewTitle : self.title componentsSeparatedByString:@"："].firstObject AndSelectData:selected];
                        CXWeakSelf(self)
                        self.selectView.selectDataCallBack = ^(NSString *selectedData) {
                            if (selectedData == nil) {
                                CXStrongSelf(self)
                                TTAlert([NSString stringWithFormat:@"暂无%@", [self.selectViewTitle ? self.selectViewTitle : self.title componentsSeparatedByString:@"："].firstObject]);
                                return;
                            }
                            weakSelf.content = selectedData;
                            NSInteger idx = [weakSelf.pickerTextArray indexOfObject:selectedData];
                            id value;
                            if (weakSelf.pickerValueArray.count > idx) {
                                value = weakSelf.pickerValueArray[idx];
                            }
                            _selectedPickerData = @{
                                                    CXEditLabelCustomPickerTextKey: selectedData,
                                                    CXEditLabelCustomPickerValueKey: value ? value : [NSNull null]
                                                    };
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                    }
                    break;
                }
                    // 员工
                case CXEditLabelInputTypeStaff: {
                    if (self.isAllowEditing) {
                        SDSelectContactViewController *vc = [[SDSelectContactViewController alloc] init];
                        vc.selectCallBackContactModel = ^(SDCompanyUserModel *model) {
                            self->_selectedStaff = model;
                            weakSelf.content = model.realName;
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        vc.model = self->_selectedStaff;
                        [[self getNavigationController] pushViewController:vc animated:YES];
                    }
                    break;
                }
                    // 支付方式
                case CXEditLabelInputTypeAccount: {
#if 0
                    if (self.isAllowEditing) {
                        if (self.currencyTextArray.count == 0) {
                            TTAlert(@"请先添加此币种的资金账户");
                            return;
                        }
                        NSMutableArray *dataArray = [NSMutableArray array];
                        for (NSDictionary *dict in self.currencyTextArray) {
                            ERPCustomerModel *model = [ERPCustomerModel yy_modelWithDictionary:dict];
                            [dataArray addObject:model.name];
                        }
                        self.selectView = [[CXMiddleActionSheetSelectView alloc] initWithSelectArray:dataArray Title:[self.title componentsSeparatedByString:@"："].firstObject AndSelectData:self.content];
                        self.selectView.selectDataCallBack = ^(NSString *selectedData) {
                            weakSelf.content = selectedData;
                            NSArray *datas = [NSArray arrayWithArray:weakSelf.currencyTextArray];
                            datas = [datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name = %@", selectedData]];
                            if (datas.count) {
                                weakSelf.payWayStyle = [datas lastObject][@"eid"];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                    }
#endif
                    break;
                }
                case CXEditLabelInputTypeCustomPhone: {
                    if (self.isAllowEditing) {
                        CXTextView *textView = [[CXTextView alloc] initWithKeyboardType:UIKeyboardTypeNumberPad];
                        textView.delegate = self;
                        [KEY_WINDOW addSubview:textView];
                    }
                    break;
                }
                    // 发送
                case CXEditLabelInputTypeFS: {
                    // 编辑
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = AllMembersType;
                        selectVC.title = @"选择发送人";
                        selectVC.multiSelect = YES;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.selectedCCUsers;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                            } else if (users.count > 1) {
                                NSMutableString *content = [[NSMutableString alloc] init];
                                for (CXUserModel *userModel in users) {
                                    [content appendString:[NSString stringWithFormat:@"、%@", userModel.name]];
                                }
                                weakSelf.content = [NSString stringWithFormat:@"%@", [content substringFromIndex:1]];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }
                        // 详情
                    else {
                        if (self.detailCCData.count) {
                            // 只有一人则不跳转
                            if (self.detailCCData.count == 1) {
                                return;
                            }
                            CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                            selectVC.selectType = AllMembersType;
                            selectVC.title = @"发送人";
                            selectVC.multiSelect = NO;
                            selectVC.displayOnly = YES;
                            NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
                            [self.detailCCData enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[CXUserModel class]]) {
                                    [users addObject:obj];
                                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                                    NSNumber *uid = obj[@"eid"] ?: obj[@"userId"];
                                    CXUserModel *u = [[CXUserModel alloc] init];
                                    u.eid = uid.integerValue;
                                    u.name = obj[@"name"] ?: obj[@"userName"];
                                    [users addObject:u];
                                }
                            }];
                            selectVC.selectedUsers = users;
                            [self.getNavigationController pushViewController:selectVC animated:YES];
                            //                            SDScopeTableViewController *sendRangeVC = [[SDScopeTableViewController alloc] init];
                            //                            NSMutableArray<NSString *> *detailCCIdArr = [NSMutableArray array];
                            //                            [self.detailCCData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            //                                NSString *userId = [[obj valueForKey:@"userId"] stringValue];
                            //                                [detailCCIdArr addObject:userId];
                            //                            }];
                            //                            sendRangeVC.dataArr = detailCCIdArr;
                            //                            sendRangeVC.type = scopeId;
                            //                            [self.getNavigationController pushViewController:sendRangeVC animated:YES];
                        }
                    }
                    break;
                }
                    // 协作人
                case CXEditLabelInputTypeXZR: {
                    // 编辑
                    if (self.isAllowEditing) {
                        CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                        selectVC.selectType = AllMembersType;
                        selectVC.title = @"选择协作人";
                        selectVC.multiSelect = YES;
                        selectVC.displayOnly = NO;
                        if (self.selectedCCUsers.count) {
                            if (![self.selectedCCUsers[0] isKindOfClass:[CXUserModel class]]) {
                                self->_selectedCCUsers = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:self.selectedCCUsers];
                            }
                        }
                        selectVC.selectedUsers = self.selectedCCUsers;
                        selectVC.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                            _selectedCCUsers = users;
                            weakSelf.content = @"";
                            if (users.count == 1) {
                                weakSelf.content = users.firstObject.name;
                            } else if (users.count > 1) {
                                weakSelf.content = [NSString stringWithFormat:@"%zd人", users.count];
                            }
                            if (weakSelf.didFinishEditingBlock) {
                                weakSelf.didFinishEditingBlock(weakSelf);
                            }
                        };
                        [[self getNavigationController] pushViewController:selectVC animated:YES];
                    }
                        // 详情
                    else {
                        if (self.detailCCData.count) {
                            // 只有一人则不跳转
                            if (self.detailCCData.count == 1) {
                                return;
                            }
                            CXUserSelectController *selectVC = [[CXUserSelectController alloc] init];
                            selectVC.selectType = AllMembersType;
                            selectVC.title = @"协作人";
                            selectVC.multiSelect = NO;
                            selectVC.displayOnly = YES;
                            NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
                            [self.detailCCData enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[CXUserModel class]]) {
                                    [users addObject:obj];
                                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                                    NSNumber *uid = obj[@"eid"] ?: obj[@"userId"];
                                    CXUserModel *u = [[CXUserModel alloc] init];
                                    u.eid = uid.integerValue;
                                    u.name = obj[@"name"] ?: obj[@"userName"];
                                    [users addObject:u];
                                }
                            }];
                            selectVC.selectedUsers = users;
                            [self.getNavigationController pushViewController:selectVC animated:YES];
                            //                            SDScopeTableViewController *sendRangeVC = [[SDScopeTableViewController alloc] init];
                            //                            NSMutableArray<NSString *> *detailCCIdArr = [NSMutableArray array];
                            //                            [self.detailCCData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            //                                NSString *userId = [[obj valueForKey:@"userId"] stringValue];
                            //                                [detailCCIdArr addObject:userId];
                            //                            }];
                            //                            sendRangeVC.dataArr = detailCCIdArr;
                            //                            sendRangeVC.type = scopeId;
                            //                            [self.getNavigationController pushViewController:sendRangeVC animated:YES];
                        }
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }

    if (self.didTapLabelBlock) {
        self.didTapLabelBlock(self);
    }
}

- (void)shButtonTouchUpInside:(UIButton *)shButton {
    CXTextView *editingView;
    for (UIView *v in KEY_WINDOW.subviews) {
        if ([v isKindOfClass:CXTextView.class]) {
            editingView = (CXTextView *) v;
            break;
        }
    }
    if (editingView) {
        UITextView *textView = [editingView valueForKey:@"_textView"];
        if (textView) {
            textView.text = [textView.text stringByAppendingString:@"-"];
        }
    }
}

#pragma mark - CXTextViewDelegate

- (void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text {
    if (self.maxLength > 0 && text.length > self.maxLength) {
        text = [text substringToIndex:self.maxLength - 1];
    }
    if (self.inputType == CXEditLabelInputTypeDecimal) {
        text = trim(text);
        if (text.length) {
            text = [NSDecimalNumber decimalNumberWithString:text].stringValue;
        }
    }
    self.content = text;
    if (self.didFinishEditingBlock) {
        self.didFinishEditingBlock(self);
    }
}

//开始编辑的时候已经编辑的文本
- (NSString *)textWhenTextViewBeginEdit {
    if (self.inputType == CXEditLabelInputTypeDecimal || self.inputType == CXEditLabelInputTypeNumber) {
        NSString *text = [self.content stringByReplacingOccurrencesOfString:@"元" withString:@""];
        if (trim(text).length) {
            return [NSDecimalNumber decimalNumberWithString:text].stringValue;
        }
        return nil;
    }
    return self.content;
}

- (void)textView:(CXTextView *)textView heightWhenTextViewEdit:(CGFloat)height {
    if (self.inputType == CXEditLabelInputTypeCustomPhone) {
        UITextView *tv = [textView valueForKey:@"_textView"];
        NSString *text = trim(tv.text);
        NSMutableString *filterdString = [NSMutableString stringWithString:@""];
        for (NSInteger i = 0; i < text.length; i++) {
            NSString *ch = [text substringWithRange:NSMakeRange(i, 1)];
            NSString *reg = @"^[0-9-]$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
            BOOL isValidChar = [pred evaluateWithObject:ch];
            if (isValidChar) {
                [filterdString appendString:ch];
            }
        }
        tv.text = filterdString;
    }
}

#pragma mark - 外部方法

- (void)clean {
    _selectedCCContacts = nil;
    _selectedCCDeptIdArray = nil;
    _selectedCCDeptArray = nil;

    _selectedApproval = nil;
    _selectedCCUsers = nil;
    _selectedClient = nil;
    _selectedStaticDataModel = nil;
    _selectedPickerData = nil;

    _data = nil;

    self.content = nil;
}

#pragma mark - 处理

// 获取导航控制器
- (UINavigationController *)getNavigationController {
    for (UIView *view = self.superview; view; view = view.superview) {
        UIResponder *responder = (UIResponder *) view.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *) responder;
            if (vc.navigationController) {
                return vc.navigationController;
            }
        }
    }
    return nil;
}

- (UIWindow *)getKeyboardWindow {
    UIWindow *keyboardWindow;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        for (UIWindow *win in [UIApplication sharedApplication].windows) {
            if ([NSStringFromClass(win.class) isEqualToString:@"UIRemoteKeyboardWindow"]) {
                keyboardWindow = win;
                break;
            }
        }
    } else {
        keyboardWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    return keyboardWindow;
}

@end

@implementation CXEditLabel (UILabelProperty)

- (UIColor *)textColor {
    return self.internalLabel.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    self.internalLabel.textColor = textColor;
}

- (UIFont *)font {
    return self.internalLabel.font;
}

- (void)setFont:(UIFont *)font {
    self.internalLabel.font = font;
}

- (NSInteger)numberOfLines {
    return self.internalLabel.numberOfLines;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    self.internalLabel.numberOfLines = numberOfLines;
}

- (NSString *)text {
    return self.internalLabel.text;
}

- (void)setText:(NSString *)text {
    self.internalLabel.text = text;
}

- (NSAttributedString *)attributedText {
    return self.internalLabel.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.internalLabel.attributedText = attributedText;
}

- (NSTextAlignment)textAlignment {
    return self.internalLabel.textAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.internalLabel.textAlignment = textAlignment;
}

@end


@implementation CXEditLabel (HelpProperties)

- (CGFloat)textHeight {
    return [self.internalLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX)].height;
}

- (CGFloat)paddingTopBottom {
    return (GET_HEIGHT(self) - self.textHeight) / 2;
}

@end
