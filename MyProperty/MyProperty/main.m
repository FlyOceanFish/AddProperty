//
//  main.m
//  testProperty
//
//  Created by YTO on 2018/12/29.
//  Copyright © 2018年 FlyOceanFish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>

id getter(id object,SEL _cmd1){
    NSString *key = NSStringFromSelector(_cmd1);
    return objc_getAssociatedObject(object, (__bridge const void * _Nonnull)(key));
}
void setter(id object,SEL _cmd1,id newValue){
    NSString *key = NSStringFromSelector(_cmd1);
    key = [[key substringWithRange:NSMakeRange(3, key.length-4)] lowercaseString];
    objc_setAssociatedObject(object, (__bridge const void * _Nonnull)(key), newValue, OBJC_ASSOCIATION_RETAIN);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
        objc_property_attribute_t ownership0 = { "C", "" }; // C = copy
        objc_property_attribute_t ownership = { "N", "" }; //N = nonatomic
        objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", @"sex"] UTF8String] };  //variable name
        objc_property_attribute_t attrs[] = { type, ownership0, ownership,backingivar};//这个数组一定要按照此顺序才行
        BOOL add = class_addProperty([Person class], "sex", attrs, 4);
        if (add) {
            NSLog(@"添加成功\n");
        }else{
            NSLog(@"添加失败\n");
        }
        
        class_addMethod([Person class], NSSelectorFromString(@"sex"), (IMP)getter, "@@:");
        class_addMethod([Person class], NSSelectorFromString(@"setSex:"), (IMP)setter, "v@:@");
        
        unsigned int count;
        objc_property_t *properties =class_copyPropertyList([Person class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSLog(@"名字:%s--属性:%s\n",property_getName(property),property_getAttributes(property));
        }
        
        Person *person = [Person new];
        person.name = @"FlyOceanFish";
        [person setValue:@"男" forKey:@"sex"];
        NSLog(@"name:%@",person.name);
        NSLog(@"sex:%@",[person valueForKey:@"sex"]);
    }
    return 0;
}
