//
//  ThreadModel.m
//  DiscuzMobile
//
//  Created by HB on 17/3/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ThreadModel.h"
#import "ThreadListModel.h"
#import "LoginModule.h"

@interface ThreadModel()

@end

@implementation ThreadModel

// MARK: - 通过这个set方法获取所有的model参数
- (void)setThreadDic:(NSDictionary *)threadDic {
    NSDictionary *varDic = [threadDic objectForKey:@"Variables"];
    _threadDic = threadDic;
    NSDictionary *thread = [varDic objectForKey:@"thread"];
    
    self.favorited = @"0";
    self.recommend = @"0";
    if ([DataCheck isValidString:[thread objectForKey:@"favorited"]]) {
        self.favorited = [thread objectForKey:@"favorited"];
    }
    if ([DataCheck isValidString:[thread objectForKey:@"recommend"]]) {
        self.recommend = [thread objectForKey:@"recommend"];
    }
    self.specialString = [thread objectForKey:@"special"];
    self.fid = [thread objectForKey:@"fid"];
    self.replies = [[thread objectForKey:@"replies"] integerValue];
    self.subject = [thread objectForKey:@"subject"];
    self.author = [thread objectForKey:@"author"];
    if (self.currentPage == 1) {
        if ([DataCheck isValidArray:[varDic objectForKey:@"postlist"]]) {
            self.dateline = [[varDic objectForKey:@"postlist"][0] objectForKey:@"dateline"];
            self.pid = [[varDic objectForKey:@"postlist"][0] objectForKey:@"pid"];
        }
    }
    self.shareUrl = [NSString stringWithFormat:@"%@forum.php?mod=viewthread&tid=%@",BASEURL,self.tid];
    
    NSDictionary *jsonDic = [self manageJsonWitnAttchment:threadDic];
    self.jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
   
    self.ppp = [[varDic objectForKey:@"ppp"] intValue];
    self.isActivity = [self judeActivity:varDic];
    
    NSDictionary * allowperm =[varDic objectForKey:@"allowperm"];
    self.allowpost = [allowperm objectForKey:@"allowpost"];
    self.allowreply = [allowperm objectForKey:@"allowreply"];
    self.uploadhash = [allowperm objectForKey:@"uploadhash"];
    self.baseUrl = [self getBaseURL:varDic];
}

#pragma mark - 获取本地页面url
- (NSURL *)getBaseURL:(NSDictionary *)dataDic {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"thread_temp_common" ofType:@"html"];
    if ([DataCheck isValidString:self.specialString]) {
        if ([self.specialString isEqualToString:@"1"]) { // 投票贴
            if ([[[dataDic objectForKey:@"special_poll"] objectForKey:@"allowvote"] isEqualToString:@"1"] && [[[dataDic objectForKey:@"thread"] objectForKey:@"closed"] isEqualToString:@"0"]) {
                path = [[NSBundle mainBundle] pathForResource:@"thread_temp_poll" ofType:@"html"];
            } else {
                path = [[NSBundle mainBundle] pathForResource:@"thread_temp_poll_result" ofType:@"html"];
            }
        } else if ([self.specialString isEqualToString:@"4"]) {
            path = [[NSBundle mainBundle] pathForResource:@"thread_temp_activity" ofType:@"html"];
        }
//        else if ([self.specialString isEqualToString:@"5"]) { // 辩论帖
//            path = [[NSBundle mainBundle] pathForResource:@"thread_temp_debate" ofType:@"html"];
//
//        }
    }
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    return baseURL;
    
}

