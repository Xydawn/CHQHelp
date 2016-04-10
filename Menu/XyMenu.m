//
//  XyMenu.m
//  QinDianSheQu
//
//  Created by 金斗云 on 16/3/24.
//  Copyright © 2016年 Xydawn. All rights reserved.
//

#import "XyMenu.h"
#import "NSDate+Category.h"
@interface XyMenu ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *selectorTable;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *yyArr;
@property (nonatomic,strong) NSMutableArray *mmArr;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isShow;
//@property (nonatomic,strong) UIView *backView;
@end

@implementation XyMenu


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"XyMenu" owner:self options:nil].lastObject;
        self.frame = frame;
        self.index = 0;
        self.selectorTable.dataSource =self;
        self.selectorTable.delegate = self;

    }
    return self;
}

-(void)showOrMiss{
    if (self.isShow) {
        [self hideMenu];
    }else{
        [self showMenu];
    }

}

-(NSMutableArray *)modelArr{
    if (_modelArr == nil) {
        _modelArr = [[NSMutableArray alloc]init];
        
        NSString *yydate = [NSDate stringWithTimeInterval:time(NULL) andDateFormatteString:@"YYYY"];
        
        NSString *mmdate = [NSDate stringWithTimeInterval:time(NULL) andDateFormatteString:@"MM"];
        
        for (NSInteger i = 0; i < 6; i++) {

            NSInteger mm = [mmdate integerValue] - i;
            NSInteger yy = [yydate integerValue];
            if (mm==0) {
                mmdate = [NSString stringWithFormat:@"%ld",(12+i)];
                mm = 12;
                yy--;
                yydate = [NSString stringWithFormat:@"%ld",yy];
            }
            
            [self.yyArr addObject:[NSString stringWithFormat:@"%ld",yy]];
            [self.mmArr addObject:[NSString stringWithFormat:@"%02ld",mm]];
            [_modelArr addObject:[NSString stringWithFormat:@"%ld年%02ld月",yy,mm]];
            
        }
    }
    return _modelArr;
}

-(NSMutableArray *)yyArr{
    if (_yyArr == nil) {
        _yyArr = [[NSMutableArray alloc]init];
    }
    return _yyArr;
}

-(NSMutableArray *)mmArr{
    if (_mmArr == nil) {
        _mmArr = [[NSMutableArray alloc]init];
    }
    return _mmArr;
}

//-(UIView *)backView{
//    if (_backView == nil) {
//        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, k_width, k_height)];
//        _backView.backgroundColor = [UIColor clearColor];
//        [_backView addSubview:self];
//    }
//    return _backView;
//}

-(void)showMenu{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
        self.isShow =!self.isShow;

    
    self.transform = CGAffineTransformMakeScale(0.5,0.5);
    self.alpha = 0.5;

    [window addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        [self.selectorTable reloadData];
    }];
}

-(void)hideMenu{
        self.isShow =!self.isShow;
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.5,0.5);
        self.alpha = 0.5;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

 -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
 }
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cellID"];
    }
    
    if (self.index == indexPath.row) {
        
        cell.backgroundColor = RGBACOLOR(245, 167, 41, 1);
        
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }else{
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.textColor = RGBACOLOR(107, 69, 10, 1);
    }
    
    
    cell.selectionStyle = 0;
    

    
    cell.textLabel.text  = self.modelArr[indexPath.row];
    

    
    cell.textLabel.font = KFont(10);
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}



/*
 -(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 return ;
 }
  */
 -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 return 0.00000001;
 }

/*
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 return ;
 }
  */
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 return 0.00001;
 }


 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.backgroundColor = RGBACOLOR(245, 167, 41, 1);
     cell.textLabel.textColor = [UIColor whiteColor];
     
     
    UITableViewCell *chagedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
     chagedCell.backgroundColor = [UIColor clearColor];
     
     chagedCell.textLabel.textColor = RGBACOLOR(107, 69, 10, 1);
     
     self.index = indexPath.row;

    [self hideMenu];
     
  
     if (self.tableCLick) {
         self.tableCLick(self.yyArr[indexPath.row],self.mmArr[indexPath.row]);
     }
     
 }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
