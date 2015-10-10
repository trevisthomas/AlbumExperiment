//
//  MusicLibrary.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicLibrary {
    
//    class var sharedFavoriteList : MusicLibrary {
//        struct Singleton {
//            static let instance = MusicLibrary()
//        }
//        return Singleton.instance;
//    }
    
    static let instance = MusicLibrary()
    private var artistAlbumCount : [String: Int];
    
    init () {
        artistAlbumCount = [String: Int]()
        
        let query = MPMediaQuery.albumsQuery()
        for albumCollection in query.collections! {
            let item = albumCollection.representativeItem!
            let albumArtist = getArtistNamm(fromMediaItem: item)
            if let count = artistAlbumCount[albumArtist]{
                artistAlbumCount[albumArtist] = count + 1
            } else {
                artistAlbumCount[albumArtist] = 1
            }
        }
    }
    
    private func getArtistNamm(fromMediaItem item : MPMediaItem) ->String{
        var albumArtist = item.valueForProperty(MPMediaItemPropertyAlbumArtist) as? String
        if(albumArtist == nil){
            albumArtist = item.valueForProperty(MPMediaItemPropertyPodcastTitle) as? String
        }
        if(albumArtist == nil){
            albumArtist = "<None>"
        }
        return albumArtist!
    }
    
    func getAlbumCount(forArtist artist : String) ->Int{
        return artistAlbumCount[artist]!
    }
    
    
    func getArtistCollectionForGenre(genreTitle genre : String) ->[MPMediaItemCollection]{
        let query = MPMediaQuery.genresQuery()
//        let mediaItemCollection = query.collections?[indexPath.row];
//        
//        let mediaItem = mediaItemCollection?.representativeItem
//        let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as? String
//        let songCount = mediaItemCollection!.count
        
        
        
        let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        query.filterPredicates = Set(arrayLiteral: predicate)
        query.groupingType = .AlbumArtist
//        let artistCount = query.collections!.count
        return query.collections!
    }
    
    func getGenre(atGenreIndex index: Int) ->String{
        let query = MPMediaQuery.genresQuery()
        let mediaItemCollection = query.collections?[index];
        
        let mediaItem = mediaItemCollection?.representativeItem
        let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as! String
        return genre
    }
    
    func getAlbumCollectionForArtist(artistTitle artist : String) ->[MPMediaItemCollection]{
        let query = MPMediaQuery.genresQuery()
        let predicate = MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyAlbumArtist)
        query.filterPredicates = Set(arrayLiteral: predicate)
        query.groupingType = .Album
        return query.collections!
    }
    
    func getArtistTitle(inGenre genre : String, atIndex index : Int) ->String{
        let artistCollection = MusicLibrary.instance.getArtistCollectionForGenre(genreTitle: genre)
        let artistItemsCollection = artistCollection[index] //A collection of all songs by the artist i think
        let mediaItem = artistItemsCollection.representativeItem! //An item to represent the artist
        let artistTitle = mediaItem.valueForProperty(MPMediaItemPropertyAlbumArtist) as! String
        return artistTitle
    }
    
    func getRepresentitiveMediaItem(forArtist artist : String, atAlbumIndex index : Int) ->MPMediaItem{
        let artistAlbumColletion = getAlbumCollectionForArtist(artistTitle: artist)
        let albumCollection = artistAlbumColletion[index]
        return albumCollection.representativeItem!
    }
    
    func getAlbum(forArtist artist : String, atAlbumIndex index : Int) ->MPMediaItemCollection{
        let artistAlbumColletion = getAlbumCollectionForArtist(artistTitle: artist)
        let albumCollection = artistAlbumColletion[index]
        return albumCollection
    }
    
}