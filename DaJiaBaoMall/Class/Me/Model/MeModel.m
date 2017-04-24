//
//  MeModel.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MeModel.h"

@implementation MeModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //基本信息
    [aCoder  encodeObject:self.mobilephone forKey:@"mobilephone"];
    [aCoder  encodeObject:self.name forKey:@"name"];
    [aCoder  encodeObject:self.picture forKey:@"picture"];
    [aCoder  encodeObject:self.sex forKey:@"sex"];
    [aCoder  encodeObject:self.company forKey:@"company"];
    [aCoder  encodeObject:self.position forKey:@"position"];
    [aCoder  encodeObject:self.qrimage forKey:@"qrimage"];
    [aCoder  encodeBool:self.isauth forKey:@"isauth"];
    [aCoder  encodeBool:self.weixinauth forKey:@"weixinauth"];
    [aCoder  encodeObject:self.ryToken forKey:@"ryToken"];
    
    //银行卡
    [aCoder  encodeObject:self.bankname forKey:@"bankname"];
    [aCoder  encodeObject:self.banklogo forKey:@"banklogo"];
    [aCoder  encodeObject:self.banknum forKey:@"banknum"];
    [aCoder  encodeObject:self.serviceTel forKey:@"serviceTel"];
    [aCoder  encodeBool:self.bankAuth forKey:@"bankAuth"];
    [aCoder  encodeObject:self.account forKey:@"account"];
    [aCoder  encodeObject:self.frozenmoney forKey:@"frozenmoney"];
    [aCoder  encodeDouble:self.frozentime forKey:@"frozentime"];
    [aCoder  encodeObject:self.monthincome forKey:@"monthincome"];
    [aCoder  encodeObject:self.totalincome forKey:@"totalincome"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        //基本信息
        self.mobilephone=[aDecoder decodeObjectForKey:@"mobilephone"];
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.picture=[aDecoder decodeObjectForKey:@"picture"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.company=[aDecoder decodeObjectForKey:@"company"];
        self.position=[aDecoder decodeObjectForKey:@"position"];
        self.qrimage=[aDecoder decodeObjectForKey:@"qrimage"];
        self.isauth=[aDecoder decodeBoolForKey:@"isauth"];
        self.weixinauth=[aDecoder decodeBoolForKey:@"weixinauth"];
        self.ryToken=[aDecoder decodeObjectForKey:@"ryToken"];
        
        //银行信息
        self.bankname=[aDecoder decodeObjectForKey:@"bankname"];
        self.banklogo=[aDecoder decodeObjectForKey:@"banklogo"];
        self.banknum=[aDecoder decodeObjectForKey:@"banknum"];
        self.serviceTel=[aDecoder decodeObjectForKey:@"serviceTel"];
        self.bankAuth=[aDecoder decodeBoolForKey:@"bankAuth"];
        self.account=[aDecoder decodeObjectForKey:@"account"];
        self.frozenmoney=[aDecoder decodeObjectForKey:@"frozenmoney"];
        self.frozentime=[aDecoder decodeDoubleForKey:@"frozentime"];
        self.monthincome=[aDecoder decodeObjectForKey:@"monthincome"];
        self.totalincome=[aDecoder decodeObjectForKey:@"totalincome"];
        
        
        
    }
    return self;
}


@end
