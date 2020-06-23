//
//  SubsProvider.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import ApiLibrary
import Combine

class SubsProvider {
    
    private let filmData: FilmData!
    
    private let subsService = SubsApiService()
    
    private var subs: [SubData] = []
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(filmData: FilmData) {
        
        self.filmData = filmData
        
        loadSubs()
    }
    
    private func loadSubs(){
        
        subsService.fetchSubs(for: filmData.id)
        .sink(receiveCompletion: {  (completion) in
           switch completion {
           case .failure(let error):
               print(error)
           case .finished:
               print("DONE - fetchSubs")
           }
        }, receiveValue: { [unowned self] (results: [SubData]) in
            
            self.subs = results
            
        })
        .store(in: &disposeBag)
        
    }
    
    public func setCurrentTime(seconds: Int){
        
        if let sub = subs.first(where: { seconds >= $0.startTime && seconds <= $0.endTime}){
            sendText(text: sub.text)
        }else{
            sendHide()
        }
    }
    
    private func sendText(text: String) {
        
        NotificationCenter.default.post(
            name: Notification.Name.Subs.ShowSubs,
            object: nil,
            userInfo: ["text": text])
        
    }
    
    public func sendHide() {
        
        NotificationCenter.default.post(
            name: Notification.Name.Subs.HideSubs,
            object: nil,
            userInfo: nil)
        
    }
    
    deinit {
        print("deinit", self)
    }
    
}
