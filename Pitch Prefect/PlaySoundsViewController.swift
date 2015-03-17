//
//  PlaySoundsViewController.swift
//  Pitch Prefect
//
//  Created by Chris Archibald on 3/13/15.
//  Copyright (c) 2015 Chris Archibald. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayerForEcho:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayerForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayerForEcho.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableSpeed(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableSpeed(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /**
    Stops the AudioPlayer and AudioEngine
    Reset the Audio Engine
    */
    @IBAction func stopAudio(sender: UIButton) {
        stopAndReset()
    }
    
    /*
    Plays a files back with Echo
    */
    @IBAction func playEcho(sender: UIButton) {
        //Since playAudioWithVariableSpeed(1) Does what we want for the first 
        //audio playback no need to write any extra code for this
        playAudioWithVariableSpeed(1)
        
        let delay:NSTimeInterval = 0.3
        var playtime:NSTimeInterval!
        playtime = audioPlayerForEcho.deviceCurrentTime + delay
        audioPlayerForEcho.stop()
        audioPlayerForEcho.currentTime = 0
        audioPlayerForEcho.volume = 0.4
        audioPlayerForEcho.playAtTime(playtime)
        
    }
    
    /**
    Plays the audio file back with Reverb
    */
    @IBAction func playReverb(sender: UIButton) {
        stopAndReset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbAudio = AVAudioUnitReverb()
        //Set the type and how much Reverb we want in the audio file
        reverbAudio.loadFactoryPreset(AVAudioUnitReverbPreset.LargeChamber)
        reverbAudio.wetDryMix = 70
        
        audioEngine.attachNode(reverbAudio)
        audioEngine.connect(audioPlayerNode, to: reverbAudio, format: nil)
        audioEngine.connect(reverbAudio, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    /** 
    This functions plays an audio files back at a certain speed
    :param: speed The speed we want to play the audio at
    */
    func playAudioWithVariableSpeed(speed: Float){
        stopAndReset()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    /** Plays the audio file at a specific pitch
    :param: the pitch you want to play the audio file at
    */
    func playAudioWithVariablePitch(pitch: Float){
        stopAndReset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    /**
    This Stops and Reset the audioPlayer and Audio Endgine, we need to do this
    Before every button push
    */
    func stopAndReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
