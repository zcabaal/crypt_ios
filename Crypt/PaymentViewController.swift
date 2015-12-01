//
//  PaymentViewController.swift
//  Crypt
//
//  Created by Mac Owner on 30/11/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Alamofire
import Braintree

class PaymentViewController: UIViewController, BTDropInViewControllerDelegate {

    var braintreeClient: BTAPIClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Alamofire.request(.GET, "https://braintree-sample-merchant.herokuapp.com/client_token").response { (request, response, data, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedMyPayButton() {
        
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
        // braintreeClient = BTAPIClient(authorization: aClientToken)
        
        // Create a BTDropInViewController
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
        dropInViewController.delegate = self
        
        // This is where you might want to customize your view controller (see below)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally-presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: "userDidCancelPayment")
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postNonceToServer(nonce: String){
        Alamofire.request(.POST, "https://your-server.example.com/payment-methods", parameters: ["payment_method_nonce":nonce], encoding: .URLEncodedInURL, headers: nil).response { (request, response, data, error) -> Void in
            // TODO: Handle success or failure
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
    // MARK; Drop in delegate
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce){
        // Send payment method nonce to your server for processing
        //postNonceToServer(paymentMethodNonce.nonce)
        print("Got my nonce!!")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
