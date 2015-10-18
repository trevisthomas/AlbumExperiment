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
    var albumData : AlbumData!{
        didSet{
            albumTitleLabel.text = albumData.title
            backgroundColor = UIColor.blueColor()
        }
    }
}
