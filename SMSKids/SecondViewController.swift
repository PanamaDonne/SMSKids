//
//  SecondViewController.swift
//  SMSKids
//
//  Created by Daniel - Home on 28/04/15.
//  Copyright (c) 2015 smskids. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer


class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newMedia: Bool?
    var objMoviePlayerController: MPMoviePlayerController = MPMoviePlayerController()
    var urlVideo :NSURL = NSURL()
    
    
    @IBOutlet weak var videoPlayerView: UIView!
    
    @IBOutlet weak var test: UILabel!
    
    
    //@IBOutlet weak var upLoadButton: UIButton!
    /*@IBAction func upLoadButtonClicked(sender: AnyObject) {
        
        var ipcVideo = UIImagePickerController()
        ipcVideo.delegate = self
        ipcVideo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        var kUTTypeMovieAnyObject : AnyObject = kUTTypeMovie as AnyObject
        ipcVideo.mediaTypes = [kUTTypeMovieAnyObject]
        self.presentViewController(ipcVideo, animated: true, completion: nil)
        
    }*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        test.font = UIFont.fontAwesomeOfSize(160)
        test.text = String.fontAwesomeIconWithName(FontAwesome.Photo)
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    func openVideoRoll() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [ kUTTypeMovie as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType == (kUTTypeMovie as! String) {
                // Video Handling
                
                //urlVideo = info.indexForKey(UIImagePickerControllerMediaURL) as NSString
                
                let path = NSBundle.mainBundle().pathForResource("Video", ofType:"mp4")
                let url = NSURL.fileURLWithPath(path!)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                objMoviePlayerController = MPMoviePlayerController(contentURL: url)
                objMoviePlayerController.movieSourceType = MPMovieSourceType.Unknown
                objMoviePlayerController.view.frame = self.videoPlayerView.bounds
                objMoviePlayerController.scalingMode = MPMovieScalingMode.AspectFill
                objMoviePlayerController.controlStyle = MPMovieControlStyle.Embedded
                objMoviePlayerController.shouldAutoplay = true
                
                videoPlayerView.addSubview(objMoviePlayerController.view)
                
                objMoviePlayerController.prepareToPlay()
                objMoviePlayerController.play()
                
            }
            
        }
        
        
    }
    
   
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }



}

