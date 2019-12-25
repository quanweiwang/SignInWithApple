//
//  AppDelegate.m
//  SignInWithApple
//
//  Created by 王权伟 on 2019/12/19.
//  Copyright © 2019 王权伟. All rights reserved.
//

#import "AppDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
            
    if (@available(iOS 13.0, *)) {
        
        // 注意 存储用户标识信息需要使用钥匙串来存储 这里使用NSUserDefaults 做的简单示例
        NSString *userIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"appleID"];
        
        if (userIdentifier) {
            
            ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            
            [appleIDProvider getCredentialStateForUserID:userIdentifier
                                              completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        // 授权状态有效
                        break;
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        // 苹果账号登录的凭据已被移除，需解除绑定并重新引导用户使用苹果登录
                        break;
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        // 未登录授权，直接弹出登录页面，引导用户登录
                        break;
                    case ASAuthorizationAppleIDProviderCredentialTransferred:
                        // 授权AppleID提供者凭据转移
                        break;
                }
            }];
        }
        
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
