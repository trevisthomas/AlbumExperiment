//
//  AlbumViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumViewController: UICollectionViewController, UICollectionViewDelegateLeftAlignedLayout {

    let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var albumCellWidth : CGFloat!
    var albumCellHeight : CGFloat!
    var artistCellWidth : CGFloat!
    let artistCellHeight : CGFloat = 50.0
    
    //Segue must set this to an existing genre or things will go bad fast
    var genreTitle : String! {
        didSet{
            self.title = genreTitle
        }
    }
    
    
    var indexedArtistData : [String : [AlbumData]]! {
        didSet{
            sections = indexedArtistData.keys.sort()
        }
    }
    var sections : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        indexedArtistData = MusicLibrary.instance.getArtistBundle(genreTitle)
        
//        artistCellWidth = self.collectionView!.bounds.size.width - cellInsets.left - cellInsets.right
//        albumCellWidth = (calculateShortSide() - cellInsets.left - cellInsets.right) / 2.0
//        albumCellHeight = albumCellWidth //Same for now.  May make non square for titles
        
        adjustCellDimensions(toOrientation: UIApplication.sharedApplication().statusBarOrientation)
        
    }
    
    private func calculateShortSide() ->CGFloat{
        if(self.collectionView!.bounds.size.width < self.collectionView!.bounds.size.height){
            return self.collectionView!.bounds.size.width
        } else {
            return self.collectionView!.bounds.size.height
        }
    }
    
    private func calculateLongSide() ->CGFloat{
        if(self.collectionView!.bounds.size.width > self.collectionView!.bounds.size.height){
            return self.collectionView!.bounds.size.width
        } else {
            return self.collectionView!.bounds.size.height
        }
    }

    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
//        var referenceWidth : CGFloat!
//        if(toInterfaceOrientation.isLandscape){
//            referenceWidth = self.collectionView!.bounds.size.height
//        } else {
//            referenceWidth = self.collectionView!.bounds.size.width
//        }
//        
//        artistCellWidth = referenceWidth - cellInsets.left - cellInsets.right
//        collectionView?.collectionViewLayout.invalidateLayout()
        adjustCellDimensions(toOrientation: toInterfaceOrientation)
    }
    
    private func adjustCellDimensions(toOrientation orientation : UIInterfaceOrientation ){
        var referenceWidth : CGFloat!
        var itemsPerRow : CGFloat!
        if(orientation.isLandscape){
//            referenceWidth = self.collectionView!.bounds.size.height
            referenceWidth = calculateLongSide()
            itemsPerRow = 4.0
        } else {
//            referenceWidth = self.collectionView!.bounds.size.width
            referenceWidth = calculateShortSide()
            itemsPerRow = 2.0
        }
        
        albumCellWidth = (referenceWidth - cellInsets.left - cellInsets.right) / itemsPerRow
        albumCellHeight = albumCellWidth //Same for now.  May make non square for titles
        
        artistCellWidth = referenceWidth - cellInsets.left - cellInsets.right
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (indexedArtistData[sections[section]]?.count)!
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
        if(albumData.type == AlbumData.DataType.ARTIST){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArtistNameCell", forIndexPath: indexPath) as! ArtistTitleCell
            cell.artistName = albumData.artist
//            cell.adjustSize(self.collectionView!.bounds.size)
            
            return cell

        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
            cell.albumData = albumData
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let cell =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeaderCell", forIndexPath: indexPath) as! SectionHeaderCell
            cell.title = sections[indexPath.section]
            return cell
        }
        abort()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
        if(albumData.type == AlbumData.DataType.ARTIST){
           return CGSize(width: artistCellWidth, height: artistCellHeight)
        }
        else {
            return CGSize(width: albumCellWidth, height: albumCellHeight)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return cellInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
