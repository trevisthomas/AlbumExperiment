//
//  GenreTableViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/9/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class GenreTableViewController: UITableViewController {
    
    private let cellIdentifier = "GenreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let query = MPMediaQuery.genresQuery()
        return (query.collections?.count)! //Maybe you should check and show a meaningfull error.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        let query = MPMediaQuery.genresQuery()
        let mediaItemCollection = query.collections?[indexPath.row];
        
        let mediaItem = mediaItemCollection?.representativeItem
        let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as? String
        let songCount = mediaItemCollection!.count
        
        
        
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
        
        let subtitle = "\(artistCount) artists, \(albumCount) albums, \(songCount) songs."
        
        cell.textLabel?.text = genre
        cell.detailTextLabel?.text = subtitle

        return cell
    }
    
    func dump(){
        print("\n\nStart")
//                let query = MPMediaQuery.podcastsQuery()//genresQuery()
//                for podcast in query.collections! {
//                    dumpPropertiesOfMediaItemCollection(podcast)
//                }
                let query = MPMediaQuery.genresQuery()
                for genre in query.collections!{
                    let item = genre.representativeItem!
        
                    if let str = item.valueForProperty(MPMediaItemPropertyPodcastTitle){
                        print("Podcast!  : \(str)" )
                    }
        
                    let str = item.valueForProperty(MPMediaItemPropertyGenre) as! String
                    print ("Genre = \(str)")
                    dumpArtistsOfGenre(str)
                }

    }
    
    func dumpArtistsOfGenre(genre : String) -> Void {
        //        let query = MPMediaQuery.artistsQuery()
        let query = MPMediaQuery()
        let predicateByArtist = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        query.filterPredicates = Set(arrayLiteral: predicateByArtist)
        query.groupingType = .AlbumArtist
        
        for collection in query.collections!{
            let item = collection.representativeItem!
            var artist = ""
            var albumArtist = ""
            if let str = item.valueForProperty(MPMediaItemPropertyAlbumArtist){
                //                    print ("\tAlbum Artist = \(str)")
                artist = str as! String
            }
            if let str = item.valueForProperty(MPMediaItemPropertyArtist){
                //                print ("\tArtist = \(str)")
                albumArtist = str as! String
            }
            //            let str = item.valueForProperty(MPMediaItemPropertyAlbumArtist)!
            
            print ("\tArtist = \(artist) (\(albumArtist))")
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let albumViewController = segue.destinationViewController as! AlbumTableViewController
        let genre = MusicLibrary.instance.getGenre(atGenreIndex: indexPath.row)
        albumViewController.genreTitle = genre
        albumViewController.title = genre
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
