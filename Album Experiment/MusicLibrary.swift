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
    
    func getGenreBundle() ->[DataBundle]{
        let query = MPMediaQuery.genresQuery()
        var result = [DataBundle]()
        for mediaItemCollection in query.collections!{
            let bundle = DataBundle()
            let mediaItem = mediaItemCollection.representativeItem
            let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as? String
            let songCount = mediaItemCollection.count
            
            //Determine artist count
            let predicateByArtist = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = Set(arrayLiteral: predicateByArtist)
            query.groupingType = .AlbumArtist
            let artistCount = query.collections!.count
            //
            
            //Determine album count
            let predicateByAlbum = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = Set(arrayLiteral: predicateByAlbum)
            query.groupingType = .Album
            let albumCount = query.collections!.count
            
            bundle.detail = "\(artistCount) artists, \(albumCount) albums, \(songCount) songs."
            bundle.title = genre!
            bundle.artwork = mediaItemCollection.representativeItem?.valueForProperty(MPMediaItemPropertyArtwork) as? String
            bundle.isPodcast = false;
            result.append(bundle)
        }
        
        let bundle = DataBundle();
        bundle.title = "Podcast"
        bundle.detail = "\(getPodcasts().count) programs."
        bundle.isPodcast = true
        result.append(bundle)
        
        return result;
    }
    
    func getPodcasts() ->[MPMediaItemCollection]{
        let query = MPMediaQuery.podcastsQuery()
        return query.collections!
    }
    
    func getPodcastEpisodes(index : Int) ->MPMediaItemCollection{
        
//        let query = MPMediaQuery.podcastsQuery()
//        let predicate = MPMediaPropertyPredicate(value: query, forProperty: MPMediaItemPropertyPodcastTitle)
//        query.filterPredicates = Set(arrayLiteral: predicate)
//        query.groupingType = .Album
        
        let query = MPMediaQuery.podcastsQuery()
        return (query.collections?[index])!
        
//        return query.collections!
//        let podcastCollection = artistCollection[index] //A collection of all songs by the artist i think
//        let mediaItem = artistItemsCollection.representativeItem! //An item to represent the artist
//        let artistTitle = mediaItem.valueForProperty(MPMediaItemPropertyAlbumArtist) as! String
//        return artistTitle
    }
    
    /*
    This implementation is intended to back the CollectionView based Album page.  The goal is to create a dictionary keyed by 
    the first letter of the artists name.  The value is an array containing a sorted list of AlbumData. Some of the album data objects are artist name only, the others represent an album. This was built to feed the ContainerView that i intend to use to present these.
    */
    func getArtistBundle(genre : String) ->[String : [AlbumData]]{
        let query = MPMediaQuery.genresQuery()
        let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        query.filterPredicates = Set(arrayLiteral: predicate)
        query.groupingType = .Album
        let albumCollections = query.collections!
        
        var albumArray : [AlbumData] = [AlbumData] () // = [AlbumData?](count: albumCollections.count, repeatedValue: nil)
        for album in albumCollections {
            
            albumArray.append(loadAlbumData(fromAlbum: album))
        }
        let sortedAlbumArray = albumArray.sort(){$0.artist < $1.artist}
        
        var indexedBundle = [String : [AlbumData]]()
        var previousArtist : String = ""
        for album in sortedAlbumArray{
            //Get his container
            let firstLetter : String = album.sortableArtist[0]
            
            if indexedBundle[firstLetter] == nil{
                indexedBundle[firstLetter] = [AlbumData]()
            }
            
            //Handle title change
            if previousArtist != album.sortableArtist{
                previousArtist = album.sortableArtist
                indexedBundle[firstLetter]?.append(AlbumData(title: album.artist))
            }
            
            //Add him
            indexedBundle[firstLetter]?.append(album)
        }
  
        //Debug: Dump
        let keys = indexedBundle.keys.sort()
        for key in keys {
            let value = indexedBundle[key]!
            print(value)
        }
        return indexedBundle

    }
    
    private func loadAlbumData(fromAlbum album : MPMediaItemCollection) -> AlbumData{
        let db = AlbumData()
        let props : Set<String> = [MPMediaItemPropertyAlbumTitle ,MPMediaItemPropertyPodcastTitle, MPMediaItemPropertyAlbumArtist, MPMediaItemPropertyArtwork, MPMediaItemPropertyReleaseDate]
        
        let item = album.representativeItem!
        db.trackCount = album.count
        item.enumerateValuesForProperties(props) {
            (str : String, obj : AnyObject, bool : UnsafeMutablePointer<ObjCBool>) in
            switch str{
            case MPMediaItemPropertyAlbumArtist:
                // After hours of fighting the below if block is the first thing that i have found that can handle when the AnyObject is wrapped arround 0x0.  Everything else blew up.  The answer wasn't directly to my question but i did figure it out from this post http://nshipster.com/swift-literal-convertible/
                if(obj as? NSObject == .None){
                    print ("Album Artist: AnyObject was 0x0" )
                    db.artist = "Untitled"
                }
                else if let _ = obj as? String{
//                    print ("Album Artist: \(obj)" )
                    db.artist = obj as! String
                } else {
                    print ("Album Artist: not null and not a string." )
                }
                
            case /*MPMediaItemPropertyPodcastTitle,*/ MPMediaItemPropertyAlbumTitle:
                db.title = obj as! String
//            case MPMediaItemPropertyAlbumTrackCount:
//                db.trackCount = obj as! Int
            case MPMediaItemPropertyArtwork:
                db.art = obj as! MPMediaItemArtwork
            case MPMediaItemPropertyReleaseDate:
                db.releaseDate = obj as! NSDate
            default:
                break
                
            }
        }
        return db
        
    }
    
    //Cool debug method for printing out the timing of a method. Found on stack over flow, modified to wrap method with return value
    static func printTimeElapsedWhenRunningCode(title:String, operation:()->(AnyObject))->AnyObject {
        let startTime = CFAbsoluteTimeGetCurrent()
        let retval = operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        //if timeElapsed > 0.00 {
        let time = NSString(format: "%.4f", timeElapsed)
        print("Time elapsed for \(title): \(time) s")
        //}
        return retval
    }

    
}