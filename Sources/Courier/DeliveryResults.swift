//
//  DeliveryResults.swift
//
//
//  Created by Marcos Alba on 12/12/23.
//

import Foundation
import SwiftUI

public class DeliveryResultViewModel {
    @Published public var result: DeliveryResult?
}

/**
 When delivery is done, `CourierView` will return a result which type will be one of the next ones, one per each possible scenario

 - Success --> `DeliveryResultSuccess`
 - Error --> `DeliveryResultError`
 - Failure --> `DeliveryResultFailure`
 - Cancel --> `DeliveryResultCancel`
 */

public protocol DeliveryResult {
    
}

/**
 Delivery result success
 
 The package has been deposited in the box successfully.
 */
public struct DeliveryResultSuccess: DeliveryResult {
    /// Box number where the package was deposited in the Citibox location
    public let box_number: Int
    /// ID for this Citibox transaction
    public let citibox_id: Int
}

/**
 Delivery result error
 
 The mandatory data hasn’t been sent correctly, and app can’t work without it.
 */
public struct DeliveryResultError: DeliveryResult {
    /// Error codes which explains the error opening Courier app.
    public let error_code: String
}

/**
 Delivery result failure
 
 The package hasn’t been deposited in the box because a problem was found.
 */
public struct DeliveryResultFailure: DeliveryResult {
    /// The code for the problem that the courier faced.
    public let failure_code: String
}

/**
 Delivery result cancel
 
 The package hasn’t been deposited in the box because the courier cancelled on purpose.
 */
public struct DeliveryResultCancel: DeliveryResult {
    /// The reason the courier cancelled the transaction with Citibox.
    public let cancel_code: String
}

/**
 Error codes:
  - `tracking_missing`:    The mandatory field tracking_id wasn’t sent.
  - `access_token_missing` :   The mandatory data access_token wasn’t sent.
  - `recipient_phone_missing`: The mandatory data recipient_phone wasn’t sent.
  - `duplicated_trackings`: Error that occurs when you try to use a parcel with a tracking_id that has been already used in any transaction in the system.
  - `recipient_phone_invalid`: The recipient_phone field doesn’t have a valid [E.164](https://en.wikipedia.org/wiki/E.164) format.
  - `access_token_invalid`: The auth_token field has expired or is invalid. A non-expired valid token is needed to create a delivery.
  - `access_token_permissions_denied`: The auth_token hasn’t expired but it doesn’t have permissions to create deliveries.
 */

/**
 Failure codes:
  - `box_not_available`: If in the location there are no free boxes of the proper size.
  - `user_blocked`: If the addressee is blocked.
  - `user_autocreation_forbidden`: The user is not registered in Citibox and the carrier doesn’t allow deliveries to non registered users.
  - `max_reopens_exceed`: The maximum number of opening boxes tries have been exceeded.
 */

/**
 Cancel codes:
  - `not_started`: The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.
  - `cant_open_boxes`: The courier couldn’t open any of the boxes offered.
  - `parcel_mistaken`: The courier starts the delivery and the data inserted belongs to another package (a wrong package).
  - `package_in_box`: The courier finds another package in the box where we ask him to deposit it.
  - `need_hand_delivery`: The courier sees the need to deliver the package by hand. For example, he may cross with the addressee at the Citibox location.
  - `other`: The other specified “other” in the cancellation reason form.
 */
