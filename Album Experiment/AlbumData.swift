//
//  AlbumData.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer 

class AlbumData : CustomStringConvertible{
    private let articlesArray = ["a ", "an ", "the "]
    enum DataType{
        case ALBUM
        case ARTIST
        //TODO add genre podcast
    }
    
    init (title: String){
        self.title = title
        self.artist = title
        type = DataType.ARTIST
    }
    
    init (){
        type = DataType.ALBUM
    }
    
    var type : DataType!
    var title : String!
    var artist : String! {
        didSet {
            sortableArtist = artist.sortableString()
        }
    }
    var art : MPMediaItemArtwork!
    var releaseDate : NSDate!
    var trackCount : Int!
    var sortableArtist : String! //Make this read only
    
    var description: String {
        return title
    }
}