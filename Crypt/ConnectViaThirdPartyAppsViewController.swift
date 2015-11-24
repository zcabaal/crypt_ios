//
//  SplashViewController.swift
//  Crypt
//
//  Created by Mac Owner on 30/10/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Lock
import MBProgressHUD 

class ConnectViaThridPartyAppsViewController: UIViewController {
    
    private struct Constants {
        static let socialApps = ["Facebook":"facebook","Twitter":"twitter","Google":"google-oauth2"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectWithSotialApp(sender: UIButton){
        let lock = GlobalState.sharedInstance.lock
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if let buttonLable = sender.titleLabel?.text
            ,connectionName = Constants.socialApps[buttonLable]{
            lock.identityProviderAuthenticator().authenticateWithConnectionName(connectionName, parameters: nil, success: self.successCallback(hud), failure: self.errorCallback(hud))
        }
    }

    private func errorCallback(hud: MBProgressHUD) -> NSError -> () {
        return { error in
            let alert = UIAlertController(title: "Login failed", message: "Please check you application logs for more info", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("Failed with error \(error)")
            hud.hide(true)
        }
    }
    
    private func successCallback(hud: MBProgressHUD) -> (A0UserProfile, A0Token) -> () {
        return { (profile, token) -> Void in
            let alert = UIAlertController(title: "Logged In!", message: "User with name \(profile.name) logged in!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("Logged in user \(profile.name)")
            print("Tokens: \(token)")
            hud.hide(true)
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
