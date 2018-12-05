//
//  AlbumPhotoSlideViewController.swift
//  VAPEiXSocial
//
//  Created by Ved on 05/11/15.
//  Copyright © 2015 Ved. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AlbumPhotoSlideViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate{

    @IBOutlet weak var tblAlbumImages: UICollectionView!
    
    var arrAlbumImages = NSMutableArray()
    var index : Int = 0
    var indexpath = NSIndexPath(row: 0, section: 0)
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        self.tblAlbumImages.minimumZoomScale = 1.0
        self.tblAlbumImages.maximumZoomScale = 10.0
        self.tblAlbumImages.zoomScale = 1.0
        
        indexpath = NSIndexPath(row: index, section: 0)
        
        self.tblAlbumImages.scrollToItem(at: indexpath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        
        self.tblAlbumImages.reloadData()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.tblAlbumImages.center
        self.tblAlbumImages.addSubview(indicator)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAlbumImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumImageSlideShowCell", for: indexPath) as! AlbumImageSlideShowCell
        
        let objPost = arrAlbumImages.object(at: indexPath.row) as! ImageModel
        
        let strImageURL : NSString
        
        let isImageVideo = objPost.IsImageVideo as Int
        
        if(isImageVideo == 2){
            strImageURL = objPost.VideoThumbnail as NSString
            cell.imgPlay.isHidden = false
//            indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
//            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//            indicator.center = cell.imgPlay.center

        }
        else{
            strImageURL = objPost.PostContent as NSString
            cell.imgPlay.isHidden = true
//            indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width:40, height:40))
//            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//            indicator.center = cell.imgAlbum.center

        }
        
      //  cell.imgAlbum.addSubview(indicator)
        
      //  indicator.startAnimating()
        
        let imgURL = NSURL(string: strImageURL as String)
        
        let imageRequest = NSURLRequest(url: imgURL as! URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
        cell.imgAlbum.setImageWith(imageRequest as URLRequest!, placeholderImage: UIImage(named: "noAlbumLand.png"), withGradient: true, success: nil, failure: nil)
        
        
        
     /*   // The image isn't cached, download the img data
        // We should perform this in a background thread
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        let mainQueue = OperationQueue.main
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    
                    cell.imgAlbum.image = image
                    
                    if(isImageVideo == 2){
                        cell.imgPlay.isHidden = false
                    }
                    else{
                        cell.imgPlay.isHidden = true
                    }
                    
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            }
            else{
                
                cell.imgAlbum.image = UIImage(named:"noAlbumLand.png")
               
                if(isImageVideo == 2){
                    cell.imgPlay.isHidden = false
                }
                else{
                    cell.imgPlay.isHidden = true
                }
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
               
            }
        })
    */
        
        return cell

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objPost = arrAlbumImages.object(at: indexPath.row) as! ImageModel
        let isImageVideo = objPost.IsImageVideo as Int
        
        let strImageURL : NSString
        
        if(isImageVideo == 2){
            strImageURL = objPost.PostContent as NSString
            let videoURL = NSURL(string: strImageURL as String)
            
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoURL as! URL)
            self.present(playerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
