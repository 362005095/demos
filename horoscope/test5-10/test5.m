//
//  test5.m
//  horoscope
//
//  Created by LK on 2018/3/6.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "test5.h"
#import <objc/runtime.h>
#import "test4.h"
#import "horoscope-Bridging-Header.h"
#import "ReactiveObjC.h"


static NSString *key = @"kShowObjcRunTime";
static char kUITableViewIndexKey;

typedef void(^BtnClickBlock)(NSInteger tag);

@interface test5 ()
{
    RACSignal *_siganl;
}
@property(nonatomic, strong)UIButton *btnTest;

@property(nonatomic, copy)BtnClickBlock nowBlock;

@end

@implementation test5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnTest = [UIButton initWitFrame:CGRectMake(170, 250, 75, 40) tag:3 title:@"btn3" targer:self action:@selector(testClick)];
    [self.view addSubview:self.btnTest];
    
    self.nowBlock = ^(NSInteger tag) {
      
        NSLog(@"----->>%@",@(tag));
        
    };
    
}



-(void)buttonClick:(UIButton *)button
{
    NSLog(@"子类实现了-->>%@",@(button.tag));
    switch (button.tag) {
        case 100:
        {
            [self setSomeThing];
        }
            break;
        case 101:
        {
            [self getSomeThing];
        }
            break;
        case 102:
        {
            [self testSegiel];
        }
            break;
        case 103:
        {
//            Class testClass = objc_getClass("test4");
//            test4 *class = [[testClass alloc] init];
//            [class printSomeThing];
            
            
            [self testRac];
            
        }
            break;
        case 104:
        {
            Stest6 *test6 = [[Stest6 alloc] init];
            NSString *test =  [test6 showNameWithAge:555 name:@"哈哈哈"];
//            NSString *test =  [test6 showNameWithAge:44];
//            NSString *test =  [test6 showName:44];
            NSLog(@"test-->>%@",test);
            
            
//            Stest6 *tempString = [[Stest6 alloc] initWithData:@"Test Swift"];
            
//            NSString *test111 = [test6 showTestDemo:@"555"];
            
//            NSLog(@"test111-->>%@",test111);
            
//            print([test6 showTestDemo(showFirstName:"555")]);
            
//            [test6 sh]
        }
            break;
            
        default:
            break;
    }
    
}

//void functionForMethod(id self, SEL _cmd)
//{
//        NSLog(@"Hello!");
//}

//Class functionForClassMethod(id self, SEL _cmd)
//{
//        NSLog(@"Hi!");
//        return [cla class];
//
//}

//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//        NSLog(@"resolveClassMethod");
//        NSString *selString = NSStringFromSelector(sel);
//        if ([selString isEqualToString:@"hi"])
//            {
//                    Class metaClass = objc_getMetaClass("HelloClass");
//                    class_addMethod(metaClass, @selector(hi), (IMP)functionForClassMethod, "v@:");
//                    return YES;
//                }
//        return [super resolveClassMethod:sel];
//
//}

//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//        NSLog(@"resolveInstanceMethod");
//        NSString *selString = NSStringFromSelector(sel);
//        if ([selString isEqualToString:@"hello"])
//            {
//                    class_addMethod(self, @selector(hello), (IMP)functionForMethod, "v@:");
//                    return YES;
//                }
//        return [super resolveInstanceMethod:sel];
//}




-(void)testSegiel
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);  //0
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < 10; index++) {
        
        dispatch_async(queue, ^(){
            
            NSLog(@"quene :%d", index);//1
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"addd :%d", index);//2
            [array addObject:[NSNumber numberWithInt:index]];
            dispatch_semaphore_signal(semaphore);
            
        });
        
    }
}

-(void)create
{
    // 1.创建信号
     _siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@1];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
        }];
    }];
}

-(void)testRac
{
    
//    [RACObserve(self, username) subscribeNext:^(NSString *newName) {
//        NSLog(@"%@", newName);
//    }];
//
    
//
    // 3.订阅信号,才会激活信号.
    [_siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
}
-(void)setSomeThing
{
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(key), @"100", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self.btnTest, &kUITableViewIndexKey,self.nowBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector == @selector(setSomeThing)){
        
        NSLog(@"setSomeThing");
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector: [anInvocation selector]])
    {
        NSLog(@"forwardInvocation");
        [super forwardInvocation:anInvocation];
        
    }
    
//        [anInvocation invokeWithTarget:someOtherObject];
    else
        [super forwardInvocation:anInvocation];
}



-(void)testClick
{
    
}

-(void)getSomeThing
{
    NSString *showSome = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(key));
    
//    BtnClickBlock nowBlock = objc_getAssociatedObject(self.btnTest, &kUITableViewIndexKey);
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
