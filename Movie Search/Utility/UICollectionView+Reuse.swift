//
//  UICollectionView+Reuse.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
}

extension UICollectionViewCell: ReusableCell {}

extension UICollectionView {
    func register<C: ReusableCell>(cell: C.Type) {
        self.register(C.nib, forCellWithReuseIdentifier: C.reuseIdentifier)
    }
    
    func dequeue<C: ReusableCell>(cell: C.Type, for indexPath: IndexPath) -> C {
        self.dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier, for: indexPath) as! C
    }
}
