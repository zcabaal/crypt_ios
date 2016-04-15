//
//  LogInViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Lock
import MBProgressHUD
import SwiftValidator

class LogInViewController: BaseUserInputViewController {

    private struct Constants{
        static let password = NSLocalizedString("password", comment: "")
        static let email = NSLocalizedString("email", comment: "")
    }
    
    @IBOutlet weak var emailErrorLable: UILabel!{
        didSet{
            emailErrorLable.text = ""
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailExclamation: UILabel!{
        didSet{
            emailExclamation.hidden = true
        }
    }
    @IBOutlet weak var passwordErrorLable: UILabel!{
        didSet{
            passwordErrorLable.text = ""
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordExclamation: UILabel!{
        didSet{
            passwordExclamation.hidden = true
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailTextField, errorLabel: emailErrorLable, rules: [RequiredRule(),EmailRule()])
        validator.registerField(passwordTextField, errorLabel: passwordErrorLable, rules: [RequiredRule()])
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getExclamationLable(textField:UITextField) -> UILabel?{
        switch textField{
        case emailTextField:
            return emailExclamation
        case passwordTextField:
            return passwordExclamation
        default:
            return nil
        }
    }

    @IBAction func logIn() {
        validator.validate(self)
        
    }
    
    override func validationSuccessful() {
        guard let email = emailTextField.text where email.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.email)
            return
        }
        guard let password = passwordTextField.text where password.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.password)
            return
        }
        let client = App.sharedInstance.lock.apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : "Username-Password-Authentication"])
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        client.loginWithEmail(email, passcode: password, parameters: parameters, success: successCallback(hud), failure: errorCallback(hud))
    }
    
    private func errorCallback(hud: MBProgressHUD) -> NSError -> () {
        return { error in
            let errorMessage = error.userInfo["A0JSONResponseSerializerErrorDataKey"]?["error_description"]??.description ?? error.userInfo["NSLocalizedFailureReason"] as? String
            self.showBasicAlert(NSLocalizedString("Login Failed", comment: ""), message: errorMessage ?? GlobalPrefs.sharedInstance.gracefulErrorMessage)
            print("Failed with error \(error)")
            hud.hide(true)
            
        }
    }
    
    private func successCallback(hud: MBProgressHUD) -> (A0UserProfile, A0Token) -> () {
        return { (profile, token) -> Void in
            let keychain = App.sharedInstance.keychain
            keychain.setString(token.idToken, forKey: "id_token")
            if let refreshToken = token.refreshToken {
                keychain.setString(refreshToken, forKey: "refresh_token")
            }
            App.sharedInstance.profile = profile
            print("Logged in user \(profile.name)")
            print("Tokens: \(token)")
            hud.hide(true)
            self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("nav1"))!, animated: true, completion: nil)
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
