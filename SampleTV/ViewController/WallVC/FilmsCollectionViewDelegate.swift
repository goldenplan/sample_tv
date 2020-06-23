//
//  FilmsCollectionViewDelegate.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit
import ApiLibrary

protocol FilmsListProtocol: class {
    func openDetail(filmData: FilmData)
}

class FilmsCollectionViewDelegate: NSObject {
    
    private weak var collectionView: UICollectionView!
    
    private var films: [FilmData] = []
    
    private weak var filmsListProtocol: FilmsListProtocol!

    private var lastIndexPath: IndexPath? = nil
    
    init(collectionView: UICollectionView, filmsListProtocol: FilmsListProtocol) {
        
        self.collectionView = collectionView
        
        self.filmsListProtocol = filmsListProtocol
        
        super.init()
        
        setup()
        
    }
    
    private func setup(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: FilmCell.cellId, bundle: nil), forCellWithReuseIdentifier: FilmCell.cellId)
        
    }
    
    public func reload(with items: [FilmData]){
        films.append(contentsOf: items)
        films.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    deinit {
        print("deinit", self.description)
    }
    
}


extension FilmsCollectionViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCell.cellId, for: indexPath) as! FilmCell
        
        cell.setup(filmData: films[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        filmsListProtocol.openDetail(filmData: films[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator){
        
        if let cell = context.nextFocusedView as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) {
            
            lastIndexPath = indexPath
        }
        
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        
        return  lastIndexPath != nil && lastIndexPath!.row <= films.count - 1 ? lastIndexPath : nil
    }
    
}
