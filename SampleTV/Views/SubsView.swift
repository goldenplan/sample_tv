//
//  SubsView.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import Cartography
import UIKit

class SubsView: UIView {
    
    private let defaultShowingColor: UIColor = UIColor.black.withAlphaComponent(0.2)
    
    private let textLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        return label
        
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        removeNotification()
    }
    
    
    private func setupView(){
        
        addSubview(textLabel)
        constrain(self, textLabel) {
            view, textLabel in
            textLabel.center == view.center
            textLabel.leading == view.leading
            textLabel.trailing == view.trailing
        }
        
    }
    
    private func setupNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotificationWithText), name: Notification.Name.Subs.ShowSubs, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotificationHideText), name: Notification.Name.Subs.HideSubs, object: nil)
        
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func receivedNotificationWithText(notification: Notification) {
        if let text = notification.userInfo?["text"] as? String{
            DispatchQueue.main.async { [weak self] in
                self?.backgroundColor = self?.defaultShowingColor
                self?.textLabel.text = text
            }
            
        }
    }
    
    @objc private func receivedNotificationHideText(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundColor = .clear
            self?.textLabel.text = ""
        }
    }
    
    deinit {
        
        print("deinit", self)
    }
    
}
