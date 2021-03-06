//
//  AlbumViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumViewController: UICollectionViewController, UICollectionViewDelegateLeftAlignedLayout {

//    let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let contentInsets = UIEdgeInsets(top: 0.0, left: 10, bottom: 0.0, right: 10)
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
    
    var indexView : BDKCollectionIndexView!
    
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
        
//        let contentInset = collectionView!.contentInset
//        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: contentInset.right)
        
        collectionView?.contentInset = contentInsets

        adjustCellDimensions(toOrientation: UIApplication.sharedApplication().statusBarOrientation)
        
        //https://gist.github.com/kreeger/4756030
        buildIndexView()
        indexView.indexTitles = sections
        view.addSubview(indexView) //This wasnt in the demo
        
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
        
        albumCellWidth = (referenceWidth - contentInsets.left - contentInsets.right - 4.0) / itemsPerRow
        albumCellHeight = albumCellWidth +  (0.2 * albumCellWidth) //Same for now.  May make non square for titles
        
        artistCellWidth = referenceWidth - contentInsets.left - contentInsets.right
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
        
//        return cellInsets
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4.0 //Between
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4.0 //Under
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100) //An attempt to space the section header's out. Seems to work.
    }
    
    
    //MARK: Index View
    /**
    
    Trevis! Basically these two methods get it done for adding the index to your collection view.  Notice how
    indexViewValueChanged is just passed in as a string when the Objective C class is expecting a selector
    */
    func buildIndexView() -> BDKCollectionIndexView{
        if(indexView != nil){
            return indexView
        }
        let indexWidth : CGFloat = 20;
        let frame : CGRect = CGRectMake(CGRectGetWidth(self.collectionView!.frame) - indexWidth,
            CGRectGetMinY(self.collectionView!.frame) + 100,
            indexWidth,
            CGRectGetHeight(self.collectionView!.frame) - 200);  //Insetting the top and bottom of the index.  Dont forgget.  Looks horible in landscape.
        
        indexView = BDKCollectionIndexView(frame: frame, indexTitles: [String]())
        indexView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleLeftMargin]
        indexView.addTarget(self, action: "indexViewValueChanged:", forControlEvents: .ValueChanged)
        return indexView
    }
    
    func indexViewValueChanged(view : BDKCollectionIndexView){
        let path = NSIndexPath(forItem: 0, inSection: Int(view.currentIndex))
        collectionView?.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        
        // I bump the y-offset up by 45 points here to account for aligning the top of
        // the section header view with the top of the collectionView frame. It's
        // hardcoded, but you get the idea.
        collectionView!.contentOffset = CGPointMake(self.collectionView!.contentOffset.x,
            self.collectionView!.contentOffset.y - 65);// Weird magic number stuff
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
