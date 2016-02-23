//
//  DataManager+User.h
//  mgservice
//
//  Created by Sun Peng on 16/2/22.
//  Copyright © 2016年 Suzic. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (User)

/**
 * @abstract 根据任务编号查找本地是否存在
 */
- (DBTaskList *)findWaiterRushByTaskCode:(NSString *)taskCode;

/**
 * @abstract 获取参数表
 */
- (DBWaiterInfor *)getWaiterInfor;

@end
