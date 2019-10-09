//
//  AppDelegate.h
//  GLKViewTest
//
//  Created by xiaohua on 2019/10/9.
//  Copyright © 2019 LanChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

