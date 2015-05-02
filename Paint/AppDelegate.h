//
//  AppDelegate.h
//  Paint
//
//  Created by admin on 2/10/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(NSNumber *)saveDesign:(NSString *)name :(NSInteger)ageTemp :(NSInteger)genderTem :(NSString *)imgPath;
- (NSMutableArray *)fetchDesigns;
-(BOOL)deleteDesign:(NSNumber *)designId;
-(BOOL)updateDesign:(NSNumber *)designId :(NSString *)imgPath;


@end

