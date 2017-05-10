//
//  ViewController.m
//  AirPlaneWar
//
//  Created by 666gps on 2017/5/10.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "ViewController.h"
#import "MyAirPlane.h"
#import "EnemyAirPlane.h"

#define BGVIEW1 10
#define BGVIEW2 11

@interface ViewController (){
    MyAirPlane* _myPlane;
    NSMutableArray* _enemyPlaneArray;
    NSMutableArray* _bulletArray;
    NSMutableArray* _deleteArray;
    NSTimer* _refreshTimer;
    NSTimer* _bulletTimer;
    BOOL _isDead;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化敌机的数组
    _enemyPlaneArray = [[NSMutableArray alloc] init];
    //初始化子弹数组
    _bulletArray = [[NSMutableArray alloc] init];
    //删除子弹&飞机的数组
    _deleteArray = [[NSMutableArray alloc] init];
    //开始游戏
    [self startGame];
    //创建背景
    [self createBg];
    //创建飞机
    [self createPlane];
    //创建界面
    [self createUI];
}

//刷新方法
- (void)refresh{
    //刷新子弹位置 & 判断子弹打到敌机
    for (int i = 0; i < _bulletArray.count; i++) {
        UIView* bullet = _bulletArray[i];
        bullet.center = CGPointMake(bullet.center.x, bullet.center.y - 5);
        for (int j = 0; j < _enemyPlaneArray.count; j++) {
            EnemyAirPlane* plane = _enemyPlaneArray[j];
            //判断相交
            if (CGRectIntersectsRect(bullet.frame, plane.frame)) {
                //移除敌机
                [plane removeFromSuperview];
                [_deleteArray addObject:plane];
            }
        }
    }
    //移除要删除的敌机
    for (int i = 0; i < _deleteArray.count; i++) {
        EnemyAirPlane* plane = _deleteArray[i];
        //从敌机数组里删除
        [_enemyPlaneArray removeObject:plane];
    }
    [_deleteArray removeAllObjects];
    //创建敌机==========
    int n = arc4random()%100;
    if (n < 5) {
        [self createEnemyPlane];
    }
    //刷新敌机位置 & 撞到飞机
    for (int i = 0; i < _enemyPlaneArray.count; i++) {
        EnemyAirPlane* plane = _enemyPlaneArray[i];
        plane.center = CGPointMake(plane.center.x, plane.center.y + 2);
        if (CGRectIntersectsRect(plane.frame, _myPlane.frame)) {
            _isDead = YES;
            //飞机死掉
            [_myPlane dead];
            //停止定时器
            [_bulletTimer invalidate];
            [_refreshTimer invalidate];
            _bulletTimer = nil;
            _refreshTimer = nil;
        }
    }
    
    //刷新背景==========
    UIView* bg1 = [self.view viewWithTag:BGVIEW1];
    UIView* bg2 = [self.view viewWithTag:BGVIEW2];
    //如果背景出了屏幕，移动到最上方
    if (bg1.frame.origin.y > self.view.frame.size.height) {
        bg1.frame = CGRectMake(0, -800, 480, 800);
    }
    if (bg2.frame.origin.y > self.view.frame.size.height) {
        bg2.frame = CGRectMake(0, -800, 480, 800);
    }
    bg1.center = CGPointMake(bg1.center.x, bg1.center.y + 1);
    bg2.center = CGPointMake(bg2.center.x, bg2.center.y + 1);
}

//开始游戏
- (void)startGame{
    _isDead = NO;
    [_myPlane start];
    //移除屏幕上的子弹
    for (int i = 0; i < _bulletArray.count; i++) {
        UIView* bulletView = _bulletArray[i];
        [bulletView removeFromSuperview];
    }
    [_bulletArray removeAllObjects];
    //移除屏幕上的敌机
    for (int i = 0; i < _enemyPlaneArray.count; i++) {
        EnemyAirPlane* plane = _enemyPlaneArray[i];
        [plane removeFromSuperview];
    }
    [_enemyPlaneArray removeAllObjects];
    //打子弹
    if (_bulletTimer) {
        [_bulletTimer invalidate];
    }
    if (_refreshTimer) {
        [_refreshTimer invalidate];
    }
    _bulletTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(createBullet) userInfo:nil repeats:YES];
    //刷新方法
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

//创建UI
- (void)createUI{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 20, 100, 20);
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//创建子弹 bullet2.png 8 * 15
- (void)createBullet{
    UIImageView* bullet = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 15)];
    bullet.image = [UIImage imageNamed:@"bullet2.png"];
    bullet.center = CGPointMake(_myPlane.center.x,  _myPlane.center.y - 44);
    [self.view addSubview:bullet];
    [_bulletArray addObject:bullet];
}

//创建敌机
- (void)createEnemyPlane{
    int x = arc4random()%270;
    EnemyAirPlane * plane = [[EnemyAirPlane alloc] initWithFrame:CGRectMake(x, -30, 0, 0)];
    //添加到界面上
    [self.view addSubview:plane];
    //添加到数组中
    [_enemyPlaneArray addObject:plane];
}

//创建飞机
- (void)createPlane{
    _myPlane = [[MyAirPlane alloc] initWithFrame:CGRectMake(200, 300, 0, 0)];
    [self.view addSubview:_myPlane];
}

//创建背景
- (void)createBg{
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 800)];
    bgView.tag = BGVIEW1;
    bgView.image = [UIImage imageNamed:@"bg_01.jpg"];
    [self.view addSubview:bgView];

    
    UIImageView* bgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -800, 480, 800)];
    bgView2.tag = BGVIEW2;
    bgView2.image = [UIImage imageNamed:@"bg_02.jpg"];
    [self.view addSubview:bgView2];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isDead) {
        return;
    }
    //获取到手指触摸的坐标
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    _myPlane.center = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
