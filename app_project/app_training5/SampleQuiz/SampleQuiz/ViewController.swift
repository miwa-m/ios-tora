//
//  ViewController.swift
//  SampleQuiz
//
//  Created by systena on 2018/06/11.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapVibration(_ sender: Any) {
        // バイブレーションを発生させる
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate){
            
        }
    }
    @IBAction func tapCustomSound(_ sender: Any) {
        let soundURL = Bundle.main.url(forResource: "status03", withExtension: "mp3")
        // サウンドIDを登録するための変数を用意
        var soundId: SystemSoundID = 0
        // サウンドファイルを登録してサウンドIDを取得
        AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundId)
        AudioServicesPlaySystemSoundWithCompletion(soundId){
            
        }
    }
    @IBAction func tapSystemSound(_ sender: Any) {
        // システムサウンド1000番を鳴らしつつバイブレーションを振動させる
        // マナーモードの場合はバイブレーションのみとなる
        AudioServicesPlaySystemSoundWithCompletion(1000){
            // ここにはサウンドが鳴り終わった後に呼ばれる処理を記述する
            
        }
    }
    
}

