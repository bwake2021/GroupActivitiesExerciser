// FaceTimeMonitor.swift
//
// Created by Bob Wakefield on 10/23/21.
// for StateMachine
//
// Using Swift 5.0
// Running on macOS 11.6
//
// 
//

import Foundation
import Combine
import GroupActivities

protocol FaceTimeMonitorDelegate: AnyObject {

    func canConnect(_ canConnect: Bool)
}

class FaceTimeMonitor: NSObject {

    private var faceTimeStateObserver = GroupStateObserver()
    private var faceTimeStateTask: AnyCancellable?

    var canConnect: Bool = false
    var delegate: FaceTimeMonitorDelegate?

    deinit {

        faceTimeStateTask?.cancel()
    }

    init(delegate: FaceTimeMonitorDelegate) {

        self.delegate = delegate

        super.init()

        faceTimeStateTask =
            faceTimeStateObserver.$isEligibleForGroupSession.sink { [weak self] isElegibleForGroupSession in

                self?.canConnect = isElegibleForGroupSession

                self?.delegate?.canConnect(isElegibleForGroupSession)
            }
    }
}

