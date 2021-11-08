//
//  AppDelegate.swift
//  VKProject1
//
//  Created by xc553a8 on 2021-08-17.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        //GetDataFromVK().loadData(method: Method) { [weak self] result in
        //}
        return true
        
    }
}

