//
//  WordPressWebServices.swift
//  WordPress-API
//




import Foundation
import UIKit
import MobileCoreServices



class WordPressWebServices: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
    
    private var baseURL:String? = "http://lunaticlive.com/wp-json"
    var responseData = NSMutableData()
    
    convenience init(url: String) {
        self.init()
        self.baseURL = url
        
    }
    
    
    func uploadFileToServerWithUrlAndPath(url:NSURL) {
        //UPLOAD HANDLING
        let body = NSMutableData()
        //let path = urlOfVideo!.absoluteString
        //let filename = path!.lastPathComponent
        let filePathKey = "file"
        let boundary = self.generateBoundaryString()
        var dataReadingError: NSError?
        let videoData = NSData(contentsOfURL: url)
        let mimetype = "video/quicktime"
        
        body.appendString("--\(boundary)\r\n")
       // body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(videoData!)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        
        
        // BASIC AUTH.
        let username = "admin-bill"
        let password = "jCi8%y&dU9s"
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
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        
        session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            if error != nil {
                // handle error here
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
            
            
        })
            .resume()
        
        
        println("Successfully loaded the data")
    }
    
    
    
    /// Create body of the multipart/form-data request
    ///
    /// :param: parameters   The optional dictionary containing keys and values to be passed to web service
    /// :param: filePathKey  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// :param: paths        The optional array of file paths of the files to be uploaded
    /// :param: boundary     The multipart/form-data boundary
    ///
    /// :returns:            The NSData of the body of the request
    
    func createBodyWithParameters(filePathKey: String?, path: String, boundary: String) -> NSData {
        
        
        let body = NSMutableData()
        
        
        //let path = data.base64EncodedStringWithOptions(nil)
        let filename = path.lastPathComponent
        
        
        let data = NSData(contentsOfFile: path)
        let mimetype = mimeTypeForPath(path)
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(data!)
        body.appendString("\r\n")
        
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    
    /// Create boundary string for multipart/form-data request
    ///
    /// :returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// :param: path         The path of the file for which we are going to determine the mime type.
    ///
    /// :returns:            Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        /*if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype
            }
        }*/
        return "video/quicktime";
    }
    
    

    func createPost(params : Dictionary<String, String>) {
        
        // set up the base64-encoded credentials
        let username = "admin-bill"
        let password = "jCi8%y&dU9s"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: baseURL! + "/posts")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let authString = "Basic \(base64LoginString)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        
        session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                println(dataString)
            }
                
        }.resume()
        
        
        
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    
                    println("SSUCCESS: '\(parseJSON)'")
                    
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    
    }
    
  
    
    
    func uploadFiles(data: NSData) {
        
        // set up the base64-encoded credentials
        let username = "admin-bill"
        let password = "jCi8%y&dU9s"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: baseURL! + "/media")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let authString = "Basic \(base64LoginString)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        
        
        /*session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                println(dataString)
            }
            
            }.resume()*/
        
        // Upload
        request.addValue("video/quicktime", forHTTPHeaderField: "Content-Type")
        request.addValue("video/quicktime", forHTTPHeaderField: "Accept")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        var err: NSError?
        
        
        
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        var task = session.uploadTaskWithRequest(request, fromData: data)
        task.resume()
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
        println("session \(session) uploaded \(uploadProgress * 100)%.")
        //progressView.progress = uploadProgress
    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("session \(session), received response \(response)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
    
    
    
}





