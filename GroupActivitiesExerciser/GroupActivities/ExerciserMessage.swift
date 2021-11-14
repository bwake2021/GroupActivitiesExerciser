// ExerciserMessage.swift
//
// Created by Bob Wakefield on 7/17/21.
// for GroupActivitiesExerciser
//
// Using Swift 5.0
// Running on macOS 11.4
//
// Copyright © 2021 Cockleburr Software. All rights reserved.
//

import Foundation

struct ExerciserMessage: GroupActivityMessage {

    static let dateFormatter = ISO8601DateFormatter()

    private(set) var id: UUID
    private(set) var timestamp: Date

    private(set) var service: ExerciserService

    init(id: UUID = UUID(), timestamp: Date = Date(), service: ExerciserService) {

        self.id = id
        self.timestamp = timestamp

        self.service = service
    }

    var description: String {

        return "\(Self.dateFormatter.string(from: timestamp)) \(id.uuidString) \(service.description)"
    }
}
