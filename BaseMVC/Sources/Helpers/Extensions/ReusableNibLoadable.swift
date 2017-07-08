//
//  ReusableNibLoadable.swift
//  BaseMVC
//
//  Created by Pham Quang Huy on 7/5/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

// NibLoadable

public protocol NibLoadable: class {
    static var nib: UINib { get }
}

public extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

// Reuseable

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public typealias NibReusable = Reusable & NibLoadable

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

