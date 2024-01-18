//
//  DeliveryViewController.swift
//  CourierSDKTesterUIKit
//
//  Created by Marcos Alba on 17/1/24.
//

import Foundation
import SwiftUI
import Courier

class DeliveryViewController: UIViewController {
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultInfo: UILabel!
    @IBOutlet weak var accessToken: UITextField!
    @IBOutlet weak var tracking: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func showDelivery(_ coder: NSCoder) -> UIViewController? {
        let params = DeliveryParams(
            accessToken: accessToken.text ?? "",
            tracking: tracking.text ?? "",
            recipientPhone: phone.text ?? "",
            sandbox: true,
            debug: true
        )
        let view = DeliveryView(params: params) { result in
            self.resultTitle.text = result?.title ?? "Result"
            self.resultInfo.text = result?.info ?? "Info"
            self.dismiss(animated: true)
        }
        
        let controller = UIHostingController(coder: coder, rootView: view)
        return controller
    }

}

extension DeliveryResult {
    var title: String {
        if self is DeliveryResultSuccess {
            return (self as! DeliveryResultSuccess).title
        } else if self is DeliveryResultCancel {
            return (self as! DeliveryResultCancel).title
        } else if self is DeliveryResultError {
            return (self as! DeliveryResultError).title
        } else if self is DeliveryResultFailure {
            return (self as! DeliveryResultFailure).title
        } else {
            return "No result"
        }
    }
    
    var info: String {
        if self is DeliveryResultSuccess {
            return (self as! DeliveryResultSuccess).info
        } else if self is DeliveryResultCancel {
            return (self as! DeliveryResultCancel).info
        } else if self is DeliveryResultError {
            return (self as! DeliveryResultError).info
        } else if self is DeliveryResultFailure {
            return (self as! DeliveryResultFailure).info
        } else {
            return "No info"
        }
    }
}

extension DeliveryResultSuccess {
    var title: String {
        "Success"
    }
    
    var info: String {
        "Box number: \(boxNumber)\nCitibox ID: \(citiboxId)\nDelivery ID: \(deliveryId)"
    }
}

extension DeliveryResultCancel {
    var title: String {
        "Cancel"
    }
    
    var info: String {
        "Cancel code: \(code)"
    }
}

extension DeliveryResultError {
    var title: String {
        "Error"
    }
    
    var info: String {
        "Error code: \(code)"
    }
}

extension DeliveryResultFailure {
    var title: String {
        "Failure"
    }
    
    var info: String {
        "Failure code: \(code)"
    }
}
