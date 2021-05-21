//
//  NSObject+HYAssociatedObject.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/29.
//

#import "NSObject+HYAssociatedObject.h"

@implementation NSObject (HYAssociatedObject)
- (id)hy_objectWithAssociatedKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)hy_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retain
{
    objc_setAssociatedObject(self, key, object, retain?OBJC_ASSOCIATION_RETAIN_NONATOMIC:OBJC_ASSOCIATION_ASSIGN);
}

- (void)hy_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, key, object, policy);
}
@end
