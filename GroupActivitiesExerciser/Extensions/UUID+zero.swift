// UUID+zero.swift
//
// Created by Bob Wakefield on 9/5/21.
// for Exerciser
//
// Using Swift 5.0
// Running on macOS 11.5
//
// Copyright © 2021 Cockleburr Software. All rights reserved.
//

import Foundation

extension UUID {

    // "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
    static let zero: UUID = {

        guard let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000")
        else {
            preconditionFailure("Unable to create zero UUID")
        }

        return uuid
    }()
}
