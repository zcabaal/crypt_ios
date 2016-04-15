//
//  GlobalPrefs.swift
//  Crypt
//
//  Created by Mac Owner on 11/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import Foundation
import Alamofire

class GlobalPrefs{
    
    static let sharedInstance = GlobalPrefs()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var about :NSAttributedString{
        get{
            return htmlAttributedString(userDefaults.objectForKey("about") as? String ?? "")
        }
    }
    var faq :NSAttributedString{
        get{
            return htmlAttributedString(userDefaults.objectForKey("faq") as? String ?? "")
        }
    }
    var privacyPolicy :NSAttributedString{
        get{
            return htmlAttributedString(userDefaults.objectForKey("privacy_policy") as? String ?? "")
        }
    }

    var termsAndConditions :NSAttributedString{
        get{
            return htmlAttributedString(userDefaults.objectForKey("terms_and_conditions") as? String ?? "")
        }
    }
    var sharingUrl :String{
        get{
            return userDefaults.objectForKey("sharing_url") as? String ?? ""
        }
    }
    var gracefulErrorMessage :String{
        get{
            return userDefaults.objectForKey("graceful_error_message") as? String ?? "Oooops! Something went wrong!"
        }
    }
    var logoUrl :String{
        get{
            return userDefaults.objectForKey("logo_url") as? String ?? ""
        }
    }
    var appTourMessages: [String:AnyObject]{
        get{
            return userDefaults.objectForKey("app_tour_messages") as? [String:AnyObject] ?? [:]
        }
    }
    var supportedCurrencies :[[String:String]]{
        get{
            return userDefaults.objectForKey("supported_currencies") as? [[String:String]] ?? []
        }
    }
    
    func fetch(retryAfterInterval: NSTimeInterval){
        print(App.baseURL+"/global_prefs")
        Alamofire.request(.GET, App.baseURL+"/global_prefs").responseJSON { (response) in
            if let error = response.result.error{
                print("error fetching global prefs")
                print(error.code)
                print(error.userInfo)
                NSTimer.scheduledTimerWithTimeInterval(retryAfterInterval, target: self, selector: #selector(GlobalPrefs.timerFunc(_:)), userInfo: nil, repeats: false)
            }
            else if let responseJSON = response.result.value as? [String: AnyObject]{
                print(responseJSON.debugDescription)
                for (key,value) in responseJSON{
                    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
                }
                NSUserDefaults.standardUserDefaults().synchronize()
                NSNotificationCenter.defaultCenter().postNotificationName("globalPrefs", object: nil)
            }
            else{
                print("server has no global prefs")
            }
        }
    }
    @objc func timerFunc(timer:NSTimer!) {
        fetch(2 * timer.timeInterval)
    }
    private init(){
    }
    
    
    private func htmlAttributedString(string: String) -> NSAttributedString{
        let htmlString = "<font face='Helvetica' size=3>\(string)</font>"
        do{
            return try NSAttributedString(data: htmlString.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        }
        catch _{
            return NSAttributedString()
        }
        
    }
}