//
//  ViewModelable.swift
//  Tippy
//
//  Created by James Pamplona on 9/21/15.
//  Copyright © 2015 James Pamplona. All rights reserved.
//

import Foundation

/**
An object conforming to `ViewModelable` (usually an instance of `UIView`)
will have a `viewModel` property, which is used by the object to display info to the user
*/
protocol ViewModelable {
    /// The view model which will be used to display information.
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
}