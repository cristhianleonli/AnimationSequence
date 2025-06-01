//
//  AnimationEasing.swift
//  AnimationSequence
//
//  Created by Cristhian Leon on 1/6/25.
//

import SwiftUI

// enum that maps the SwiftUI.Animation options
public enum AnimationEasing {
    case `default`
    case easeIn
    case easeOut
    case easeInOut
    case linear
    case custom(animation: Animation)
}
