//
//  LFRouter.m
//  BluChat
//
//  Created by 福有李 on 2018/1/11.
//  Copyright © 2018年 Bluchat. All rights reserved.
//

#import "LFRouter.h"
#import "LFRouterContext.h"
#import "LFRouter+Config.h"

#define NSStringFromObject(x) ([NSString stringWithFormat:@"%p",x])
//树型结构里保存的model.防止扩展数据
@interface LFRouterItem : NSObject
@property (nonatomic,strong) LFRouterHandle handle;
@end

@implementation LFRouterItem
@end


//临时解析的数据
@interface LFRouterParseTmpModel : NSObject
@property (nonatomic,strong) LFRouterItem *item;
@property (nonatomic,strong) NSMutableDictionary *params;
@end

@implementation LFRouterParseTmpModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.params = [NSMutableDictionary dictionary];
    }
    return self;
}
@end

//节点，有可能是Item
@interface LFRouterParseDBItem : NSObject
@property (nonatomic,strong) NSMutableDictionary *dictionary;
@property (nonatomic,strong) LFRouterItem *item;
@end;

@implementation LFRouterParseDBItem
@end

@interface LFRouter (){
    NSMutableDictionary *_parseDB;
    
    NSMutableDictionary <NSString *,LFRouterCompletion> *_ccm;
}

@end

@implementation LFRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _parseDB = [NSMutableDictionary new];
        _ccm = [NSMutableDictionary new];
    }
    return self;
}

+(instancetype)instance{
    static dispatch_once_t onceToken;
    static LFRouter *__router;
    dispatch_once(&onceToken, ^{
        __router = [[self alloc]init];
    });
    return __router;
}



//callback
-(void)contextFinish:(LFRouterContext *)object error:(NSError *)error{
    
    LFRouterCompletion completion = [_ccm objectForKey:NSStringFromObject(object)];
    if (completion == nil) {
        return;
    }
    //...
    completion(error);
    [_ccm removeObjectForKey:NSStringFromObject(object)];
}

//use

-(void)open:(NSString *)url params:(NSDictionary *)params{
    [self open:url params:params animated:YES completion:nil];
}
-(void)open:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated completion:(LFRouterCompletion)completion{
    
    if (completion == nil) {
        completion = ^(NSError *error){
            if (error != nil) {
                NSLog(@"warning : %@",error.localizedDescription);
            }
        };
    }
    LFRouterParseTmpModel *tmpModel =  [self itemFromKey:url];
    
    if(tmpModel == nil) {
        completion([NSError errorWithDomain:@"run.pvp.error.parse" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"没有找到对应的模块，请检查一下url是否正确，及有没有配置这个模块"}]);
        return;
    };
    
    NSMutableDictionary *goalParams = [NSMutableDictionary dictionaryWithDictionary:tmpModel.params];
    [goalParams addEntriesFromDictionary:[self queryParamsWithURLString:url]];
    [goalParams addEntriesFromDictionary:params];
    
    ;
    LFRouterContext *context = [LFRouterContext instanceWithParams:goalParams animated:animated withOwner:self];
    [_ccm setObject:completion forKey:NSStringFromObject(context)];
    tmpModel.item.handle(context);
}


-(NSDictionary *)queryParamsWithURLString:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *queryParamsStrings = [url.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    for (NSString *paramString in queryParamsStrings) {
        NSArray *qparams = [paramString componentsSeparatedByString:@"="];
        if (qparams.count >= 2) {
            [queryParams setObject:qparams[1] forKey:qparams[0]];
        }
    }
    return queryParams;
}

-(LFRouterParseTmpModel *)itemFromKey:(NSString *)key{
    
    NSString *baseString = [self baseStringFromPath:key];
    
    NSArray *keys = [baseString componentsSeparatedByString:@"/"];

    return [self _parseKeyArray:keys baseDB:_parseDB];
}

-(LFRouterParseTmpModel *)_parseKeyArray:(NSArray *)keys baseDB:(NSDictionary *)baseDB{
    
    //获取有效的key
    NSMutableArray *validKeys = [NSMutableArray array];
    NSArray *allKeys = [baseDB allKeys];
    
    for (NSString *key in allKeys) {
        if ([key hasPrefix:@":"]) {
            [validKeys addObject:key];
        }
    }
    if (baseDB[keys.firstObject] != nil) {
        [validKeys addObject:keys.firstObject];
    }
    
    //如果没有有效的key 退出
    if (validKeys.count == 0) {
        return nil;
    }
    
    for (NSString *key in validKeys) {
        LFRouterParseDBItem *dbItem = baseDB[key];
        LFRouterParseTmpModel *tmpModel = nil;
        
        if (dbItem != nil ) {
            
            if (keys.count > 1) {
                if (dbItem.dictionary != nil) {
                    NSArray *newKeys = [keys subarrayWithRange:NSMakeRange(1, keys.count - 1)];
                    tmpModel = [self _parseKeyArray:newKeys baseDB:dbItem.dictionary];
                }
            }else{
                if (dbItem.item != nil) {
                    tmpModel = [LFRouterParseTmpModel new];
                    tmpModel.item = dbItem.item;
                }
            }
            
            //找到了
            if (tmpModel != nil) {
                //看看当前路径是不是需要的参数
                if([key hasPrefix:@":"]){
                    //解析参数
                    [tmpModel.params setObject:keys.firstObject forKey:[key substringFromIndex:1]];
                }
                return tmpModel;
            }
        }

    }
    return nil;
}

//----config
-(void)addKeys:(NSArray<const NSString *> *)keys command:(LFRouterHandle)handle{
    LFRouterItem *item = [LFRouterItem new];
    item.handle = handle;
    for (NSString *key in keys) {
        [self _addKey:key value:item];
    }
}

-(void)_addKey:(NSString *)path value:(LFRouterItem *)item{
    //树型结构，保存
    NSArray *keys = [[self baseStringFromPath:path] componentsSeparatedByString:@"/"];
    [self _addKey:keys value:item baseDictionary:_parseDB];
}

-(void)_addKey:(NSArray *)paths value:(LFRouterItem *)value baseDictionary:(NSMutableDictionary *)baseDictionary{
    
    LFRouterParseDBItem *dbItem = baseDictionary[paths.firstObject];
    
    if (dbItem == nil) {
        dbItem = [LFRouterParseDBItem new];
        [baseDictionary setValue:dbItem forKey:paths.firstObject];
    }
    
    if (paths.count == 1) {
        dbItem.item = value;
    }else{
        NSMutableDictionary *dic = dbItem.dictionary;
        if (dic == nil) {
            dic = [NSMutableDictionary dictionary];
            dbItem.dictionary = dic;
        }
        [self _addKey:[paths subarrayWithRange:NSMakeRange(1, paths.count -1)] value:value baseDictionary:dbItem.dictionary];
    }
    
    
}

//totals

-(NSString *)baseStringFromPath:(NSString *)path{
    
    NSRange range = [path rangeOfString:@"?"];
    NSString *baseString = path;
    if (range.location != NSNotFound) {
         baseString = [path substringToIndex:range.location];
    }
    
    if ([baseString hasSuffix:@"/"]) {
        baseString = [baseString substringToIndex:baseString.length - 1];
    }
    return baseString;
}
@end
