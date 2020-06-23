//
//  FilmCell.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import UIKit
import TVUIKit
import ApiLibrary
import Kingfisher

class FilmCell: UICollectionViewCell {
    
    static let cellId = "FilmCell"

    @IBOutlet weak var posterView: TVPosterView!
    
    private var filmData: FilmData!
    
    func setup(filmData: FilmData){
        
        clipsToBounds = false
        
        self.filmData = filmData
        
        posterView.title = filmData.title
        
        posterView.image = UIImage(named: "placeholder")
        
        uploadImage(filmId: filmData.id)
        
        setGrayColorForTitle(view: posterView)
        hideTitle(view: posterView)
        
        
        
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedItem === context.previouslyFocusedItem{
            return
        }
        
        if let cell = context.nextFocusedItem as? UICollectionViewCell,
            cell == self{
            showTitle(view: self)
        }
        
        if let cell = context.previouslyFocusedItem as? UICollectionViewCell,
            cell == self{
            hideTitle(view: self)
        }
        
    }
    
    private func uploadImage(filmId: String){
        
        if let imageUrl = URL(string: filmData.preview){
            
            ImageDownloader.default.downloadImage(with: imageUrl, options: nil, progressBlock: nil) { [weak self] (result) in
            
            guard let strongSelf = self,
                strongSelf.filmData.id == filmId
            else { return }

            
            switch result{
            case .success(let imageResult):
                
                self?.posterView.image = imageResult.image
                
            case .failure(_):
                
                self?.posterView.image = UIImage(named: "placeholder")
                
            }
                
            }
        }
    }
    
    private func setGrayColorForTitle(view: UIView){
        view.subviews.forEach { (item) in
            if (item is UILabel){
                (item as! UILabel).textColor = UIColor.white.withAlphaComponent(0.5)
            }
            setGrayColorForTitle(view: item)
        }
    }
    
    private func showTitle(view: UIView){
        view.subviews.forEach { (item) in
            if (item is UILabel){
                (item as! UILabel).alpha = 1
            }
            showTitle(view: item)
        }
    }
    
    private func hideTitle(view: UIView){
        view.subviews.forEach { (item) in
            if (item is UILabel){
                (item as! UILabel).alpha = 0
            }
            hideTitle(view: item)
        }
    }
    
}
