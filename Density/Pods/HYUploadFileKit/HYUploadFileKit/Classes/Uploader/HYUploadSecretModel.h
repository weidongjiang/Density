//
//  HYUploadSecretModel.h
//  AIPhotos
//
//  Created by 蒋伟东 on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYUploadSecretModel : NSObject

@property (nonatomic, copy) NSString *cdn_host;
@property (nonatomic, copy) NSString *secret_id;
@property (nonatomic, copy) NSString *secret_key;
@property (nonatomic, copy) NSString *security_token;//token
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, assign) double current_time;
@property (nonatomic, assign) double expire_time;//token过期时间戳

@end

NS_ASSUME_NONNULL_END
