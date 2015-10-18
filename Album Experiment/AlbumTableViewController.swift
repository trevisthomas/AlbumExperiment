//
//  AlbumTableViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumTableViewController: UITableViewController {
    
    private let cellIdentifier = "AlbumCell"
    var genreTitle : String = ""
//    var bundle : DataBundle = DataBundle()
    
    /* Trevis, the section headers are stick to the top when you set "Plain" in the attributes
    inspector. "Grouped" causes them to live like regular table cells
    */


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        MusicLibrary.printTimeElapsedWhenRunningCode("loading artist bundle"){
            MusicLibrary.instance.getArtistBundle(self.genreTitle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let obj = printTimeElapsedWhenRunningCode("numberOfSectionsInTableView") {
            let artistCollection = MusicLibrary.instance.getArtistCollectionForGenre(genreTitle: self.genreTitle)
            return artistCollection.count
        }
        return obj as! Int
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = printTimeElapsedWhenRunningCode("numberOfRowsInSection") {
            let artistTitle = MusicLibrary.instance.getArtistTitle(inGenre: self.genreTitle, atIndex: section)
          return MusicLibrary.instance.getAlbumCount(forArtist: artistTitle)
        }
        return obj as! Int
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       // let obj = printTimeElapsedWhenRunningCode("titleForHeaderInSection") {
            let artistTitle = MusicLibrary.instance.getArtistTitle(inGenre: self.genreTitle, atIndex: section)
            return artistTitle
        //}
        //return obj as? String
//        return "title: \(section)"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let obj = printTimeElapsedWhenRunningCode("cellForRowAtIndexPath") {
        let artistTitle = MusicLibrary.instance.getArtistTitle(inGenre: self.genreTitle, atIndex: indexPath.section)
        
        let albumCollection = MusicLibrary.instance.getAlbum(forArtist: artistTitle, atAlbumIndex: indexPath.row)
        let mediaItem = albumCollection.representativeItem!
        let trackCount = albumCollection.count
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)!
        cell.textLabel?.text = mediaItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String
        cell.detailTextLabel?.text = "\(trackCount) tracks"
        cell.imageView?.image = mediaItem.artwork?.imageWithSize(CGSize(width: 70, height: 70))
        return cell;
        //}
        //return (obj as? UITableViewCell)!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        let songViewController = segue.destinationViewController as! SongTableViewController
        let artistTitle = MusicLibrary.instance.getArtistTitle(inGenre: self.genreTitle, atIndex: indexPath.section)

        songViewController.artistTitle = artistTitle
        songViewController.albumIndex = indexPath.row
        songViewController.title = artistTitle

    }

    //Cool debug method for printing out the timing of a method. Found on stack over flow, modified to wrap method with return value
    func printTimeElapsedWhenRunningCode(title:String, operation:()->(AnyObject))->AnyObject {
        let startTime = CFAbsoluteTimeGetCurrent()
        let retval = operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        //if timeElapsed > 0.00 {
//            let time = NSString(format: "%.4f", timeElapsed)
//            print("Time elapsed for \(title): \(time) s")
        //}
        return retval
    }
}
