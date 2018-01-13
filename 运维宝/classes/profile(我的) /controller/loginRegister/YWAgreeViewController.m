//
//  YWAgreeViewController.m
//  运维宝
//
//  Created by zhang shuai on 2018/1/13.
//  Copyright © 2018年 com.stlm. All rights reserved.
//

#import "YWAgreeViewController.h"

@interface YWAgreeViewController ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation YWAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self textView];
    
}

- (UITextView *)textView{
    if (_textView == nil) {
        UITextView *view = [[UITextView alloc] init];
        view.editable = NO;
        view.showsVerticalScrollIndicator = NO;
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 20 - 49);
        view.text = @"    在使用运维宝APP前，请您务必仔细阅读并透彻理解本服务条款。一旦您注册，即表示您认可并接受本应服务条款现有内容及其可能随时更新的内容：\n\n    运维宝尊重并保护所有使用者的个人隐私权，您注册的用户名、电子邮件地址等个人资料，除非经您亲自许可，或根据相关法律、法规的强制性规定须披露外，运维宝不会主动地泄露、转让、提供给第三方。\n\n    因网络状况、通讯线路、服务器或服务商等任何原因而导致您不能正常使用，运维宝不承担任何法律责任。某些服务需要电话、数据访问或短信功能支持，您可能需要支付给第三方相应费用。\n\n    为了提供更好的服务，运维宝会收集一些移动设备特定信息（例如，您的设备和硬件 ID 以及设备类型、您的请求类型（即：您使用本服务时，向运维宝发起的请求类型、请求内容等），这可能是独一无二的，或是包含您认为是私人信息的内容，但这些信息并不能够让运维宝识别您的身份。除此之外，运维宝将对上述信息实施技术保护措施，以最大程度保护这些信息不被第三方非法获得，同时，您可以自行选择拒绝基于技术必要性收集这些信息，并自行承担不能获得或享用相应服务的后果。 \n\n    由于您的自身行为或不可抗力等情形，导致上述可能涉及您隐私或您认为是私人信息的内容发生被泄露、披露，或被第三方获取、使用、转让等情形的，均由您自行承担不利后果，运维宝对此不承担任何责任。\n\n    运维宝是监测和管理设备的物联网应用，一旦您注册，将不可避免的会采集您的某些设备运行数据，采集的数据是基于物理硬件的提供，运维宝仅仅采集和存储这些设备运行数据，运维宝不具有发送控制设备和任何改变设备运行状态的数据和指令的功能，在任何情况下运维宝均不会控制您的设备。\n\n    运维宝采集的所有设备运行数据均存储于阿里云服务器上，并实施相应的安全保护措施及权限管理，运维宝以最大程度保护这些数据不被第三方非法获得，运维宝不会主动地把采集到的数据泄露、转让、提供给第三方用于盈利性商业目的。因网络状况、通讯线路、服务器或客户等任何原因而导致数据的丢失和泄露，运维宝不承担任何法律责任。\n\n    运维宝提供基于数据分析的事件报警、消息推送和状态评估服务，这些报警、消息和评估结果对于设备监测是必要的，在专业技术情形下，这些事件报警和消息推送服务及评估结果能够提醒、提示、建议您对您的设备引起足够的关注，并采取必要的技术手段避免您的设备处于危险情形之下。但由于技术原因或未知的原因导致的误报、误判、漏报、分析偏差等情况，运维宝不承担任何法律责任。\n\n    运维宝在法律法规许可的范围内对本服务条款享有解释权。\n\n    本服务条款的订立、执行和解释及争议的解决均应适用中华人民共和国法律。";
        view.font = FONT_16;
        view.textColor = [UIColor blackColor];
        [self.view addSubview:view];
        _textView = view;
    }
    return _textView;
}

@end
