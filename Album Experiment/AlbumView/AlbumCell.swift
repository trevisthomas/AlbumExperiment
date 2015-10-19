//
//  AlbumCell.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumDetails: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    
    var albumData : AlbumData!{
        didSet{
            albumTitleLabel.text = albumData.title
            albumDetails.text = "\(albumData.trackCount) tracks"
//            backgroundColor = UIColor.blueColor()
//            backgroundColor = UIColor.clearColor()
//            albumArtImageView.backgroundColor = UIColor.brownColor()
            
//            if(albumData.art != nil) {
//                let size = albumArtImageView.bounds.size
//                albumArtImageView.image = albumData.art.imageWithSize(size)
//            }
        }
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if(albumData.art != nil) {
            let size = albumArtImageView.bounds.size
            albumArtImageView.image = albumData.art.imageWithSize(size)
        }
        return layoutAttributes
    }
}
