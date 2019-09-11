//
//  NSDictionarySR.h
//  Discuz2
//
//  Created by rexshi on 9/27/11.
//  Copyright 2011 rexshi. All rights reserved.
//

@interface NSDictionary (NSDictionarySR)

// 根据key对dict排序并形成数组
- (NSArray *)sortedValueByKeyInDesc:(BOOL)desc;

// 列出排序好的keys
- (NSArray *)sortedKeyInDesc:(BOOL)desc;

@end

