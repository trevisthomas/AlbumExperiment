//
//  DataBundle.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

class DataBundle {
    
    enum DataType{
        case ALBUM
        case ARTIST
        //TODO add genre podcast
    }
    var title : String = ""
    var detail : String = ""
    var artwork : String? 
    var isPodcast : Bool = false
    
}