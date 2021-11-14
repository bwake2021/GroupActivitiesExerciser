//
//  RomoCommand.swift
//  Exerciser
//
//  Created by Bob Wakefield on 6/18/21.
//  Copyright © 2021 CockleBurr. All rights reserved.
//

import Foundation

indirect enum RomoCommand: Equatable {

    case connected
    case disconnected

    case driveForward(Float)
    case driveBackward(Float)
    case driveWithPower(Float, Float)
    case stopDriving
    case tiltForward(Float)
    case tiltBackward(Float)
    case stopTilting
    case turnLeft45
    case turnLeft90
    case turnLeftRear45
    case turnRight45
    case turnRight90
    case turnRightRear45

    case requestStatus
    case status(RomoStatus)

    case acknowledgment(RomoCommand)
}

extension RomoCommand {

    init(from key: String) {

        guard let codableKey = CodableKeys(rawValue: key) else {

            preconditionFailure("Unable to init a RomoCommand.CodableKey from string: \(key)")
        }

        self.init(from: codableKey)
    }

    init(from key: CodableKeys) {

        switch key {

        case .connected:
            self = .connected
        case .disconnected:
            self = .disconnected
        case .driveForward:
            self = .driveForward(0.5)
        case .driveBackward:
            self = .driveBackward(0.5)
        case .driveWithPower:
            self = .driveWithPower(0.25, 0.25)
        case .stopDriving:
            self = .stopDriving
        case .tiltForward:
            self = .tiltForward(10)
        case .tiltBackward:
            self = .tiltBackward(10)
        case .stopTilting:
            self = .stopTilting
        case .turnLeft45:
            self = .turnLeft45
        case .turnLeft90:
            self = .turnLeft90
        case .turnLeftRear45:
            self = .turnLeftRear45
        case .turnRight45:
            self = .turnRight45
        case .turnRight90:
            self = .turnRight90
        case .turnRightRear45:
            self = .turnRightRear45
        case .requestStatus:
            self = .requestStatus
        case .status:
            self = .status(.none)
        case .acknowledgment:
            self = .acknowledgment(.status(.none))
        }
    }
}

extension RomoCommand: Codable {

    enum CodingError: Error { case decoding(String) }
    enum CodableKeys: String, CodingKey {

        case connected
        case disconnected

        case driveForward
        case driveBackward
        case driveWithPower
        case stopDriving
        case tiltForward
        case tiltBackward
        case stopTilting
        case turnLeft45
        case turnLeft90
        case turnLeftRear45
        case turnRight45
        case turnRight90
        case turnRightRear45

        case requestStatus
        case status

        case acknowledgment
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodableKeys.self)

        if let isConnected = try? values.decode(Bool.self, forKey: .connected) {

            assert(isConnected)
            self = .connected
        }

        if let isConnected = try? values.decode(Bool.self, forKey: .disconnected) {

            assert(!isConnected)
            self = .disconnected
        }

        if let speed = try? values.decode(Float.self, forKey: .driveForward) {

            self = .driveForward(speed)
            return
        }

        if let speed = try? values.decode(Float.self, forKey: .driveBackward) {

            self = .driveBackward(speed)
            return
        }

        if
            let powers = try? values.decode([Float].self, forKey: .driveWithPower),
            2 == powers.count {

            self = .driveWithPower(powers[0], powers[1])
        }

        if let speed = try? values.decode(Float.self, forKey: .stopDriving) {

            assert(0 == speed)
            self = .stopDriving
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .tiltForward) {

            self = .tiltForward(angle)
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .tiltBackward) {

            self = .tiltBackward(angle)
            return
        }

        if let speed = try? values.decode(Float.self, forKey: .stopTilting) {

            assert(0 == speed)
            self = .stopTilting
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnLeft45) {

            assert(-45 == angle)
            self = .turnLeft45
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnLeft90) {

            assert(-90 == angle)
            self = .turnLeft90
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnLeftRear45) {

            assert(-135 == angle)
            self = .turnLeftRear45
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnRight45) {

            assert(45 == angle)
            self = .turnRight45
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnRight90) {

            assert(90 == angle)
            self = .turnRight90
            return
        }

        if let angle = try? values.decode(Float.self, forKey: .turnRightRear45) {

            assert(135 == angle)
            self = .turnRightRear45
            return
        }

        if let value = try? values.decode(Float.self, forKey: .requestStatus) {

            assert(0 == value)
            self = .requestStatus
            return
        }

        if let romoStatus = try? values.decode(RomoStatus.self, forKey: .status) {

            self = .status(romoStatus)
            return
        }

        if let value = try? values.decode(String.self, forKey: .acknowledgment) {

            self = .acknowledgment(RomoCommand(from: value))
        }

