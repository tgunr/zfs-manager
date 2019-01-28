//
//  Connection.swift
//  ZFSManager
//
//  Created by Dave Carlton on 1/23/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation

enum ConnectionType {
    case ssh, sftp
}

class Connection {
    var host = ""
    var user = ""
    var password = ""
    var type:ConnectionType?
}

class SSHConnection: Connection {
    var private_key = ""
    var public_key = ""
    var useConfigurationFile: Bool  = true
}

