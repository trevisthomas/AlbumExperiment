//
//  SongTableViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController: UITableViewController {
    var artistTitle : String = ""
    var albumIndex : Int = 0
    private let tableCellIdentifier = "SongCell"
    //var musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
    var musicPlayer = MPMusicPlayerController.systemMusicPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let albumCollection = MusicLibrary.instance.getAlbum(forArtist: artistTitle, atAlbumIndex: albumIndex)
        return albumCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let albumCollection = MusicLibrary.instance.getAlbum(forArtist: artistTitle, atAlbumIndex: albumIndex)
        let item = albumCollection.items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tableCellIdentifier)!
        let title = item.valueForProperty(MPMediaItemPropertyTitle) as! String
//        let trackNumber = item.valueForProperty(MPMediaItemPropertyAlbumTrackNumber) as? String
        let trackNumber = indexPath.row + 1
        cell.textLabel?.text = "\(trackNumber) \(title)"
        let duration = item.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! Float
        cell.detailTextLabel?.text = "\(formatDuration(duration))"
        return cell
    }
    
    private func formatDuration(duration : Float) ->String{
        let minutes = Int(floor(duration / 60));
        let seconds = duration - Float(minutes * 60)
        return "\(minutes):\(Int(round(seconds)))"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let albumCollection = MusicLibrary.instance.getAlbum(forArtist: artistTitle, atAlbumIndex: albumIndex)
        
        musicPlayer.stop()
        musicPlayer.setQueueWithItemCollection(albumCollection);
        musicPlayer.stop()
        musicPlayer.nowPlayingItem = albumCollection.items[indexPath.row]
        musicPlayer.play();

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
