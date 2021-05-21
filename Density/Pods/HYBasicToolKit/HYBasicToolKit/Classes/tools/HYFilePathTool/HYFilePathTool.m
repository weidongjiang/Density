//
//  HYFilePathTool.m
//  HYBasicToolKit
//
//  Created by 蒋伟东 on 2021/4/30.
//

#import "HYFilePathTool.h"

@interface HYFilePathTool ()
@property (nonatomic, readwrite, strong)   NSString    *homePath;
@property (nonatomic, readwrite, strong)   NSString    *docmentsPath;
@property (nonatomic, readwrite, strong)   NSString    *dbPath;
@property (nonatomic, readwrite, strong)   NSString    *libraryPath;
@property (nonatomic, readwrite, strong)   NSString    *tmpPath;
@property (nonatomic, readwrite, strong)   NSString    *cachesPath;
@property (nonatomic, readwrite, strong)   NSString    *preferencesPath;
@property (nonatomic, readwrite, strong)   NSString    *bundlePath;
@property (nonatomic, readwrite, strong)   NSString    *downloadPath;
@property (nonatomic, readwrite, strong)   NSString    *coredataPath;

@end

@implementation HYFilePathTool
+ (HYFilePathTool *)sharedInstance {
    static HYFilePathTool *mpFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mpFilePath = [[self alloc] init];
    });
    return mpFilePath;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDirPath];
    }
    return self;
}

- (void)initDirPath {
    self.homePath = NSHomeDirectory();
    self.docmentsPath = [self.homePath stringByAppendingPathComponent:@"Documents"];
    self.libraryPath = [self.homePath stringByAppendingPathComponent:@"Library"];
    self.tmpPath = [self.homePath stringByAppendingPathComponent:@"tmp"];
    self.cachesPath = [self.homePath stringByAppendingPathComponent:@"Library/Caches"];
    self.preferencesPath = [self.homePath stringByAppendingPathComponent:@"Library/Preferences"];
    self.bundlePath = [[NSBundle mainBundle] bundlePath];
    self.downloadPath = [self.homePath stringByAppendingPathComponent:@"Library/Caches/Download"];
    self.coredataPath = [self.homePath stringByAppendingPathComponent:@"Library/Caches/CoreData"];
   
    [self createDirPathIfNeed:self.homePath];
    [self createDirPathIfNeed:self.docmentsPath];
}

- (NSString *)createDirPathIfNeed:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:dirPath] ) {
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    return dirPath;
}

@end
