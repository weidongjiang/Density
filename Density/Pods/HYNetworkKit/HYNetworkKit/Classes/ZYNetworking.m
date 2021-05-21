//
//  ZYNetworking.m
//  ZYNetworkingDemo
//
//  Created by 朱玉 on 16/4/5.
//  Copyright © 2016年 liuxin. All rights reserved.
//


#import "ZYNetworking.h"
#import "AFNetworking.h"
#import "AFmanager.h"
#import <CommonCrypto/CommonDigest.h>
#import <HYBasicToolKit/HYUtilsMacro.h>


@interface ZYNetworking()

@property(nonatomic,strong) NSMutableArray *tasks;
@end

static NSMutableArray *tasks;
@implementation ZYNetworking

+ (ZYNetworking *)sharedZYNetworking
{
    static ZYNetworking *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[ZYNetworking alloc] init];
    });
    return handler;
}

- (NSMutableArray *)tasks{
    if (_tasks == nil) {
        tasks = [[NSMutableArray alloc] init];
    }
    return tasks;
}

-(ZYURLSessionTask *)getWithUrl:(NSString *)url
                         params:(NSDictionary *)params
                        success:(ZYResponseSuccess)success
                           fail:(ZYResponseFail)fail
                        showHUD:(BOOL)showHUD{
    
    return [self baseRequestType:1 url:url params:params success:success fail:fail showHUD:showHUD];
    
}

-(ZYURLSessionTask *)postWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(ZYResponseSuccess)success
                            fail:(ZYResponseFail)fail
                         showHUD:(BOOL)showHUD{
    return [self baseRequestType:2 url:url params:params success:success fail:fail showHUD:showHUD];
}


-(ZYURLSessionTask *)baseRequestType:(NSUInteger)type
                                 url:(NSString *)url
                              params:(NSDictionary *)params
                             success:(ZYResponseSuccess)success
                                fail:(ZYResponseFail)fail
                             showHUD:(BOOL)showHUD{
    
    if (url == nil) {
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self getAFManager];
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url:[self strUTF8Encoding:url];
    
    ZYURLSessionTask *sessionTask = nil;
    
    if (type== 1) {
        sessionTask = [manager GET:urlStr parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        success(responseObject);
                    }
                    
                    [[self tasks] removeObject:sessionTask];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (fail) {
                        fail(error);
                    }
                    
                    [[self tasks] removeObject:sessionTask];
                }];

        
    }else{
        sessionTask = [manager POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            
            [[self tasks] removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }
            [[self tasks] removeObject:sessionTask];
        }];
    }
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
    
    
}


-(ZYURLSessionTask *)uploadWithImage:(UIImage *)image
                                 url:(NSString *)url
                            filename:(NSString *)filename
                                name:(NSString *)name
                              params:(NSDictionary *)params
                            progress:(ZYUploadProgress)progress
                             success:(ZYResponseSuccess)success
                                fail:(ZYResponseFail)fail
                             showHUD:(BOOL)showHUD{
    
//    HYDebugLog(@"请求地址----%@\n    请求参数----%@",url,params);
    if (url==nil) {
        return nil;
    }
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    AFHTTPSessionManager *manager=[self getAFManager];
    
    ZYURLSessionTask *sessionTask = [manager POST:urlStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        HYDebugLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);

        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        HYDebugLog(@"上传图片成功=%@",responseObject);
        if (success) {
            success(responseObject);
        }
        
        [[self tasks] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        HYDebugLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
        
        [[self tasks] removeObject:task];
    }];
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

- (ZYURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(ZYDownloadProgress)progressBlock
                              success:(ZYResponseSuccess)success
                              failure:(ZYResponseFail)fail
                              showHUD:(BOOL)showHUD{
    
    
//    HYDebugLog(@"请求地址----%@\n    ",url);
    if (url==nil) {
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self getAFManager];
    
    ZYURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
//        HYDebugLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!saveToPath) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            HYDebugLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            return [NSURL fileURLWithPath:saveToPath];
            
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        HYDebugLog(@"下载文件成功");
        
        [[self tasks] removeObject:sessionTask];
        
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
            }
            
        } else {
            if (fail) {
                fail(error);
            }
        }
        
        
    }];
    
    //开始启动任务
    [sessionTask resume];
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
    
    
}

- (ZYURLSessionTask *)downloadAndSaveToPhotoLibraryWithUrl:(NSString *)url
                                                saveToPath:(NSString *)saveToPath
                                                  progress:(ZYDownloadProgress)progressBlock
                                                   success:(ZYResponseSuccess)success
                                                   failure:(ZYResponseFail)fail
                                                   showHUD:(BOOL)showHUD{
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self getAFManager];
    
    ZYURLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
//        HYDebugLog(@"下载进度--%.1f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!saveToPath) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            HYDebugLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            return [NSURL fileURLWithPath:saveToPath];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        HYDebugLog(@"下载文件成功");
        
        [[self tasks] removeObject:sessionTask];
        
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
                //将文件保存到系统相册
                //3，保存视频到相册
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([filePath path])) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
        } else {
            if (fail) {
                fail(error);
            }
        }
    }];
    //开始启动任务
    [sessionTask resume];
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}

/** 移除下载文件 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    HYDebugLog(@"保存视频完成");
    //移除item
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:videoPath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:videoPath error:&err];
    }
}


- (AFHTTPSessionManager *)getAFManager{
    AFHTTPSessionManager *manager = [AFmanager shareManager];
//    __weak typeof(manager) weakManager = manager;
//    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential) {
//        //证书校验替换IP
//        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//
//        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//
//            NSString *originHost = weakManager.requestSerializer.HTTPRequestHeaders[@"host"];
//            if (!originHost) {
//                originHost = challenge.protectionSpace.host;
//            }
//            if ([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:originHost]) {//这个方法是校验ssl的关键校验时需要把IP替换成原始host
//                *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//                if (credential) {
//                    disposition = NSURLSessionAuthChallengeUseCredential;
//                } else {
//                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//                }
//            } else {
//                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//            }
//        } else {
//            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        }
//        return disposition;
//    }];
    return manager;
}

#pragma makr - 开始监听网络连接

- (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                HYDebugLog(@"未知网络");
                if (self.networkStats == StatusUnknown) {
                    return;
                }
                self.networkStats = StatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                HYDebugLog(@"没有网络");
                if (self.networkStats == StatusNotReachable) {
                    return;
                }
                self.networkStats = StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                HYDebugLog(@"手机自带网络");
                if (self.networkStats == StatusReachableViaWWAN) {
                    return;
                }
                self.networkStats = StatusReachableViaWWAN;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkRecovery" object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                if (self.networkStats == StatusReachableViaWiFi) {
                    return;
                }
                self.networkStats = StatusReachableViaWiFi;
//                HYDebugLog(@"WIFI--%d",[ZYNetworking sharedZYNetworking].networkStats);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkRecovery" object:nil];
                break;
        }
    }];
    [mgr startMonitoring];
}


-(NSString *)strUTF8Encoding:(NSString *)str{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
//    HYDebugLog(@"%@ appleLanguages",allLanguages);
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    return preferredLang;
    
}

@end
