//
//  GroupActivityHandler.swift
//  Exerciser
//
//  Created by Bob Wakefield on 6/12/21.
//

import Foundation
import Combine
import GroupActivities

protocol GroupActivityMessage: Codable {

    var id: UUID { get }
    var timestamp: Date { get }
    var description: String { get }
}

protocol GroupActivityHandlerDelegate: AnyObject {

    func didConnect()
    func didDisconnect(reason: Error)
    func participantsChanged(count: Int)
    func session(status: String)
    func update<M: GroupActivityMessage>(message: M)
    func report(error: Error)
}

/// Contains the setup and session logic for GroupActivities.
class GroupActivityHandler<GA: GroupActivity, GM: GroupActivityMessage>: NSObject {

    enum GroupActivityHandlerError: Error {

        case noSession
        case attemptToJoinNilSession
        case attemptToUseNilMessenger
        case messageSendFail(Error)
        case messagePastSellByDate(GM)

        var localizedDescription: String {

            switch self {
            case .noSession:
                return "No Group Session."
            case .attemptToJoinNilSession:
                return "Attempted to join a nonexistent session."
            case .attemptToUseNilMessenger:
                return "Attempted to send a message using a nonexistent messenger."
            case .messageSendFail(let error):
                return "Activity message send failure: \(error.localizedDescription)"
            case .messagePastSellByDate(let message):
                return "Message past its sell-by date: \(message.description)"
            }
        }
    }

    private weak var delegate: GroupActivityHandlerDelegate?

    var isConnected: Bool {

        return .joined == (groupSession?.state ?? .invalidated(reason: GroupActivityHandlerError.noSession))
    }

    var participantCount: Int {

        return groupSession?.activeParticipants.count ?? 0
    }

    var sessionStatus: String? {
        return groupSession?.state.description
    }

    private var sessionListenerTask: Task<(), Never>?

    private var tasks = Set<Task<(), Never>>()

    private var messenger: GroupSessionMessenger?

    private var groupSession: GroupSession<GA>?

    private var latestTimestamp = Date.distantPast

    private var subscriptions = Set<AnyCancellable>()

    private var activity: GA?

    /// Create the activity handler
    init(activity: GA, delegate: GroupActivityHandlerDelegate) {

        super.init()

        self.activity = activity
        self.delegate = delegate
    }

    deinit {

        sessionListenerTask?.cancel()
    }

    func activate() {

        guard let activity = self.activity else { return }

        Task {
            do {
                _ = try await activity.activate()
            }
            catch {
                delegate?.report(error: error)
            }
        }

        return
    }

    func reset() {

        latestTimestamp = Date.distantPast

        // tear down existing group session
        groupSession?.leave()
//        groupSession = nil

        teardown()
    }

    private func teardown() {

        messenger = nil
        tasks.forEach { $0.cancel() }
        tasks = []
        subscriptions = []
    }

    /// Wait for sessions to connect
    func beginWaitingForSessions() {

        sessionListenerTask =
            Task {

                for await session in GA.sessions() {

                    configure(session)
                }
            }
    }

    func joinSession() {

        guard
            let groupSession = self.groupSession
        else {
            report(error: .attemptToJoinNilSession)
            return
        }

        groupSession.join()

        groupSession.$activeParticipants
            .sink { activeParticipants in

//                let newParticipants = activeParticipants.subtracting(groupSession.activeParticipants)

                self.delegate?.participantsChanged(count: activeParticipants.count)
            }
            .store(in: &subscriptions)

        self.messenger = GroupSessionMessenger(session: groupSession)

        configure(messenger)
    }

    private func report(error: GroupActivityHandlerError) {

        delegate?.report(error: error)
    }

    private func configure(_ groupSession: GroupSession<GA>) {

        self.groupSession = groupSession

        subscriptions.removeAll()

        groupSession.$state.sink { [weak self] state in

            guard let self = self else { return }

            switch state {
            case .waiting:
                break
            case .joined:
                self.delegate?.didConnect()
            case .invalidated(reason: let reason):
                self.teardown()
                self.delegate?.didDisconnect(reason: reason)
            @unknown default:
                break
            }

            self.delegate?.session(status: state.description)
        }
        .store(in: &subscriptions)
    }

    /// Add a task to wait for messages for other devices in the session
    /// and pass them on to the delegate.
    private func configure(_ messenger: GroupSessionMessenger?) {

        guard nil != messenger else { return }

        let task = Task.detached { [weak self] in

            guard let messenger = self?.messenger else { return }

            for await (message, _) in messenger.messages(of: GM.self) {

                self?.handle(message)
            }
        }

        tasks.insert(task)
    }

    /// Forward a message from another device in the session to the delegate. Do
    /// not forward messages which have passed their sell-by date.
    /// - Parameter message: Message received from the other device. Must conform
    /// to the GroupActivityMessage protocol, with a unique ID and timestamp.
    private func handle(_ message: GM) {

        if latestTimestamp < message.timestamp {

            latestTimestamp = message.timestamp
            delegate?.update(message: message)

        } else {

            report(error: .messagePastSellByDate(message))
        }
    }

    /// Pass a message to the other devices in this session. Report any error to the delegate.
    /// - Parameter message: The structure to be passed.
    func send(message: GM) {

        guard nil != messenger else {

            print("Attempt to send a message through a nil messenger!")
            delegate?.report(error: GroupActivityHandlerError.attemptToUseNilMessenger)
            return
        }

        Task {

            do {

                try await messenger?.send(message)

            } catch {

                delegate?.report(error: GroupActivityHandlerError.messageSendFail(error))
            }
        }
    }
}

extension GroupSession.State {

    var description: String {
        switch self {

        case .waiting:
            return "waiting"
        case .joined:
            return "joined"
        case .invalidated(reason: let reason):
            return "invalidated: \(reason.localizedDescription)"
        @unknown default:
            return "Unknown GroupSession state!"
        }
    }
}
