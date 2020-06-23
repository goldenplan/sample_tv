//
//  Coordinator.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/22/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    
    private var rootNavController: UINavigationController!
    
    static let instance = Coordinator()
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
        
    @discardableResult
    private init() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        rootNavController = UINavigationController()
        
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = rootNavController
        appDelegate.window?.makeKeyAndVisible()
        
        push(vc: WallVC())
        
    }

    func pop(animated: Bool = true){
        rootNavController.popViewController(animated: animated)
    }
    
    func push(vc: UIViewController, animated: Bool = true) {
        rootNavController.pushViewController(vc, animated: animated)
    }
    
}
