//
//  CustomTableViewCell.swift
//  FotoApi
//
//  Created by Serhii Palamarchuk on 30.05.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.size.height -= 8
            super.frame = frame
        }
    }
}
