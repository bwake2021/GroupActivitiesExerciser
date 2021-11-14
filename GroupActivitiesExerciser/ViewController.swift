// ViewController.swift
//
// Created by Bob Wakefield on 10/2/21.
// for GroupActivitiesExerciser
//
// Using Swift 5.0
// Running on macOS 11.6
//
// 
//

import UIKit

class ViewController: UIViewController {

    private var faceTimeMonitor: FaceTimeMonitor?
    private var groupActivityHandler: GroupActivityHandler<ExerciserActivity, ExerciserMessage>?

    @IBOutlet var callStatus: UILabel?
    @IBOutlet var connectionStatus: UILabel?
    @IBOutlet var connectionCount: UILabel?
    @IBOutlet var messageStatus: UILabel?
    @IBOutlet var errorStatus: UILabel?

    @IBOutlet var beginWaitingButton: UIButton?
    @IBOutlet var disconnectSessionButton: UIButton?
    @IBOutlet var activateButton: UIButton?

    @IBAction func touchUpWaitForSession(_ sender: UIButton?) {

        self.messageStatus?.text = nil
        self.errorStatus?.text = nil

        self.groupActivityHandler = GroupActivityHandler(activity: ExerciserActivity(), delegate: self)
        groupActivityHandler?.beginWaitingForSessions()

        self.updateStatus()
    }

    @IBAction func disconnectSession(_ sender: UIButton?) {

        groupActivityHandler?.reset()
    }

    @IBAction func touchUpActivate(_ sender: UIButton?) {

        groupActivityHandler?.activate()
    }

    @IBAction func touchUpJoinSession(_ sender: UIButton?) {

        groupActivityHandler?.joinSession()

        updateStatus()
    }

    @IBAction func touchUpMessageRequestServices(_ sender: UIButton?) {

        groupActivityHandler?.send(message: ExerciserMessage(service: .requestServices))

        updateStatus()
    }

    @IBAction func touchUpMessageRomoActivity(_ sender: UIButton?) {

        groupActivityHandler?.send(message: ExerciserMessage(service: .romoCommand(.requestStatus)))

        updateStatus()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.'
        self.faceTimeMonitor = FaceTimeMonitor(delegate: self)
    }

    private func updateStatus() {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.connectionStatus?.text = "Session: \(self.groupActivityHandler?.sessionStatus ?? "no session")"
            self.connectionCount?.text = "\(self.groupActivityHandler?.participantCount ?? 0)"
        }
    }
}

extension ViewController: FaceTimeMonitorDelegate, GroupActivityHandlerDelegate {

    func canConnect(_ canConnect: Bool) {

        DispatchQueue.main.async {

            self.callStatus?.text = canConnect ? "in progress" : "not in progress"
        }
    }

    func didConnect() {

        updateStatus()
    }

    func didDisconnect(reason: Error) {

        DispatchQueue.main.async {

            self.connectionStatus?.text = "Session Disconnect: \(reason.localizedDescription)"
        }
    }

    func participantsChanged(count: Int) {

        DispatchQueue.main.async {

            self.connectionCount?.text = "\(count)"
        }
    }

    func session(status: String) {

        DispatchQueue.main.async {

            self.connectionStatus?.text = "Session: \(status)"
        }
    }

    func update<M>(message: M) where M : GroupActivityMessage {

        DispatchQueue.main.async {

            self.messageStatus?.text = message.description
        }
    }

    func report(error: Error) {

        DispatchQueue.main.async {

            self.errorStatus?.text = error.localizedDescription
        }
    }
}
