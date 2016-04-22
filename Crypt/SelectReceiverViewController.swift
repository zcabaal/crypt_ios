//
//  SelectReceiverViewController.swift
//  Crypt
//
//  Created by Mac Owner on 22/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import FBSDKShareKit

class SelectReceiverViewController: UIViewController, FBSDKSharingDelegate {
    
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var whatsapp: UIButton!
    @IBOutlet weak var others: UIButton!
    
    var text : String{
        get{
            return "I just sent you \(amount!) using Crypt. Click the link to receive your money "
        }
    }
    var token : String?
    var amount : String?
    var receiverURL : NSURL{
        get{
            return NSURL(string: App.baseURL+"/receiver/\(token!)")!
        }
    }
    let logoURL = NSURL(string: GlobalPrefs.sharedInstance.logoUrl)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!UIApplication.sharedApplication().canOpenURL(NSURL(string: "whatsapp://send")!)){
            whatsapp.hidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareWithFacebook(sender: UIButton){
        let content = FBSDKShareLinkContent()
        content.contentURL = receiverURL
        content.contentTitle = "I just sent you \(amount!)"
        content.imageURL = logoURL
        content.contentDescription = text
        FBSDKMessageDialog.showWithContent(content, delegate: self)
    }
    
    @IBAction func shareWithOtherMethods(){
        let controller = UIActivityViewController(activityItems: [text, receiverURL], applicationActivities: [])
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareWithWhatsApp(){
        let urlStringEncoded = (text + receiverURL.absoluteString).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        if let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)"){
            UIApplication.sharedApplication().openURL(url)
        }
        
        
    }
    
    // MARK: FBSDKSharingDelegate
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!){
        print("facebook sharing completed \(results.debugDescription)")
    }
    
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!){
        print("facebook sharing failed \(error.debugDescription)")
    }
    
    
    func sharerDidCancel(sharer: FBSDKSharing!){
        print("facebook sharing cancelled")
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