        throw CodingError.decoding("Decoding Failed. \(dump(values))")
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodableKeys.self)

        switch self {

        case .connected:
            try container.encode(true, forKey: .connected)
        case .disconnected:
            try container.encode(false, forKey: .disconnected)
        case let .driveForward(speed):
            try container.encode(speed, forKey: .driveForward)
        case let .driveBackward(speed):
            try container.encode(speed, forKey: .driveBackward)
        case let .driveWithPower(leftPower, rightPower):
            try container.encode([leftPower, rightPower], forKey: .driveWithPower)
        case .stopDriving:
            try container.encode(0, forKey: .stopDriving)
        case .tiltForward:
            try container.encode(10.0, forKey: .tiltForward)
        case .tiltBackward:
            try container.encode(10.0, forKey: .tiltBackward)
        case .stopTilting:
            try container.encode(0, forKey: .stopTilting)
        case .turnLeft45:
            try container.encode(-45.0, forKey: .turnLeft45)
        case .turnLeft90:
            try container.encode(-90.0, forKey: .turnLeft90)
        case .turnLeftRear45:
            try container.encode(-135.0, forKey: .turnLeftRear45)
        case .turnRight45:
            try container.encode(45.0, forKey: .turnRight45)
        case .turnRight90:
            try container.encode(90.0, forKey: .turnRight90)
        case .turnRightRear45:
            try container.encode(135.0, forKey: .turnRightRear45)
        case .requestStatus:
            try container.encode(0.0, forKey: .requestStatus)
        case .status(let romoStatus):
            try container.encode(romoStatus, forKey: .status)
        case .acknowledgment(let command):
            if case .acknowledgment(_) = command {
                assert(false, "Attempt to encode an acknowledgment with an associated acknowlegement")
            }
            try container.encode(command, forKey: .acknowledgment)
        }
    }
}

extension RomoCommand {

    var description: String {

        switch self {

        case .connected:
            return "Romo is Connected!"
        case .disconnected:
            return "Romo is Disconnected"
        case .driveForward(let speed):
            return "Romo Drive Forward \(speed) m/s"
        case .driveBackward(let speed):
            return "Romo Drive Backward \(speed) m/s"
        case .driveWithPower(let leftPower, let rightPower):
            return "Romo Drive Power left:\(leftPower) right:\(rightPower)"
        case .stopDriving:
            return "Romo Stop Driving"
        case .tiltForward(_):
            return "Romo Tilt Forward"
        case .tiltBackward(_):
            return "Romo Tilt Backward"
        case .stopTilting:
            return "Romo Stop Tilting"
        case .turnLeft45:
            return "Romo Turn Left 45°"
        case .turnLeft90:
            return "Romo Turn Left 90°"
        case .turnLeftRear45:
            return "Romo Turn Left Rear 45°"
        case .turnRight45:
            return "Romo Turn Right 45°"
        case .turnRight90:
            return "Romo Turn Right 90°"
        case .turnRightRear45:
            return "Romo Turn Right Rear 45°"
        case .requestStatus:
            return "Romo Get Status"
        case .status(_):
            return "Romo Status"
        case .acknowledgment(let command):
            return "Romo Acknowledgment\(command.description)"
        }
    }

    var string: String {

        switch self {

        case .connected:
            return CodableKeys.connected.rawValue
        case .disconnected:
            return CodableKeys.disconnected.rawValue
        case .driveForward(_):
            return CodableKeys.driveForward.rawValue
        case .driveBackward(_):
            return CodableKeys.driveBackward.rawValue
        case .driveWithPower(_,_):
            return CodableKeys.driveWithPower.rawValue
        case .stopDriving:
            return CodableKeys.stopDriving.rawValue
        case .tiltForward(_):
            return CodableKeys.tiltForward.rawValue
        case .tiltBackward(_):
            return CodableKeys.tiltBackward.rawValue
        case .stopTilting:
            return CodableKeys.stopTilting.rawValue
        case .turnLeft45:
            return CodableKeys.turnLeft45.rawValue
        case .turnLeft90:
            return CodableKeys.turnLeft90.rawValue
        case .turnLeftRear45:
            return CodableKeys.turnLeftRear45.rawValue
        case .turnRight45:
            return CodableKeys.turnRight45.rawValue
        case .turnRight90:
            return CodableKeys.turnRight90.rawValue
        case .turnRightRear45:
            return CodableKeys.turnRightRear45.rawValue
        case .requestStatus:
            return CodableKeys.requestStatus.rawValue
        case .status(_):
            return CodableKeys.status.rawValue
        case .acknowledgment(_):
            return CodableKeys.acknowledgment.rawValue
        }
    }
}
