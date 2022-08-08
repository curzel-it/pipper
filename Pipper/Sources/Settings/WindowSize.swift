//
//  WindowSize.swift
//  Pipper
//
//  Created by Federico Curzel on 08/08/22.
//

import Foundation

class Size {
    
    static let i9b16w320 = CGSize(width: 320, height: 569)
    static let i9b16w370 = CGSize(width: 370, height: 658)
    static let i9b16w420 = CGSize(width: 420, height: 746)
    
    static let i9b24w320 = CGSize(width: 320, height: 853)
    static let i9b24w370 = CGSize(width: 370, height: 987)
    static let i9b24w420 = CGSize(width: 420, height: 1120)
    
    static let i16b11w430 = CGSize(width: 430, height: 296)
    static let i16b11w490 = CGSize(width: 490, height: 337)
    static let i16b11w550 = CGSize(width: 550, height: 378)
    
    static let i1b1w240 = CGSize(width: 240, height: 240)
    static let i1b1w360 = CGSize(width: 360, height: 360)
    static let i1b1w440 = CGSize(width: 440, height: 440)
    static let i1b1w520 = CGSize(width: 520, height: 520)
}

extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
