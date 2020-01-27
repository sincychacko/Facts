# iOS Project - Facts

## Build Requirements
+ Xcode 10.0 or later
+ iOS 11.0 SDK or later

## Runtime Requirements
+ iOS 11.0 SDK or later

## About iOS Project - Facts
Facts is a simple app that fetches data from a url and displays its contents in a table view with cells having a dynamic size. Table view has adaptive layout (Size classes) and works on both iPad and iPhones.

The images in the table view are lazily loaded and also cached for lesser download requests.

There is also a provision to reload the data for reflected changes in remote data.

Progress views are added using a 3rd party library called SVProgressHUD and the dependency is managed by Cocoapods.

## Application Architecture
This app is grouped into Model, View, and  view model Xcode groups.


## Testing
Basic Unit and UI test cases have also been added



