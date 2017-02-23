//
//  AddViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ReserveViewController.h"

@interface ReserveViewController ()<UITextViewDelegate,UITextFieldDelegate>

{
    UITextField *tmpTextField;
    UILabel *placeHoldLabel;
    UITextView *myTextView;
    UITextField *myTextField;
}

@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航栏
    [self setVCName:@"厂房预定" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    [self addRightItemWithString:@"下一步" andItemTintColor:GREEN_19b8];
    
    self.view.backgroundColor = GRAY_F5;
    [self drawView];
}

// 返回按钮
- (void)backAction {
    
    [myTextField resignFirstResponder];
    [myTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 下一步按钮
- (void)rightItemButtonAction {
    [myTextField resignFirstResponder];
    
    if (myTextView.text.length < 2) {
        [MBProgressHUD showError:@"请输入长度大于2的要求" ToView:nil];
        return;
    }
    if (myTextView.text.length > 400) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"您超过了%lu个数字",myTextView.text.length - 400] ToView:nil];
        [tmpTextField becomeFirstResponder];
        return;
    }
    
    CGFloat callBackDay = [tmpTextField.text floatValue];
    
    if (callBackDay < 0 || callBackDay >180) {
        [MBProgressHUD showError:@"请输入1~180天内回复" ToView:nil];
        return;
    }
    
    NSDictionary *requestDic = @{@"content":myTextView.text,@"callback_day":@(callBackDay)};
    
    NSString *requestSrt = [NSString dictionaryToJson:requestDic];
    
    NSDictionary *paramDic = @{@"publishNeed":requestSrt};
    
    [HTTPREQUEST_SINGLE postRequestWithService:URL_POST_NEEDEDMESSAGE andParameters:paramDic isShowActivity:YES dicIsEncode:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"需求信息发布：%@",response);
        
        [MBProgressHUD showSuccess:response[@"erro_msg"] ToView:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"%@",error.debugDescription);
//        [MBProgressHUD showError:error.debugDescription ToView:nil];
    }];
    
    NSLog(@"%@",tmpTextField.text);
}
// 绘制界面
- (void)drawView {
    
    NSArray *titleArray = @[@"厂房详情描述",@"匹配时间（选择时间匹配相对信息推送）"];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, i * Screen_Height * 167/568, Screen_Width, Screen_Height*33/568)];
        
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
        label.textColor = GRAY_80;
        [self.view addSubview:label];
    }
    
    ////////////// 绘制输入框
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height*33/568, Screen_Width, Screen_Height*135/568)];
    
    inputView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:inputView];
    
    // 绘制线条
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
    line1.backgroundColor = GRAY_cc;
    [inputView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, inputView.frame.size.height-0.5, Screen_Width, 0.5)];
    line2.backgroundColor = GRAY_cc;
    [inputView addSubview:line2];
    
    // 初始化 textView
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(14, 8, Screen_Width-28, inputView.frame.size.height-23)];
    myTextView.delegate = self;
    myTextView.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
    [inputView addSubview:myTextView];
    
    // 提示文字
    placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, myTextView.frame.size.width, 20)];
    placeHoldLabel.textColor = GRAY_80;
    placeHoldLabel.text = @"您好，请描述您需要的厂房内容/详情……";
    placeHoldLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
    [myTextView addSubview:placeHoldLabel];
    
    // 初始化 文字提示的label
    UILabel *textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, inputView.frame.size.height-22, Screen_Width-16, 22)];
    textNumLabel.text = @"2-400字";
    textNumLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
    textNumLabel.textColor = GRAY_cc;
    textNumLabel.textAlignment = NSTextAlignmentRight;
    [inputView addSubview:textNumLabel];
    
    //////////// 绘制推送时间
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height*25/71, Screen_Width, Screen_Height*11/142)];
    timeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeView];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
    line3.backgroundColor = GRAY_cc;
    [timeView addSubview:line3];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, timeView.frame.size.height-0.5, Screen_Width, 0.5)];
    line4.backgroundColor = GRAY_cc;
    [timeView addSubview:line4];
    
    NSArray *timeArray = @[@"1天",@"7天",@"30天",@"其他"];
    
    for (int i = 0; i < 4; i++) {
        myTextField = [[UITextField alloc] initWithFrame:CGRectMake(15+(15+Screen_Width*53/320)*i, timeView.frame.size.height*7/44, Screen_Width*53/320, timeView.frame.size.height*15/22)];
        myTextField.textColor = GRAY_80;
        myTextField.text = timeArray[i];
        myTextField.textAlignment = NSTextAlignmentCenter;
        myTextField.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        
        myTextField.tag = 1000+i;
        myTextField.delegate = self;
        
        myTextField.layer.borderColor = GRAY_80.CGColor;
        myTextField.layer.borderWidth = 0.5;
        myTextField.layer.cornerRadius = 5;
        myTextField.layer.masksToBounds = YES;
        [timeView addSubview:myTextField];
        
        myTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [myTextView resignFirstResponder];
}

#pragma mark - textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    placeHoldLabel.hidden = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length <= 0) {
        placeHoldLabel.hidden = NO;
    } else {
        placeHoldLabel.hidden = YES;
    }
    
}

#pragma mark - uitextfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // 将上一个 textField 设置为白底黑色
    tmpTextField.textColor = GRAY_80;
    tmpTextField.backgroundColor = [UIColor whiteColor];
    
    if (textField.tag < 1003) {
        [myTextField resignFirstResponder];
        textField.textColor = [UIColor whiteColor];
        textField.backgroundColor = GREEN_19b8;
        
        tmpTextField = textField;
        return NO;
    }
    textField.textColor = [UIColor whiteColor];
    textField.backgroundColor = GREEN_19b8;
    textField.text = @"";
    
    tmpTextField = textField;
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![NSString validatePureNumandCharacters:textField.text]) {
        [MBProgressHUD showError:@"请输入纯数字！" ToView:nil];
        
        return;
    }
    
    [textField resignFirstResponder];
    
    textField.textColor = [UIColor whiteColor];
    textField.backgroundColor = GREEN_19b8;
    
    textField.text = [NSString stringWithFormat:@"%@天",textField.text];
    
    // 将上一个 textField 设置为白底黑色
    tmpTextField.textColor = GRAY_80;
    tmpTextField.backgroundColor = [UIColor whiteColor];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
