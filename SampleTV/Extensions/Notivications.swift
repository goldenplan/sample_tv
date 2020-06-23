//
//  Notivications.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation

extension Notification.Name {

    public struct Subs {
    
        public static let ShowSubs = Notification.Name(rawValue: "sample_tv.sabs.show")
        
        public static let HideSubs = Notification.Name(rawValue: "sample_tv.sabs.hide")
    
    }
    
}
