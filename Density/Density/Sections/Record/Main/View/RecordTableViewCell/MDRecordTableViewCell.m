//
//  MDRecordTableViewCell.m
//  Density
//
//  Created by 蒋伟东 on 2021/5/24.
//

#import "MDRecordTableViewCell.h"

@implementation MDRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor yellowColor];
        [self setUpUI];
        [self setEditing:YES animated:YES];
    }
    return self;
}

- (void)setUpUI {
    
    
}

@end


NSString *const MDRecordTableViewCellID = @"MDRecordTableViewCellID";
CGFloat const MDRecordTableViewCellHeight = 300;
