//
//  InviteCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "InviteCell.h"
#import "InvitePersonModel.h"

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(InvitePersonModel *)model{
    NSString *phone;
    if (0==model.name.length) {
        phone=[NSString stringWithFormat:@"  %@\n  %@",(0==model.tel.length?@"":model.tel),@"已注册"];
    }else{
        phone=[NSString stringWithFormat:@"  %@\n  %@",(0==model.tel.length?@"":model.tel),(0==model.name.length?@"":model.name)];
    }
    self.phoneLabel.text=phone;
    
    if ([model.name isEqualToString:@"未注册"]) {
        self.phoneLabel.textColor=[UIColor colorWithHexString:@"#9d9d9d"];
        self.jianshuLabel.textColor=[UIColor colorWithHexString:@"#9d9d9d"];
        self.moneyLabel.textColor=[UIColor colorWithHexString:@"#9d9d9d"];
        self.jianshuLabel.text=[NSString stringWithFormat:@"成交%ld件",(long)model.count];
        self.moneyLabel.text=[NSString stringWithFormat:@"推广费%.2f元",model.sum];
    }else{
        self.phoneLabel.textColor=[UIColor colorWithHexString:@"#595959"];
        self.jianshuLabel.textColor=[UIColor colorWithHexString:@"#595959"];
        self.moneyLabel.textColor=[UIColor colorWithHexString:@"#595959"];
        if (self.type==0) {
            
            NSString *jianshu=[NSString stringWithFormat:@"%ld件",(long)model.count];
            NSString *jianshuStr=[NSString stringWithFormat:@"成交%ld件",(long)model.count];
            NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:jianshuStr];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF694A"] range:NSMakeRange(jianshuStr.length-jianshu.length, jianshu.length)];
            self.jianshuLabel.attributedText=attr;
            
            
            NSString *feiyong=[NSString stringWithFormat:@"%.2f元",model.sum];
            NSString *feiyongStr=[NSString stringWithFormat:@"推广费%.2f元",model.sum];
            NSMutableAttributedString *attr2=[[NSMutableAttributedString alloc]initWithString:feiyongStr];
            [attr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FF694A"] range:NSMakeRange(feiyongStr.length-feiyong.length, feiyong.length)];
            self.moneyLabel.attributedText=attr2;
            
        }else if (self.type==1){
            self.jianshuLabel.text=[NSString stringWithFormat:@"成交%ld件",(long)model.count];
            self.moneyLabel.text=[NSString stringWithFormat:@"推广费%.2f元",model.sum];
        }
    }
}

@end
