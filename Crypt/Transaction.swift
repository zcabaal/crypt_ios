//
//  Transaction.swift
//  Crypt
//
//  Created by Mac Owner on 18/04/2016.
//  Copyright © 2016 Crypt transfer. All rights reserved.
//

import UIKit
import SwiftyJSON

class Transaction {
    var amount: Int
    var capReached: Bool
    var completed: Bool
    var receivedAt: String
    var sentAt: String
    
    required init(json: JSON){
        self.amount = json["amount"].intValue
        self.capReached = json["cap_reached"].boolValue
        self.completed = json["completed"].boolValue
        self.receivedAt = json["received_at"].stringValue
        self.sentAt = json["sent_at"].stringValue
    }
}