- (BOOL)judeActivity:(NSDictionary *)dataDic {
    // applied = 1 活动为存在;
    // 已参加或者 审批   button = cancel;  button = join;  有button Key 说明 能参加或者取消
    // closed = 0;   过期的时候为 1
    // "is_ex" = 0; 过期的时候为 1
    // applynumber 参加了几个
//    NSString * strapplied=[[dataDic objectForKey:@"special_activity"] objectForKey:@"applied"];
    NSString * strbutton=[[dataDic objectForKey:@"special_activity"] objectForKey:@"button"];
    NSString * strclosed=[[dataDic objectForKey:@"special_activity"] objectForKey:@"closed"];
//    if ([strapplied isEqualToString:@"0"]&&[DataCheck isValidString:strapplied]&&[strbutton isEqualToString:@"join"]&&[DataCheck isValidString:strbutton]&&[strclosed isEqualToString:@"0"]&&[DataCheck isValidString:strclosed]) {
//        return YES;
//        
//    }
    if ([DataCheck isValidString:strbutton] &&
        [DataCheck isValidString:strclosed]) {
        if ([strbutton isEqualToString:@"join"] &&
            [strclosed isEqualToString:@"0"]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableDictionary *)manageJsonWitnAttchment:(NSDictionary *)dataDic {
    
    [self dealWithattachment:dataDic];
    NSMutableDictionary * Variables = [dataDic objectForKey:@"Variables"];
    
    // 投票帖数据 - start
    NSMutableDictionary *special_poll = [Variables objectForKey:@"special_poll"];
    if ([DataCheck isValidDictionary:special_poll]) {
        NSMutableDictionary *polloptions  = [special_poll objectForKey:@"polloptions"];
        [polloptions enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableDictionary *imginfo = [obj objectForKey:@"imginfo"];
            if ([DataCheck isValidDictionary:imginfo]) {
                NSString *small = [[imginfo objectForKey:@"small"] makeDomain];
                NSString *big = [[imginfo objectForKey:@"big"] makeDomain];
                [imginfo setValue:small forKey:@"small"];
                [imginfo setValue:big forKey:@"big"];
            }
        }];
    }
    // 投票帖数据 - end
    
    // 活动帖数据 - start
    NSMutableDictionary * special_activity = [Variables objectForKey:@"special_activity"];
    if ([DataCheck isValidDictionary:special_activity]) { // 取活动封面图
        NSString * activityurl = [special_activity objectForKey:@"attachurl"];
        if ([DataCheck isValidString:activityurl]) {
            activityurl = [activityurl makeDomain];
            [special_activity setValue:activityurl forKey:@"attachurl"];
        }
    }
    // 活动帖数据 - end
    return dataDic.mutableCopy;
}

- (void)dealWithattachment:(NSDictionary *)dataDic {
    
    NSMutableArray * list = [[dataDic objectForKey:@"Variables"] objectForKey:@"postlist"];
    for (int i = 0; i<list.count; i++) {
        NSDictionary * item = [list objectAtIndex:i];
        
        NSMutableDictionary *attachmentsDic = [item objectForKey:@"attachments"];
        if ([DataCheck isValidDictionary:attachmentsDic]) {
            
            NSMutableArray *attachmentArr = [NSMutableArray array];
            NSMutableArray *mp3Arr = [NSMutableArray array];
            
            NSArray *sortArray = [attachmentsDic sortedValueByKeyInDesc:NO];
            
            for (NSDictionary *dic in sortArray) {
                NSMutableDictionary * attItem = dic.mutableCopy;
                NSString *ext = [dic objectForKey:@"ext"];
                NSString *attachurl = [[NSString stringWithFormat:@"%@%@",dic[@"url"],dic[@"attachment"]] makeDomain];
                [attItem setObject:attachurl forKey:@"attachurl"];
                if (![ext isEqualToString:@"mp3"]) {
                    if (![DataCheck isValidString:self.shareImageUrl]) {
                        self.shareImageUrl = attachurl;
                    }
                    [attachmentArr addObject:attItem];
                    
                } else {
                    [mp3Arr addObject:attItem];
                }
            }
            
            [item setValue:attachmentArr forKey:@"attachlist"];
            [item setValue:mp3Arr forKey:@"audiolist"];
        }
    }
    /*
     ThreadListModel *listModel = [[ThreadListModel alloc] init];
     [listModel setValuesForKeysWithDictionary:[[dataDic objectForKey:@"Variables"] objectForKey:@"thread"]];
    if (self.currentPage == 1) {
        BACK(^{
            if ([LoginModule isLogged] && [DataCheck isValidString:listModel.tid]) {
//                [[DatabaseHandle defaultDataHelper] footThread:listModel];
            }
        });

    }*/
}

@end
