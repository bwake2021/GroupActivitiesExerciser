// ExerciserService.swift
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

enum ExerciserService: Equatable, Codable {

    case requestServices
    case romoCommand(RomoCommand)

    var description: String {
        switch self {
        case .requestServices: return "Request Exerciser Services"
        case .romoCommand(let command): return "Romo Command \(command.description)"
        }
    }
}
