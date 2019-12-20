//
//  SoundPlayer.swift
//  Odin-UC
//
//  Created by Apple on 06/01/2017.
//  Copyright © 2017 yealing. All rights reserved.
//

import UIKit

class SoundPlayer: NSObject {

    static let getInstance: SoundPlayer = SoundPlayer()
    var volumnValue: Int?

    lazy var ringSoundPath: String = {
        let string = Bundle.main.path(forResource: "ring", ofType: "wav")
        return string!
    }()

    lazy var waitSoundPath: String = {
        let string = Bundle.main.path(forResource: "income", ofType: "wav")
        return string!
    }()

}

extension SoundPlayer {
    public func playRing() {
        YLLogicAPI.playFile(ringSoundPath)
    }

    public func playIncome() {
        YLLogicAPI.playFile(waitSoundPath)
    }

    public func cancelRing() {
        YLLogicAPI.stopPlayFile()
    }

    public func speakerMute() {
//       volumnValue = Int(UCLogicInterface.getVolumn())
        YLLogicAPI.setVolumn(1)
    }

    public func speakerUmute() {
        YLLogicAPI.setVolumn(Int32(512))
    }
}
