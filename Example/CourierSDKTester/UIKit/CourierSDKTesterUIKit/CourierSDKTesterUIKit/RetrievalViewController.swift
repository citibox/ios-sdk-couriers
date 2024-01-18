//
//  RetrievalViewController.swift
//  CourierSDKTesterUIKit
//
//  Created by Marcos Alba on 17/1/24.
//

import Foundation
import SwiftUI
import Courier

class RetrievalViewController: UIViewController {
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultInfo: UILabel!
    @IBOutlet weak var accessToken: UITextField!
    @IBOutlet weak var citiboxId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func showRetrieval(_ coder: NSCoder) -> UIViewController? {
        let params = RetrievalParams(
            accessToken: accessToken.text ?? "",
            citiboxId: Int(citiboxId.text ?? "") ?? -1,
            sandbox: true,
            debug: true
        )
        let view = RetrievalView(params: params) { result in
            self.resultTitle.text = result?.title ?? "Result"
            self.resultInfo.text = result?.info ?? "Info"
            self.dismiss(animated: true)
        }
        
        let controller = UIHostingController(coder: coder, rootView: view)
        return controller
    }
}

extension RetrievalResult {
    var title: String {
        if self is RetrievalResultSuccess {
            return (self as! RetrievalResultSuccess).title
        } else if self is RetrievalResultCancel {
            return (self as! RetrievalResultCancel).title
        } else if self is RetrievalResultError {
            return (self as! RetrievalResultError).title
        } else if self is RetrievalResultFailure {
            return (self as! RetrievalResultFailure).title
        } else {
            return "No result"
        }
    }
    
    var info: String {
        if self is RetrievalResultSuccess {
            return (self as! RetrievalResultSuccess).info
        } else if self is RetrievalResultCancel {
            return (self as! RetrievalResultCancel).info
        } else if self is RetrievalResultError {
            return (self as! RetrievalResultError).info
        } else if self is RetrievalResultFailure {
            return (self as! RetrievalResultFailure).info
        } else {
            return "No info"
        }
    }
}

extension RetrievalResultSuccess {
    var title: String {
        "Success"
    }
    
    var info: String {
        "Box number: \(boxNumber)\nCitibox ID: \(citiboxId)"
    }
}

extension RetrievalResultCancel {
    var title: String {
        "Cancel"
    }
    
    var info: String {
        "Cancel code: \(code)"
    }
}

extension RetrievalResultError {
    var title: String {
        "Error"
    }
    
    var info: String {
        "Error code: \(code)"
    }
}

extension RetrievalResultFailure {
    var title: String {
        "Failure"
    }
    
    var info: String {
        "Failure code: \(code)"
    }
}
