//
//  Extensions.swift
//  ZFSManager
//
//  Created by Dave Carlton on 2/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation
extension String {
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

