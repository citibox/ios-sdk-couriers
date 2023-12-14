//
//  DeliveryResults.swift
//
//
//  Created by Marcos Alba on 12/12/23.
//

import SwiftUI

/**
 Result view model.
 
 This object is observable so that updates in result are received by subscribers.
 - seealso:
   - `DeliveryResult`
   - `DeliveryResultSuccess`
   - `DeliveryResultCancel`
   - `DeliveryResultError`
   - `DeliveryResultFailure`
 */
public class DeliveryResultViewModel: ObservableObject {
    @Published public var result: (any DeliveryResult)?

    public init() {
        
    }
}

/**
A representation of a result.
 
 When delivery is done, `CourierView` will return a result which type will be one of the next ones, one per each possible scenario
 - Success --> `DeliveryResultSuccess`
 - Error --> `DeliveryResultError`
 - Failure --> `DeliveryResultFailure`
 - Cancel --> `DeliveryResultCancel`
 
 - seealso:
   - `DeliveryResult`
   - `DeliveryResultSuccess`
   - `DeliveryResultCancel`
   - `DeliveryResultError`
   - `DeliveryResultFailure`
 */

public protocol DeliveryResult: Codable & Equatable {
    
}

/**
 Delivery result success
 
 The package has been deposited in the box successfully.
 
 - seealso:
   - `DeliveryResult`
 */
public struct DeliveryResultSuccess: DeliveryResult {
    /// Box number where the package was deposited in the Citibox location
    public let boxNumber: Int
    /// ID for this Citibox transaction
    public let citiboxId: Int
    /// Delivery ID
    public let deliveryId: String
    
    /// Returns a Boolean value indicating whether the given success results are equal.
    ///
    /// - parameter lhs: The success result to compare against.
    /// - parameter rhs: The success result to compare with.
    public static func == (lhs: DeliveryResultSuccess, rhs: DeliveryResultSuccess) -> Bool {
        lhs.boxNumber == rhs.boxNumber &&
        lhs.citiboxId == rhs.citiboxId &&
        lhs.deliveryId == rhs.deliveryId
    }
}

/**
 Delivery result error
 
 The mandatory data hasn’t been sent correctly, and app can’t work without it.
 
 Error codes:
  - `tracking_missing`:    The mandatory field tracking_id wasn’t sent.
  - `access_token_missing` :   The mandatory data access_token wasn’t sent.
  - `recipient_phone_missing`: The mandatory data recipient_phone wasn’t sent.
  - `duplicated_trackings`: Error that occurs when you try to use a parcel with a tracking_id that has been already used in any transaction in the system.
  - `recipient_phone_invalid`: The recipient_phone field doesn’t have a valid [E.164](https://en.wikipedia.org/wiki/E.164) format.
  - `access_token_invalid`: The auth_token field has expired or is invalid. A non-expired valid token is needed to create a delivery.
  - `access_token_permissions_denied`: The auth_token hasn’t expired but it doesn’t have permissions to create deliveries.

 - seealso:
   - `DeliveryResult`
 */
public struct DeliveryResultError: DeliveryResult {
    /// Error codes which explains the error opening Courier app.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given error results are equal.
    ///
    /// - parameter lhs: The error result to compare against.
    /// - parameter rhs: The error result to compare with.
    public static func == (lhs: DeliveryResultError, rhs: DeliveryResultError) -> Bool {
        lhs.code == rhs.code
    }
}

/**
 Delivery result failure
 
 The package hasn’t been deposited in the box because a problem was found.
 
 Failure codes:
  - `box_not_available`: If in the location there are no free boxes of the proper size.
  - `user_blocked`: If the addressee is blocked.
  - `user_autocreation_forbidden`: The user is not registered in Citibox and the carrier doesn’t allow deliveries to non registered users.
  - `max_reopens_exceed`: The maximum number of opening boxes tries have been exceeded.
 
 - seealso:
   - `DeliveryResult`
 */
public struct DeliveryResultFailure: DeliveryResult {
    /// The code for the problem that the courier faced.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given failure results are equal.
    ///
    /// - parameter lhs: The failure result to compare against.
    /// - parameter rhs: The failure result to compare with.
    public static func == (lhs: DeliveryResultFailure, rhs: DeliveryResultFailure) -> Bool {
        lhs.code == rhs.code
    }
}

/**
 Delivery result cancel
 
 The package hasn’t been deposited in the box because the courier cancelled on purpose.
 
 Cancel codes:
  - `not_started`: The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.
  - `cant_open_boxes`: The courier couldn’t open any of the boxes offered.
  - `parcel_mistaken`: The courier starts the delivery and the data inserted belongs to another package (a wrong package).
  - `package_in_box`: The courier finds another package in the box where we ask him to deposit it.
  - `need_hand_delivery`: The courier sees the need to deliver the package by hand. For example, he may cross with the addressee at the Citibox location.
  - `other`: The other specified “other” in the cancellation reason form.
 
 - seealso:
   - `DeliveryResult`
 */
public struct DeliveryResultCancel: DeliveryResult {
    /// The reason the courier cancelled the transaction with Citibox.
    public let code: String
    
    /// Returns a Boolean value indicating whether the given cancel results are equal.
    ///
    /// - parameter lhs: The cancel result to compare against.
    /// - parameter rhs: The cancel result to compare with.
    public static func == (lhs: DeliveryResultCancel, rhs: DeliveryResultCancel) -> Bool {
        lhs.code == rhs.code
    }
}
