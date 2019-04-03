//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bushra on 02/11/2018.
//  Copyright © 2018 Bushra Alkhushiban. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{

    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecordingButton.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("viewWillAppear")
    }

    @IBAction func RecordAudio(_ sender: Any) {
        print ("Record Button was Pressed")
        StopRecordingButton.isEnabled = true
        RecordingButton.isEnabled = false
        RecordingLabel.text = "Recording in Progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    @IBAction func StopRecording(_ sender: Any) {
        RecordingButton.isEnabled = true
        StopRecordingButton.isEnabled = false
        RecordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print ("recording was not successful :(")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    
}

