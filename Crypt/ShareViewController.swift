//
//  ShareViewController.swift
//  Crypt
//
//  Created by Mac Owner on 18/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
    
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var whatsapp: UIButton!
    @IBOutlet weak var others: UIButton!
    
    let serviceType = [
        "facebook": SLServiceTypeFacebook,
        "twitter": SLServiceTypeTwitter
    ]
    
    var sharingText = "Dowload Crypt now on the app store " + GlobalPrefs.sharedInstance.sharingUrl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)){
            facebook.hidden = true
        }
        if (!SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)){
            twitter.hidden = true
        }
        if (!UIApplication.sharedApplication().canOpenURL(NSURL(string: "whatsapp://send")!)){
            whatsapp.hidden = true
        }
        if(facebook.hidden && twitter.hidden && whatsapp.hidden){
            // If all other buttons are hidden, the remaining button is tapped by default
            shareWithOtherMethods()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareWithFacebookOrTwitter(sender: UIButton){
        if let buttonLable = sender.titleLabel?.text{
            let composer = SLComposeViewController(forServiceType: serviceType[buttonLable])
            
            composer.setInitialText(sharingText)
            
            self.presentViewController(composer, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareWithOtherMethods(){
        let controller = UIActivityViewController(activityItems: [sharingText], applicationActivities: [])
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareWithWhatsApp(){
        let urlStringEncoded = sharingText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        if let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)"){
            UIApplication.sharedApplication().openURL(url)
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
