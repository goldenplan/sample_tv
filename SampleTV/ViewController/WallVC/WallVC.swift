//
//  WallVC.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/22/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import UIKit
import Cartography
import ApiLibrary
import Combine

class WallVC: UIViewController {

    private var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 40, bottom: 40, right: 40)
        
        layout.itemSize = kPrefferedImageSize
        layout.minimumLineSpacing = 50
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout)
        
        collectionView.clipsToBounds = false
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private let filmService = FilmsApiService()
    
    private var disposeBag = Set<AnyCancellable>()
    
    private var filmsCollectionViewDelegate: FilmsCollectionViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        updateFilms()
        
    }
    
    private func setupViews(){
        
        
        view.addSubview(collectionView)
        filmsCollectionViewDelegate = FilmsCollectionViewDelegate(collectionView: collectionView, filmsListProtocol: self)
        constrain(view, collectionView) {
            view, collectionView in
            collectionView.trailing == view.trailing
            collectionView.leading == view.leading
            collectionView.center == view.center
            collectionView.height == kFilmsCollectionViewHeight
        }
        
    }

    private func updateFilms(){
        
        filmService.fetchFilms()
            .sink(receiveCompletion: {  (completion) in
               switch completion {
               case .failure(let error):
                   print(error)
               case .finished:
                   print("DONE - fetchMovies")
               }
            }, receiveValue: { [unowned self] (results: [FilmData]) in
                
                self.filmsCollectionViewDelegate.reload(with: results)
                
            })
            .store(in: &disposeBag)
        
    }
    
}

extension WallVC: FilmsListProtocol{
    func openDetail(filmData: FilmData) {

        let playerVC = PlayerVC()
        playerVC.filmData = filmData
        Coordinator.instance.push(vc: playerVC)
    }
}
