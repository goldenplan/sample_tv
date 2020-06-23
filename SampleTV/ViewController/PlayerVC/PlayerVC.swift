//
//  PlayerVC.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/22/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import UIKit
import AVKit
import ApiLibrary
import Cartography

class PlayerVC: AVPlayerViewController {

    var filmData: FilmData!
    
    private var subsProvider: SubsProvider? = nil
    
    private var timeObserverToken: Any!
    
    let subsView: SubsView = {
        let view = SubsView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    func initPlayer(){

        guard let videoLink = URL(string: filmData.video) else {
            return
        }

        let playerItem = AVPlayerItem(url: videoLink)
        player = AVPlayer(playerItem: playerItem)
        player?.actionAtItemEnd = .none
        
        player?.play()
        
        setupSubsProvider()
        
        setupSubsView()
        
        setupObserver()
        
    }
    
    func setupSubsView(){
        
        
        view.addSubview(subsView)
        constrain(view, subsView) {
            view, collectionView in
            collectionView.trailing == view.trailing - 80
            collectionView.leading == view.leading + 80
            collectionView.bottom == view.bottom - 180
            collectionView.height == 100
        }
        
    }
    
    func setupObserver(){
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(kDefaultTimeScale)), queue: DispatchQueue.global()) {
        
            [weak self] (progressTime) in
            
            guard
                let strongSelf = self,
                let player = strongSelf.player
            else { return }
            
            let seconds = Int(player.currentTime().value / kDefaultTimeScale)
            
            strongSelf.subsProvider?.setCurrentTime(seconds: seconds)
        }
        
        if #available(iOS 10.0, *) {
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
        
    }
    
    func removeObserver(){
        
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
        if #available(iOS 10.0, *) {
            player?.removeObserver(self, forKeyPath: "timeControlStatus")
        } else {
            player?.removeObserver(self, forKeyPath: "rate")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard player != nil else { return }
        
        if object as AnyObject? === player {

            if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if player?.timeControlStatus == .playing {
                        showSubsView()
                    }else{
                        hideSubsView()
                    }
                }
            } else if keyPath == "rate" {
                if player!.rate > 0 {
                    showSubsView()
                }else{
                    hideSubsView()
                }
            }
        }
    }
    
    func hideSubsView(){
        subsView.alpha = 0
        subsProvider?.sendHide()
    }
    
    func showSubsView(){
        subsView.alpha = 1
    }
    
    func setupSubsProvider(){
        
        subsProvider = SubsProvider(filmData: filmData)
        
    }

    deinit {
        print("deinit", self)
    }
}
