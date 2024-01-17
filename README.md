# Courier SDK

An iOS SDK to be able to perform deliveries through Citibox.

## Overview

Citibox is a software platform with the vision of solving the issue receiving parcel and return packages at home.

Our first iteration is to deploy an open network of smart parcel boxes installed inside residential buildings where customers wants to receive their parcels.

![Citibox](citibox.png)

Thank to the information that Citibox has, the carrier can deliver parcels with an astonishing experience with our custom user flow that has a 85/100 NPS score.

## Content

Library and example of how to integrate with Cibitox services for deliveries

## Installation

Add this Swift Package to your application in Xcode: `git@github.com:citibox/ios-sdk-couriers.git`

## Usage

This framework is developed in `SwiftUI`. The provided functionality comes along with a function extending the `View` protocol.
Then, you need to add the `.courier()` modifier to your main view providing all required parameters for [delivery](#delivery-entry-params) or [retrieval](#retrieval-entry-parameters) and it will open a `CourierView` in full screen. Once process is done you will be able to receive some callback results for [delivery](#delivery-results) or [retrieval](#retrieval-results). 

### Delivery entry params

| Param            | Type    | Requirement | Description                                                                         |  
|------------------|---------|-------------|-------------------------------------------------------------------------------------|  
| `accessToken`    | String  | Mandatory | Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.                                              |  
| `tracking`       | String  | Mandatory | Scanned barcode or QR code of the package to be delivered.                                                     |   
| `recipientPhone` | String [Format E.164] (https://en.wikipedia.org/wiki/E.164) | Mandatory | Recipient mobile phone number.                                         |  
| `dimensions`     | String? | Optional | Package height , width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75                                        |  
| `bookingId`      | String? | Optional | Booking identificator. Currently not doing anything. Prepared for further release. |
| `isSandbox`      | Bool | Optional | Tells if using sandbox environment. False by default. |
| `debug`          | Bool | Optional | Shows a different view in order to be able to debug the delivery. Is intended to be used when we face some issue that cannot understand or we want to verify params or UI. False by default. |

### Delivery results
There are 4 types of results:
- [Success](#delivery-success)
- [Failure](#delivery-failure)
- [Cancel](#delivery-cancel)
- [Error](#delivery-error)

A result is represented by the protocol `DeliveryResult` which specializes in its own type.

#### Delivery success
When the delivery went well, the result will give you an instance of `DeliveryResultSuccess` with information about the delivery like:

- `boxNumber`: it's the box number where the parcel were delivered
- `citiboxId`: our ID to allow you to link your delivery with our ID
- `deliveryId`: the ID of the delivery

#### Delivery failure
When the delivery couldn't be executed for some reason related to the Box or the user, you'll receive an instance of `DeliveryResultFailure` with the field `code` telling you what went wrong.

##### Failure codes
|Code|Description|
|--|--|
|`parcel_not_available`| The package couldn’t be in the required state. |
|`max_reopens_exceed`| The maximum number of opening boxes tries have been exceeded. |
|`empty_box`| There isn’t a packet into box. |
|`box_not_available`| If in the location there are no free boxes of the proper size. |
|`user_blocked`| If the addressee is blocked. |
|`user_autocreation_forbidden`| The user is not registered in Citibox and the carrier doesn’t allow deliveries to non registered users. |
|`any_box_empty`|  |

#### Delivery cancel
When the delivery couldn't be done because the Courier canceled the delivery on purpose, you'll receive an instance of `DeliveryResultCancel` with the field `code` with the code.

##### Cancel codes
| Code                 | Description                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------|
| `not_started`        | The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.    |
| `cant_open_boxes`    | The courier couldn’t open any of the boxes offered.                                                                             |
| `parcel_mistaken`    | The courier starts the delivery and the data inserted belongs to another package (a wrong package).                             |
| `package_in_box`     | The courier finds another package in the box where we ask him to deposit it.                                                    |
| `need_hand_delivery` | The courier sees the need to deliver the package by hand. For example, he may cross with the addressee at the Citibox location. |
| `other`              | The other specified “other” in the cancellation reason form.                                                                    |

#### Delivery error
When there is an error in the data preventing the delivery, you'll receive an instance of `DeliveryResultError` with the field `code` with the code that helps you to identify what is wrong in the data.

##### Error codes
| Code                              | Description                                                                                                            |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `tracking_missing`                | The tracking code must be provided                                                                                     |
| `access_token_missing`            | The access token must be provided                                                                                      |
| `citibox_id_missing`              | The mandatory data citibox_id wasn’t sent.                                                                             |
| `access_token_invalid`            | The access token is not valid, please contact Citibox Team                                                             |
| `access_token_permissions_denied` | The access token belongs to an user with the wrong permissions, please contact Citibox Team                            |
| `recipient_phone_missing`         | The recipient phone must be provided                                                                                   |
| `duplicated_trackings`            | You've tried to make a delivery with a tracking code already used                                                      |
| `recipient_phone_invalid`         | The recipient phone filed doesn't have a valid [E.164] (https://en.wikipedia.org/wiki/E.164) format                                                                                     |
| `wrong_location`                  | The location has a problem, please contact Citibox Team                                                                |
| `arguments_missing`               | Some of the arguments are missing, check them                                                                          |
| `data_not_received`               |                                                                                                                        |
| `launching_problem`               | There were a problem launching the Courier app and the WebView |

### Retrieval entry params

| Param            | Type    | Requirement | Description                                                                         |  
|------------------|---------|-------------|-------------------------------------------------------------------------------------|  
| `accessToken`    | String  | Mandatory | Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.                                              |  
| `citiboxId`       | String  | Mandatory | ID for the Citibox transaction to be collected. The citibox_id value is generated by Citibox during a delivery through Deeplink.                                                     |
| `isSandbox`      | Bool | Optional | Tells if using sandbox environment. False by default. |
| `debug`          | Bool | Optional | Shows a different view in order to be able to debug the delivery. Is intended to be used when we face some issue that cannot understand or we want to verify params or UI. False by default. |

### Retrieval results
There are 4 types of results:
- [Success](#retrieval-success)
- [Failure](#retrieval-failure)
- [Cancel](#retrieval-cancel)
- [Error](#retrieval-error)

A result is represented by the protocol `DeliveryResult` which specializes in its own type.

#### Retrieval success
When the retrieval went well, the result will give you an instance of `RetrievalResultSuccess` with information about the retrieval like:

- `boxNumber`: Box number where the package was deposited in the Citibox location.
- `citiboxId`: ID for this Citibox transaction.

#### Retrieval failure
When the delivery couldn't be executed for some reason related to the Box or the user, you'll receive an instance of `DeliveryResultFailure` with the field `code` telling you what went wrong.

##### Failure codes
|Code|Description|
|--|--|
|`parcel_not_available`| The package couldn’t be in the required state. |
|`max_reopens_exceed`| The tries to open boxes has been exceeded. |
|`empty_box`| There isn’t a packet into box. |

#### Retrieval cancel
When the delivery couldn't be done because the Courier canceled the delivery on purpose, you'll receive an instance of `DeliveryResultCancel` with the field `code` with the code.

##### Cancel codes
| Code                 | Description                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------|
| `not_started`        | The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.    |
| `cant_open_boxes`    | The courier couldn’t open any of the boxes offered.                                                                             |
| `other`              | The other specified “other” in the cancellation reason form.                                                                    |

#### Retrieval error
When there is an error in the data preventing the delivery, you'll receive an instance of `DeliveryResultError` with the field `code` with the code that helps you to identify what is wrong in the data.

##### Error codes
| Code                              | Description                                                                                                            |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `access_token_missing`            | The access token must be provided                                                                                      |
| `citibox_id_missing`              | The mandatory data citibox_id wasn’t sent.                                                                             |
| `access_token_invalid`            | The access token is not valid, please contact Citibox Team                                                             |
| `access_token_permissions_denied` | The access token belongs to an user with the wrong permissions, please contact Citibox Team                            |
| `wrong_location`                  | The location has a problem, please contact Citibox Team                                                                |
| `arguments_missing`               | Some of the arguments are missing, check them                                                                          |
| `data_not_received`               |                                                                                                                        |
| `launching_problem`               | There were a problem launching the Courier app and the WebView |

## Examples

There is a working example [here](/Example/CourierSDKTester)

### SwiftUI

#### Delivery

```swift
import SwiftUI
import Courier

struct ContentView: View {
    @ObservedObject var result: DeliveryResultViewModel = .init()
    @State var showCourierView = false
    
    var deliveryParams = DeliveryParams(
        accessToken: "accessToken",
        tracking: "tracking",
        recipientPhone: "+34600000000"
    )

    var body: some View {
        VStack {
            Button("Deliver 🚀📦") {
                showCourierView = true
            }  
        }
        .padding(16)
        .courier(isPresented: $showCourierView, params: deliveryParams, result: result)
    }
}

```

#### Retrieval

```swift
import SwiftUI
import Courier

struct ContentView: View {
    @ObservedObject var result: RetrievalResultViewModel = .init()
    @State var showCourierView = false
    
    var retrievalParams = RetrievalParams(
        accessToken: "accessToken",
        citiboxId: "citiID"
    )

    var body: some View {
        VStack {
            Button("Retrieve 📦") {
                showCourierView = true
            }  
        }
        .padding(16)
        .courier(isPresented: $showCourierView, params: retrievalParams, result: result)
    }
}

```

## Documentation

[Here](/Documentation) you can find the documentation in [DocC](/Documentation/Courier.doccarchive) format or in [html](/Documentation/html/documentation/courier/index.html).
