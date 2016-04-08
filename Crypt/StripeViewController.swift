//
//  StripeViewController.swift
//  Crypt
//
//  Created by Mac Owner on 04/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import Alamofire
import Stripe

class StripeViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        saveButton.enabled = textField.valid
    }
    
    @IBAction func save() {
        print("Saving ...")
        let card = paymentTextField.cardParams
        STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
            if let error = error  {
                self.handleError(error)
            }
            else if let token = token {
                self.createBackendChargeWithToken(token) { status in
                        
                }
            }
        }
    }
    
    func handleError(error: NSError){
        
    }
    
    func createBackendChargeWithToken(token: STPToken, completion: PKPaymentAuthorizationStatus -> ()) {
        print("Got token \(token.tokenId)")
        /*Alamofire.request(.POST, "https://example.com/token",parameters: ["stripeToken":token.tokenId]).response { (request, response, data, error) -> Void in
            // TODO: Handle errors
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
            }
            
        }*/
    }
    @IBAction func cancel() {
        
    }
}