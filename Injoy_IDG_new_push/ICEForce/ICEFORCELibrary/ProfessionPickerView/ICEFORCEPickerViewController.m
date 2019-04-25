//
//  ICEFORCEPickerViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPickerViewController.h"

@interface ICEFORCEPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic ,strong) NSMutableArray *oneArray;
@property (nonatomic ,strong) NSMutableArray *twoArray;

@property (nonatomic ,assign) NSInteger proIndex;
@property (nonatomic ,assign) NSInteger selIndex;
@end

@implementation ICEFORCEPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.oneArray = [[NSMutableArray alloc]init];
    self.twoArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        NSMutableArray *two = [[NSMutableArray alloc]init];
        NSDictionary *dic = [self.dataArray objectAtIndex:i];
        ICEFORCEPickerModel *model = [ICEFORCEPickerModel modelWithDict:dic];
        
        for (NSDictionary *twoDic in [dic objectForKey:@"children"]) {
            ICEFORCEPickerModel *twoModel = [ICEFORCEPickerModel modelWithDict:twoDic];
            [two addObject:twoModel];
        }
        
        [self.oneArray addObject:model];
        [self.twoArray addObject:two];
    }
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return [self.oneArray count];
    }else{
        
        return [[self.twoArray objectAtIndex:_proIndex] count];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)componen{
    
    return 40;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        
        ICEFORCEPickerModel *model = [self.oneArray objectAtIndex:row];
     
        NSString *oneString = model.codeNameZhCn;
        return oneString;
    }else{
        NSArray *other = [self.twoArray objectAtIndex:_proIndex];
        ICEFORCEPickerModel *model = [other objectAtIndex:row];
        NSString *twoString = model.codeNameZhCn;;
        return twoString;
    }
    
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        _proIndex = [pickerView selectedRowInComponent:0];
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _selIndex = 0;
    }
    if (component == 1) {
        _selIndex = row;
    }
 
   
    
}
- (IBAction)sureButton:(UIButton *)sender {
    
    NSArray *other = [self.twoArray objectAtIndex:_proIndex];
    if (_selIndex > other.count) {
        _selIndex = 0;
    }
    ICEFORCEPickerModel *model = [other objectAtIndex:_selIndex];
    if (self.SelectBlock) {
        self.SelectBlock(model);
    }
    [self dismissView];
}
- (IBAction)cancelButton:(UIButton *)sender {
    
    [self dismissView];
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    [self dismissView];
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
