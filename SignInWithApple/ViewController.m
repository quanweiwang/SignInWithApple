//
//  ViewController.m
//  SignInWithApple
//
//  Created by 王权伟 on 2019/12/19.
//  Copyright © 2019 王权伟. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface ViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化UI
    [self initUI];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}

- (void)initUI {
   
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    
    // iOS13 才支持 系统提供的 登录按钮 要做下判断
    if (@available(iOS 13.0, *)) {
        // Sign In With Apple 按钮
        ASAuthorizationAppleIDButton *appleIDBtn1 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
        appleIDBtn1.frame = CGRectMake(30, 60, self.view.bounds.size.width - 60, 40);
        
        [appleIDBtn1 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn1];
        
        ASAuthorizationAppleIDButton *appleIDBtn2 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        appleIDBtn2.frame = CGRectMake(30, 120, self.view.bounds.size.width - 60, 40);
        
        [appleIDBtn2 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn2];
        
        ASAuthorizationAppleIDButton *appleIDBtn3 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDBtn3.frame = CGRectMake(30, 180, self.view.bounds.size.width - 60, 40);
        
        [appleIDBtn3 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn3];

        ASAuthorizationAppleIDButton *appleIDBtn4 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeContinue style:ASAuthorizationAppleIDButtonStyleWhite];
        appleIDBtn4.frame = CGRectMake(30, 240, self.view.bounds.size.width - 60, 40);
        [appleIDBtn4 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn4];

        ASAuthorizationAppleIDButton *appleIDBtn5 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeContinue style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        appleIDBtn5.frame = CGRectMake(30, 300, self.view.bounds.size.width - 60, 40);

        [appleIDBtn5 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn5];

        ASAuthorizationAppleIDButton *appleIDBtn6 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeContinue style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDBtn6.frame = CGRectMake(30, 360, self.view.bounds.size.width - 60, 40);

        [appleIDBtn6 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn6];
    }
    
    if (@available(iOS 13.2, *)) {
        ASAuthorizationAppleIDButton *appleIDBtn7 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignUp style:ASAuthorizationAppleIDButtonStyleWhite];
        appleIDBtn7.frame = CGRectMake(30, 420, self.view.bounds.size.width - 60, 40);
        
        [appleIDBtn7 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn7];
        
        ASAuthorizationAppleIDButton *appleIDBtn8 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignUp style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        appleIDBtn8.frame = CGRectMake(30, 480, self.view.bounds.size.width - 60, 40);

        [appleIDBtn8 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn8];

        ASAuthorizationAppleIDButton *appleIDBtn9 = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignUp style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDBtn9.frame = CGRectMake(30, 540, self.view.bounds.size.width - 60, 40);

        [appleIDBtn9 addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn9];
            
    }
    
    // 或者自己用UIButton实现按钮样式
    UIButton * signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(30, 600, self.view.bounds.size.width - 60, 40);
    signBtn.backgroundColor = [UIColor orangeColor];
    [signBtn setTitle:@"Sign in with Apple" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(didCustomBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signBtn];
}

#pragma mark- 按钮点击事件
// 自己用UIButton按钮调用处理授权的方法
- (void)didCustomBtnClicked{
    // 授权苹果ID
    [self authorizationAppleID];
}

// 使用系统提供的按钮调用处理授权的方法
- (void)didAppleIDBtnClicked{
    // 授权苹果ID
    [self authorizationAppleID];
}

#pragma mark- 授权苹果ID
- (void)authorizationAppleID {
    
    if (@available(iOS 13.0, *)) {
        
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];

        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
//        if (passwordRequest) {
//            [array addObject:passwordRequest];
//        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
        
    } else {
        // 处理不支持系统版本
        NSLog(@"系统不支持Apple登录");
    }
}

#pragma mark- ASAuthorizationControllerDelegate
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString * userID = credential.user;
        
        // 苹果用户信息 如果授权过，可能无法再次获取该信息
        NSPersonNameComponents * fullName = credential.fullName;
        NSString * email = credential.email;
        
        // 服务器验证需要使用的参数
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        
        // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"appleID"];
        
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString * user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString * password = passwordCredential.password;
        
        NSLog(@"userID: %@", user);
        NSLog(@"password: %@", password);
        
    } else {
        
    }
}

// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    
    return self.view.window;
}

#pragma mark- apple授权状态 更改通知
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

@end
