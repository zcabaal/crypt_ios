//
//  ResetPasswordViewController.swift
//  Crypt
//
//  Created by Mac Owner on 15/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import Lock
import MBProgressHUD
import SwiftValidator

class ResetPasswordViewController: BaseUserInputViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailTextField, errorLabel: emailErrorLable, rules: [RequiredRule(),EmailRule()])
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
        default:
            return nil
        }
    }
    
    @IBAction func resetPassword() {
        validator.validate(self)
        
    }
    
    override func validationSuccessful() {
        guard let email = emailTextField.text where email.isNotBlank else{
            self.showCannotBeEmptyAlert(NSLocalizedString("email", comment: ""))
            return
        }
        let client = App.sharedInstance.lock.apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : "Username-Password-Authentication"])
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        client.requestChangePasswordForUsername("email", parameters: parameters, success: successCallback(hud), failure: errorCallback(hud))
    }
    
    private func errorCallback(hud: MBProgressHUD) -> NSError -> () {
        return { error in
            let errorMessage = error.userInfo["A0JSONResponseSerializerErrorDataKey"]?["error_description"]??.description ?? error.userInfo["NSLocalizedFailureReason"] as? String
            self.showBasicAlert(NSLocalizedString("Rest Password Failed", comment: ""), message: errorMessage ?? GlobalPrefs.sharedInstance.gracefulErrorMessage)
            print("Failed with error \(error)")
            hud.hide(true)
            
        }
    }
    
    private func successCallback(hud: MBProgressHUD) -> () -> (){
        return {
            hud.hide(true)
            self.showBasicAlert(NSLocalizedString("Success", comment: ""), message: NSLocalizedString("You have recieved an email with instructions on how to set your password", comment: ""))
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
