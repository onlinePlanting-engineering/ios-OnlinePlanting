//
//  AppDelegate.swift
//  OnlinePlanting
//
//  Created by IBM on 4/24/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData
import DATAStack


var appDelegate: AppDelegate {
    return (UIApplication.shared.delegate as? AppDelegate)!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    fileprivate var tabbarController: UINavigationController?
    
    var currentUser: User? {
        didSet{
            //update User informaton
            print("current user's id is: \(String(describing: currentUser?.id))")
        }
    }
    
    var currentLocation: Location? {
        didSet{
            //update User informaton
            print("current user's city is: \(String(describing: currentLocation?.city))")
            
        }
    }
    
    lazy var dataStack: DATAStack = {
        let dataStack = DATAStack(modelName: "OnlinePlanting")
        return dataStack
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.loginSuccess), name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        
        SMSSDK.registerApp("1d75ef2990800", withSecret: "e417f1d73f075effd2f4e7a048afbb7c")
        
        let _ = LocationUtils.sharedInstance.currLocation
        //SMSSDK.enableAppContactFriends(false)
        let user = UserDefaults.standard.object(forKey: "last_logined_user") as? String
        currentUser = OPDataService.sharedInstance.fetchCurrentUserObjects(user)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "OnlinePlanting")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loginSuccess() {
        if tabbarController == nil {
            tabbarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarNav") as? UINavigationController
            self.window?.rootViewController = tabbarController
        }else{
            self.window?.rootViewController = tabbarController
        }
    }
}

