//
//  AppDelegate.swift
//  'Bits
//
//  Created by Wouter Willebrands on 09/10/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let searchBarAppearance = UISearchBar.appearance()
        
        searchBarAppearance.tintColor = ColorConstants.tintColor
        searchBarAppearance.backgroundColor = ColorConstants.buttonMenuColor
        searchBarAppearance.placeholder = "Search Entries"
        searchBarAppearance.keyboardAppearance = .dark
        searchBarAppearance.isTranslucent = true
        
//        let keyboardAppearance = KeyboardManager

        
//        searchBar.searchBarStyle = .prominent
//        searchBar.value(forKey: "searchField")
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") //as? UITextField
//        textFieldInsideSearchBar?.textColor = ColorConstants.tintColor
//        searchBar.barTintColor = ColorConstants.tintColor
        
//        searchBar.barTintColor = ColorConstants.tintColor
        
        let navigationBarAppearance = UINavigationBar.appearance()

        navigationBarAppearance.barTintColor = ColorConstants.buttonMenuColor // Bar Background
        navigationBarAppearance.tintColor = ColorConstants.tintColor // Tintcolor title, images and back indicator
        navigationBarAppearance.isTranslucent = false
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
//        window?.overrideUserInterfaceStyle = .dark

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    // MARK: - Core Data stack
    
    // NSManagedObjectContext: An object space that you use to manipulate and track changes to managed objects.
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()

    // NSPersistentContainer: A container that encapsulates the Core Data stack in your app.
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Bits") // Needs to match with dataModel name, otherwise the stack cannot find it
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: Todo Error handling
extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
                // Title is too long
                // Title is too short for editing mode
            }
        }
    }
}

