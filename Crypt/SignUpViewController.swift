//
//  SignUpViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Lock

class SignUpViewController: BaseUserInputViewController  {

    private struct Constants{
        static let email = NSLocalizedString("email", comment: "")
        static let password = NSLocalizedString("password", comment: "")
        static let username = NSLocalizedString("username", comment: "")
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func maximumLengthForTextField(textField: UITextField) -> Int {
        return 64
    }
    
    @IBAction func signUp() {
        guard let email = emailTextField.text where email.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.email)
            return
        }
        guard email.isEmail else{
            self.showInvalidInputAlett(Constants.email)
            return
        }
        guard let password = passwordTextField.text where password.isNotBlank else{
            self.showCannotBeEmptyAlert(Constants.password)
            return
        }
        let username = usernameTextField.text
        if username?.isEmail == true{
            self.showInvalidInputAlett(Constants.username)
            return
        }
        let client = GlobalState.sharedInstance.lock.apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : "Username-Password-Authentication"])
        client.signUpWithEmail(email, username: usernameTextField.text, password: password, loginOnSuccess: true, parameters: parameters, success: { profile, token in
            print("Logged in user \(profile?.email)")
            print("Tokens: \(token)")
            }, failure: { error in
                print("Oops something went wrong: \(error)")
        })
        
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
