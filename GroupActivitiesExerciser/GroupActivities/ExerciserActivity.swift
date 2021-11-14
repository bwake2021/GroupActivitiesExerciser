//
//  ExerciserActivity.swift
//  GroupActivitiesExerciser
//
//  Created by Bob Wakefield on 6/10/21.
//

import GroupActivities
import UIKit

struct ExerciserActivity: GroupActivity {

    // specify the activity type to the system
    static let activityIdentifier = "net.cockleburr.GroupActivityExerciser"

    // provide information about the activity
    var metadata: GroupActivityMetadata {

        var metadata = GroupActivityMetadata()

        metadata.type = .generic
        metadata.title = NSLocalizedString("GroupActivityExerciser by Bob Wakefield", comment: "")
        metadata.subtitle = NSLocalizedString("Exercises Group Activities.", comment: "")

        metadata.previewImage = UIImage(named: "SplashIcon")?.cgImage

        return metadata
    }
}

extension ExerciserActivity: Equatable {}
