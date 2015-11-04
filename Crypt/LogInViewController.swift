//
//  LogInViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Lock

class LogInViewController: BaseUserInputViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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

    @IBAction func logIn() {
        guard let username = usernameTextField.text where username.isNotBlank else{
            self.showCannotBeEmptyAlert("email")
            return
        }
        guard let password = passwordTextField.text where password.isNotBlank else{
            self.showCannotBeEmptyAlert("password")
            return
        }
        let client = GlobalState.sharedInstance.lock.apiClient()
        let parameters = A0AuthParameters(dictionary: [A0ParameterConnection : "Username-Password-Authentication"])
        if username.isEmail{
            client.loginWithEmail(username, passcode: password, parameters: parameters, success: { profile, token in
                print("Logged in user \(profile.email)")
                print("Tokens: \(token)")
                }, failure: { error in
                    print("Oops something went wrong: \(error)")
            })
        }
        else{
            client.loginWithUsername(username, password: password, parameters: parameters, success: { profile, token in
                print("Logged in user \(profile.email)")
                print("Tokens: \(token)")
                }, failure: { error in
                    print("Oops something went wrong: \(error)")
            })
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
