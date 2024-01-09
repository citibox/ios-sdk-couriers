//
//  RetrievalResults.swift
//  
//
//  Created by Marcos Alba on 9/1/24.
//

import SwiftUI

/**
 Result view model.
 
 This object is observable so that updates in result are received by subscribers.
 - seealso:
   - `RetrievalResult`
   - `RetrievalResultSuccess`
   - `RetrievalResultCancel`
   - `RetrievalResultError`
   - `RetrievalResultFailure`
 */
public class RetrievalResultViewModel: ObservableObject {
    @Published public var result: (any RetrievalResult)?

    public init() {
        
    }
}

/**
A representation of a retrieval result.
 
 When retrieval is done, `CourierView` will return a result which type will be one of the next ones, one per each possible scenario
 - Success --> `RetrievalResultSuccess`
 - Error --> `RetrievalResultError`
 - Failure --> `RetrievalResultFailure`
 - Cancel --> `RetrievalResultCancel`
 
 - seealso:
   - `RetrievalResult`
   - `RetrievalResultSuccess`
   - `RetrievalResultCancel`
   - `RetrievalResultError`
   - `RetrievalResultFailure`
 */

public protocol RetrievalResult: Codable & Equatable {
    
}

/**
 Retrieval result success
 
 The package has been retrieved from the box successfully.
 
 - seealso:
   - `RetrievalResult`
 */
public struct RetrievalResultSuccess: RetrievalResult {
    /// Box number where the package was retrieved in the Citibox location
    public let boxNumber: Int
    /// ID for this Citibox transaction
    public let citiboxId: Int
    
    /// Returns a Boolean value indicating whether the given success results are equal.
    ///
    /// - parameter lhs: The success result to compare against.
    /// - parameter rhs: The success result to compare with.
    public static func == (lhs: RetrievalResultSuccess, rhs: RetrievalResultSuccess) -> Bool {
        lhs.boxNumber == rhs.boxNumber &&
        lhs.citiboxId == rhs.citiboxId
    }
}

/**
 Retrieval result error
 
 The mandatory data hasn’t been sent correctly, and app can’t work without it.
 
 Error codes:
  - `access_token_missing`: The mandatory data access_token wasn’t sent.
  - `citibox_id_missing`: The mandatory data citibox_id wasn’t sent.
  - `access_token_invalid`: The auth_token field has expired or is invalid. A non-expired valid token is needed to create a Retrieval.
  - `access_token_permissions_denied`: The auth_token hasn’t expired but it doesn’t have permissions to create deliveries.
  - `wrong_location`:  The location scanned/typed doesn't match with the tracking and citibox_id location. This package exists, but it is placed in a different location.

 - seealso:
   - `RetrievalResult`
 */
public struct RetrievalResultError: RetrievalResult {
    /// Error codes which explains the error opening Courier app.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given error results are equal.
    ///
    /// - parameter lhs: The error result to compare against.
    /// - parameter rhs: The error result to compare with.
    public static func == (lhs: RetrievalResultError, rhs: RetrievalResultError) -> Bool {
        lhs.code == rhs.code
    }
}

/**
 Retrieval result failure
 
 The package hasn’t been retrieved from the box because a problem was found.
 
 Failure codes:
  - `parcel_not_available`: The package couldn’t be in the required state.
  - `max_reopens_exceed`: The maximum number of opening boxes tries have been exceeded.
  - `empty_box`: There isn’t a packet into box.
 
 - seealso:
   - `RetrievalResult`
 */
public struct RetrievalResultFailure: RetrievalResult {
    /// The code for the problem that the courier faced.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given failure results are equal.
    ///
    /// - parameter lhs: The failure result to compare against.
    /// - parameter rhs: The failure result to compare with.
    public static func == (lhs: RetrievalResultFailure, rhs: RetrievalResultFailure) -> Bool {
        lhs.code == rhs.code
    }
}

/**
 Retrieval result cancel
 
 The package hasn’t been retrieved from the box because the courier cancelled on purpose.
 
 Cancel codes:
  - `not_started`: The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.
  - `cant_open_boxes`: The courier couldn’t open any of the boxes offered.
  - `other`: The other specified “other” in the cancellation reason form.
 
 - seealso:
   - `RetrievalResult`
 */
public struct RetrievalResultCancel: RetrievalResult {
    /// The reason the courier cancelled the transaction with Citibox.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given cancel results are equal.
    ///
    /// - parameter lhs: The cancel result to compare against.
    /// - parameter rhs: The cancel result to compare with.
    public static func == (lhs: RetrievalResultCancel, rhs: RetrievalResultCancel) -> Bool {
        lhs.code == rhs.code
    }
}

