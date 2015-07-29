//
//  FirstViewController.swift
//  SMSKids
//
//  Created by Daniel - Home on 28/04/15.
//  Copyright (c) 2015 smskids. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import MessageUI
import AVFoundation
import AssetsLibrary
import Parse
import ParseUI





class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate{
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let logInController = LoginViewController()
    let signUpController = SignUpViewController()
    var imagePicker = UIImagePickerController()
    var newMedia: Bool?
    var setAlert: Bool?
    let webService = WordPressWebServices()
    var category = [Dictionary<String, AnyObject>]()
    var posts = [Dictionary<String, AnyObject>]()
    var responseData = NSMutableData()
    private var baseURL:String? = "http://smskids.org/wp-json"
    


    @IBOutlet weak var progressLabel: UILabel!
 
    @IBOutlet weak var captureButton: UIButton!
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        if (PFUser.currentUser() == nil) {
            
            logInController.delegate = self
            logInController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten
            
            signUpController.delegate = self
            signUpController.fields = PFSignUpFields.UsernameAndPassword | PFSignUpFields.Email | PFSignUpFields.SignUpButton 
        
            self.logInController.signUpController = self.signUpController
            
            self.presentViewController(logInController, animated: true, completion: nil)
            
            println("login")
            
        
            
        }
        
    

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func checkLoggedIn() {
        
    }
    
    
    @IBAction func captureVideo(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            println("captureVideoPressed and camera available.")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = true
            imagePicker.showsCameraControls = true
            imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
            newMedia = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            println("Camera not available.")
        }
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
        if (newMedia == true) {
            
            let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
            let pathString = tempImage.relativePath
            self.dismissViewControllerAnimated(true, completion: {})
            
            UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
            
            
            self.openVideoRoll()
            
        }
        else if (newMedia == false) {
            setAlert = true
            self.dismissViewControllerAnimated(true, completion: {})
            
            var alert = UIAlertController(title: "Upload", message: "Do you want to upload the video to smskids.org?", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler:    {(alert :UIAlertAction!) in
                println("YOU PRESSED YES BUTTON")
                
                // ------------------------------- Upload Handling ---------------------------------
                
                let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
                
                if let type:AnyObject = mediaType {
                    
                    if type is String{
                        let stringType = type as! String
                        
                        if stringType == kUTTypeMovie as! String{
                            let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                            
                            
                            
                            if let url = urlOfVideo{
                                
                                println("Url of video = \(url)")
                                
                                
                                //UPLOAD HANDLING
                                let body = NSMutableData()
                                let path = urlOfVideo!.absoluteString
                                let filenameMov = path!.lastPathComponent
                                let filename = filenameMov.removeCharsFromEnd(3) + "mp4"
                                let filePathKey = "file"
                                let boundary = self.generateBoundaryString()
                                var dataReadingError: NSError?
                                let videoData = NSData(contentsOfURL: url)
                                let mimetype = "video/quicktime"
                                
                                body.appendString("--\(boundary)\r\n")
                                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                                body.appendData(videoData!)
                                body.appendString("\r\n")
                                body.appendString("--\(boundary)--\r\n")
                                
                                
                                
                                // BASIC AUTH.
                                let username = "admin-bill"
                                let password = "IS15R1@s]P=_0A|"
                                let loginString = NSString(format: "%@:%@", username, password)
                                let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
                                let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
                                let url = NSURL(string: self.baseURL! + "/media")
                                let request = NSMutableURLRequest(URL: url!)
                                
                                request.HTTPMethod = "POST"
                                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                                request.HTTPBody = body
                                
                                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                                let authString = "Basic \(base64LoginString)"
                                config.HTTPAdditionalHeaders = ["Authorization" : authString,"Connection" : "Keep-Alive"]
                                
                                let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                                
                                
                                session.dataTaskWithRequest(request, completionHandler: {
                                    data, response, error in
                                    
                                    if error != nil {
                                        // handle error here
                                        var alertSuccess = UIAlertController(title: "Error", message: "There was an error. Please try again. Thanks!", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        alertSuccess.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                        
                                        self.presentViewController(alertSuccess, animated: true, completion: nil)
                                        
                                        return
                                    }
                                    
                                    // if response was JSON, then parse it
                                    
                                    var parseError: NSError?
                                    let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
                                    
                                    if let responseDictionary = responseObject as? NSDictionary {
                                        // handle the parsed dictionary here
                                    } else {
                                        println(parseError)
                                    }
                                    
                                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                                    println("responseString = \(responseString)")
                                    println("Successfully loaded the data")
                                    
                                    var alertSuccess = UIAlertController(title: "Uploaded!", message: "They video was succesfully uploaded for review. It will be published very soon. Thanks!", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    alertSuccess.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                    
                                    self.presentViewController(alertSuccess, animated: true, completion: nil)
                                    
                                    self.progressLabel.hidden = true

                                    
                                    
                                })
                                
                                .resume()
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }))
            
            
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
    }
        
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    
    func openVideoRoll() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
                imagePicker.mediaTypes = [ kUTTypeMovie as NSString]
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = false
        }
    }
    
        
   
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
     // -------------------------------- Upload Methods -----------------------------------------
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            println("session \(session) occurred error \(error?.localizedDescription)")
        } else {
            println("session \(session) upload completed, response: \(NSString(data: responseData, encoding: NSUTF8StringEncoding))")
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        var uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressLabel.hidden = false
        progressLabel.text = (String(format: "%.0f", uploadProgress * 100) + "%")
        
        println("session \(session) uploaded \(uploadProgress * 100)%.")
        
        
        
    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("session \(session), received response \(response)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
    
    
    
}