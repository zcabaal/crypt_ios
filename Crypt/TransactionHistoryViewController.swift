//
//  TransactionHistoryViewController.swift
//  Crypt
//
//  Created by Mac Owner on 18/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransactionHistoryViewController: UITableViewController {

    // src: some code snippets are taken from https://grokswift.com/rest-tableview-in-swift/
    var transactions: [Transaction] = []
    var currentPage = 1
    var canFetchTransactions = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTransactions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let transaction = transactions[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = "Transaction for £ \(transaction.amount)"
        if (indexPath.row > transactions.count - 5 && canFetchTransactions){
            fetchTransactions()
        }
        return cell
    }
    
    func fetchTransactions(){
        canFetchTransactions = false
        App.sharedInstance.apiRequest(.GET, "transaction/history",parameters: ["page":currentPage]) { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonArray = JSON(value).arrayValue
                    for jsonElement in jsonArray{
                        self.transactions.append(Transaction(json: jsonElement))
                    }
                    self.currentPage += 1
                    self.tableView?.reloadData()
                    self.canFetchTransactions = true
                }
            case .Failure(let error):
                print(error)
                self.canFetchTransactions = true
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
