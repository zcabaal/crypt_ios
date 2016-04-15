//
//  IssueViewController.swift
//  Crypt
//
//  Created by Mac Owner on 15/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftValidator

class IssueViewController: BaseUserInputViewController {

    @IBOutlet weak var emailErrorLable: UILabel!{
        didSet{
            emailErrorLable.text = ""
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.text = App.sharedInstance.profile?.email
        }
    }
    @IBOutlet weak var emailExclamation: UILabel!{
        didSet{
            emailExclamation.hidden = true
        }
    }

    @IBOutlet weak var messageErrorLable: UILabel!{
        didSet{
            messageErrorLable.text = ""
        }
    }
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailTextField, errorLabel: emailErrorLable, rules: [RequiredRule(),EmailRule()])
        validator.registerField(messageTextField, errorLabel: messageErrorLable, rules: [RequiredRule()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit() {
        validator.validate(self)
    }
    
    override func validationSuccessful() {
        guard let email = emailTextField.text where email.isNotBlank else{
            self.showCannotBeEmptyAlert(NSLocalizedString("email", comment: ""))
            return
        }
        guard let message = emailTextField.text where message.isNotBlank else{
            self.showCannotBeEmptyAlert(NSLocalizedString("message", comment: ""))
            return
        }
        
        let endpoint = "issue"
        var params = ["email":email,"message":message]
        if let type = self.title{
            params["type"] = type
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if let _ = App.sharedInstance.keychain.stringForKey("id_token"){
            App.sharedInstance.apiRequest(.POST, endpoint, completionHandler: completionHandler(hud))
        }
        else{
            Alamofire.request(.POST, App.baseURL + endpoint, parameters: params).responseJSON(completionHandler: completionHandler(hud))
        }
    }
    
    func completionHandler(hud: MBProgressHUD) -> (Response<AnyObject, NSError>) -> (){
        return { response in
            if let error = response.result.error{
                print("error sending issue ticket")
                print(error.code)
                print(error.userInfo)
                self.showBasicAlert(error.localizedDescription)
            }
            else{
                self.showBasicAlert(NSLocalizedString("Success", comment: ""), message:NSLocalizedString("Message send successfully", comment: ""))
            }
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
