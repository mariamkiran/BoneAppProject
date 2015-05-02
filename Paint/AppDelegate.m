//
//  AppDelegate.m
//  Paint
//
//  Created by admin on 2/10/15.
//  Copyright (c) 2015 Innovazor. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.innovazor.Paint" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Paint" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Paint.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return false;
        }
    }
    return true;
}

-(NSNumber *)saveDesign:(NSString *)name :(NSInteger)ageTemp :(NSInteger)genderTem :(NSString *)imgPath
{
    // 0 for male and 1 for female
    NSNumber *age = [NSNumber numberWithInteger:ageTemp];
    NSNumber *gender = [NSNumber numberWithInteger:genderTem];
    
    NSManagedObject *newContext=[NSEntityDescription insertNewObjectForEntityForName:@"Designs" inManagedObjectContext:[self managedObjectContext]];
    NSNumber *serial = [self getNextSerial];
    [newContext setValue:serial forKey:@"serial"];
    [newContext setValue:name forKey:@"name"];
    [newContext setValue:age forKey:@"age"];
    [newContext setValue:gender forKey:@"gender"];
    [newContext setValue:imgPath forKey:@"imgPath"];
    [newContext setValue:[NSDate date] forKey:@"date"];
    if(![self saveContext])
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error Occured" message:@"Data is not Stored in Database Try Again" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }
    return serial;
}

-(NSMutableArray *)fetchDesigns
{
    NSMutableArray *designs = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext2 = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Designs"];
    NSError *er;
    
    NSSortDescriptor *isHomeTeam = [[NSSortDescriptor alloc] initWithKey:@"serial" ascending:NO];
    [fetchRequest setSortDescriptors:[[NSArray alloc] initWithObjects:isHomeTeam, nil]];
    
    designs = [[managedObjectContext2 executeFetchRequest:fetchRequest error:&er] mutableCopy];
    
    NSMutableArray *list1 = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in designs)
    {
        NSNumber *serial = [obj valueForKey:@"serial"];
        NSString *name = [obj valueForKey:@"name"];
        NSNumber *age = [obj valueForKey:@"age"];
        NSNumber *gender = [obj valueForKey:@"gender"];
        NSString *img = [obj valueForKey:@"imgPath"];
        NSDate *date = [obj valueForKey:@"date"];
        
        NSMutableArray *list2 = [[NSMutableArray alloc] init];
        [list2 addObject:serial];
        [list2 addObject:name];
        [list2 addObject:age];
        [list2 addObject:gender];
        [list2 addObject:img];
        [list2 addObject:date];
        
        [list1 addObject:list2];
    }
    
    return list1;
}

-(BOOL)deleteDesign:(NSNumber *)designId
{ 
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:[NSEntityDescription entityForName:@"Designs" inManagedObjectContext: context]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"(serial == %@)",designId]];
    NSArray * records = [context executeFetchRequest:fetch error:&error];
    for (NSManagedObject * record in records)
    {
        [context deleteObject:record];
    }
    if([context save:&error])
        return true;
    else
        return false;
}

-(BOOL)updateDesign:(NSNumber *)designId :(NSString *)imgPath
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:[NSEntityDescription entityForName:@"Designs" inManagedObjectContext: context]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"(serial == %@)",designId]];
    NSArray * records = [context executeFetchRequest:fetch error:&error];
    if ([records count]==1)
    {
        NSManagedObject * record = [records objectAtIndex:0];
        [record setValue:imgPath forKey:@"imgPath"];
        if(![self saveContext])
        {
            return false;
        }
        else
            return true;
    }
    else
        return false;
}

-(NSNumber *)getNextSerial
{
    NSMutableArray *design = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext2 = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Designs"];
    NSError *er;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"serial" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    design = [[managedObjectContext2 executeFetchRequest:fetchRequest error:&er] mutableCopy];
    NSInteger serial;
    if ([design count]>0) {
        NSManagedObject *obj = [design objectAtIndex:0];
        NSNumber *ser = [obj valueForKey:@"serial"];
        serial = [ser integerValue];
    }
    else
        serial = 0;
    serial++;
    return [NSNumber numberWithInteger:serial];
}

@end
