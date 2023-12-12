# ``Courier SDK``

An iOS SDK to be able to perform deliveries through Citibox.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "citiLogo", 
        alt: "The Citibox logo.")
    @PageColor(purple)
}

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

This framework is developed in `SwiftUI`. The provided functionality comes along with a `View`.
Then, you only need to open `CourierView()` in a new screen.
You are required to provide certain input parameters and you will be able to receive some callback results. 

### Entry params

| Param            | Type    | Requirement | Description                                                                         |  
|------------------|---------|-------------|-------------------------------------------------------------------------------------|  
| `accessToken`    | String  | Mandatory | Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.                                              |  
| `tracking`       | String  | Mandatory | Scanned barcode or QR code of the package to be delivered.                                                                       |  
| `recipientHash`  | String [Format SHA-256](https://es.wikipedia.org/wiki/SHA-2) | | Recipient mobile phone number hashed by SHA-256 algorithm  |  
| `recipientPhone` | String [Format E.164] (https://en.wikipedia.org/wiki/E.164)| | Recipient mobile phone number.                                                               |  
| `dimensions`     | String? | Optional | Package height , width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75                                        |  

### Results
It's represented by the object `DeliveryResult` as a `sealed class` that morph into the different states.
Those states are success, failure, cancel or error, and each state has it's own descriptors

#### Success
When the delivery went well, the result will give you an instance of `DeliveryResult.Success` with information about the delivery like:

- `boxNumber`: it's the box number where the parcel were delivered
- `citiboxId`: our ID to allow you to link your delivery with our ID
- `deliveryId`: the ID of the delivery

#### Failure
When the delivery couldn't be executed for some reason related to the Box or the user, you'll receive an instance of `DeliveryResult.Failure` with the field `type` telling you what went wrong.

#### Failure codes
|Type|Description|
|--|--|
|`parcel_not_available`|  |
|`max_reopens_exceed`|  |
|`empty_box`|  |
|`box_not_available`|  |
|`user_blocked`|  |
|`user_autocreation_forbidden`|  |
|`any_box_empty`|  |

#### Cancel
When the delivery couldn't be done because the Courier canceled the delivery for external reasons or reasons related to the box, you'll receive an instance of `DeliveryResult.Cancel` with the field `type` with the code.

#### Cancel codes
| Type                 | Description                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------|
| `not_started`        | The courier didn’t get to scan or input the QR code of the box to start the transaction. Navigation back to the carrier app.    |
| `cant_open_boxes`    | The courier couldn’t open any of the boxes offered.                                                                             |
| `parcel_mistaken`    | The courier starts the delivery and the data inserted belongs to another package (a wrong package).                             |
| `package_in_box`     | The courier finds another package in the box where we ask him to deposit it.                                                    |
| `need_hand_delivery` | The courier sees the need to deliver the package by hand. For example, he may cross with the addressee at the Citibox location. |
| `other`              | The other specified “other” in the cancellation reason form.                                                                    |

#### Error
When there is an error in the data preventing the delivery, you'll receive an instance of `DeliveryResult.Error` with the field `errorCode` with the code that helps you to identify what is wrong in the data.

#### Error codes
| Error code                        | Description                                                                                                            |
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

## Examples

### SwiftUI

```swift
import SwiftUI
import Courier

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Launch Courier App") {
                    CourierView(accessToken: "70K3n", tracking: "7R4CK1N6", recipientPhone: "+34666000111")
                }
            }
            .padding()
        }
    }
}

```

### UIKit

```swift
import SwiftUI
import Courier

Class MyViewController: UIViewController {
    let courierVC = UIHostingController(rootView: CourierView(accessToken: "70K3n", tracking: "7R4CK1N6", recipientPhone: "+34666000111"))

    ...

    func openCourier() {
        self.navigationController?.pushViewController(courierVC, animated: true)
    }
    
    ...
}

```
