//
//  RomoStatus.swift
//  Exerciser
//
//  Created by Bob Wakefield on 6/30/21.
//  Copyright © 2021 CockleBurr. All rights reserved.
//

import Foundation

// import Romo

struct RomoStatus: Equatable, Codable {

    static let none = RomoStatus()

    let romoIsConnected: Bool

    let romoIsDriving: Bool
    let romoIsTilting: Bool

    let romoDrivable: Bool
    let romoHeadTiltable: Bool
    let romoIMUEquipped: Bool
    let romoLEDEquipped: Bool

    let batteryLevel: Float

    let batteryIsCharging: Bool

    let romoName: String
    let romoModelNumber: String
    let romoFirmwareVersion: String
    let romoHardwareVersion: String
    let romoBootloaderVersion: String
    let romoSerialNumber: String
    let romoManufacturer: String

    let phoneName: String
    let phoneBatteryLevel: Float
    let phoneIsCharging: Bool

    init(
        romoIsConnected: Bool,

        romoIsDriving: Bool,
        romoIsTilting: Bool,
        romoDrivable: Bool,
        romoHeadTiltable: Bool,
        romoIMUEquipped: Bool,
        romoLEDEquipped: Bool,

        batteryLevel: Float,

        batteryIsCharging: Bool,

        romoName: String,
        romoModelNumber: String,
        romoFirmwareVersion: String,
        romoHardwareVersion: String,
        romoBootloaderVersion: String,
        romoSerialNumber: String,
        romoManufacturer: String,

        phoneName: String,
        phoneBatteryLevel: Float,
        phoneIsCharging: Bool
    ) {

        self.romoIsConnected = romoIsConnected

        self.romoIsDriving = romoIsDriving
        self.romoIsTilting = romoIsTilting

        self.romoDrivable     = romoDrivable
        self.romoHeadTiltable = romoHeadTiltable
        self.romoIMUEquipped  = romoIMUEquipped
        self.romoLEDEquipped  = romoLEDEquipped

        self.batteryLevel = batteryLevel

        self.batteryIsCharging = batteryIsCharging

        self.romoName              = romoName
        self.romoModelNumber       = romoModelNumber
        self.romoFirmwareVersion   = romoFirmwareVersion
        self.romoHardwareVersion   = romoHardwareVersion
        self.romoBootloaderVersion = romoBootloaderVersion
        self.romoSerialNumber      = romoSerialNumber
        self.romoManufacturer      = romoManufacturer

        self.phoneName         = phoneName
        self.phoneBatteryLevel = phoneBatteryLevel
        self.phoneIsCharging   = phoneIsCharging
    }

//    init(from robot: RMCoreRobotRomo3?) {
//
//        guard let robot = robot else {
//
//            self.init()
//            return
//        }
//
//        let phoneName = UIDevice.current.name
//        let phoneBatteryLevel = UIDevice.current.batteryLevel
//        let phoneIsCharging = .charging == UIDevice.current.batteryState || .full == UIDevice.current.batteryState
//
//        self.init(
//                    romoIsConnected: true,
//
//                    romoIsDriving: robot.isDriving,
//                    romoIsTilting: robot.isTilting,
//
//                    romoDrivable    : robot.isDrivable,
//                    romoHeadTiltable: robot.isHeadTiltable,
//                    romoIMUEquipped : robot.isIMUEquipped,
//                    romoLEDEquipped : robot.isLEDEquipped,
//
//                    batteryLevel     : robot.vitals.batteryLevel,
//                    batteryIsCharging: robot.vitals.isCharging,
//
//                    romoName             : robot.identification.name ?? "Unnamed Robot",
//                    romoModelNumber      : robot.identification.modelNumber ?? "Missing Robot Model",
//                    romoFirmwareVersion  : robot.identification.firmwareVersion ?? "Missing Firmware Version",
//                    romoHardwareVersion  : robot.identification.hardwareVersion ?? "Missing Hardware Version",
//                    romoBootloaderVersion: robot.identification.bootloaderVersion ?? "Missing Bootloader Version",
//                    romoSerialNumber     : robot.identification.serialNumber ?? "Missing Serial Number",
//                    romoManufacturer     : robot.identification.manufacturer ?? "Missing Manufacturer",
//
//                    phoneName: phoneName,
//                    phoneBatteryLevel: phoneBatteryLevel,
//                    phoneIsCharging: phoneIsCharging
//                )
//    }

    init() {

        self.init(
                romoIsConnected: false,
                romoIsDriving: false,
                romoIsTilting: false,
                romoDrivable: false,
                romoHeadTiltable: false,
                romoIMUEquipped: false,
                romoLEDEquipped: false,
                batteryLevel: 0,
                batteryIsCharging: false,
                romoName: "",
                romoModelNumber: "",
                romoFirmwareVersion: "",
                romoHardwareVersion: "",
                romoBootloaderVersion: "",
                romoSerialNumber: "",
                romoManufacturer: "",
                phoneName: "",
                phoneBatteryLevel: 0,
                phoneIsCharging: false
            )
    }

    var debugDescription: String {

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(self)

            return String(data: data, encoding: .utf8) ?? "Not encoded as utf8."
        }
        catch {
            return "Error \(error.localizedDescription) encoding status."
        }
    }
}

