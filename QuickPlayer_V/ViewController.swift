//
//  ViewController.swift
//  QuickPlayer_V
//
//  Created by le ha thanh on 2016/07/09.
//  Copyright © 2016年 le ha thanh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var sld_Volume: UISlider!
    @IBOutlet weak var lbl_TimeLeft: UILabel!
    @IBOutlet weak var sld_Duraiton: UISlider!
    @IBOutlet weak var lbl_TimeTotal: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sw_Repeate: UISwitch!
    
    @IBOutlet weak var view_sound: UIView!
    
    var timer = NSTimer()
    var current_Song = 0
    var fileMusic: [String] = ["ChotTinhGiac","TheGioiThu4"]
    var audio = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        music()
        tableview.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .None)
                sld_Duraiton.setThumbImage(UIImage(named: "duration.png"), forState: .Normal)
        //        addThumImgForSlider()
        audio.numberOfLoops = 0
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: "respond:")
        view_sound.addGestureRecognizer(swipeRight)
        sld_Volume.hidden = true
        
        
        view.backgroundColor = UIColor.whiteColor()
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGrayColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.blackColor()
        
    }
    
    func respond(gesture: UIPanGestureRecognizer) {
        let change = Float(gesture.locationInView(view).x/15)
        sld_Volume.hidden = false
        sld_Volume.value = change
        audio.volume = sld_Volume.value
        if gesture.state == .Ended {
        sld_Volume.hidden = true
        }
    }
    
    func updateTimeLeft(){
        self.lbl_TimeLeft.text = String(format: "%2.2f", audio.currentTime/60)
        self.sld_Duraiton.value = Float(audio.currentTime/audio.duration)
    }
    
    func addThumImgForSlider(){
        sld_Volume.hidden = true
        sld_Volume.setThumbImage(UIImage(named: "thumb.png"), forState: .Normal)
        sld_Volume.setThumbImage(UIImage(named: "thumbHightLight.png"),forState: .Highlighted)
        
    }
    
    func music(){
        audio = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileMusic[current_Song], ofType: ".mp3")!))
        self.lbl_TimeTotal.text = String(format : "%2.2f", audio.duration/60)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateTimeLeft"), userInfo: nil, repeats: true)
        
        audio.delegate = self
        audio.prepareToPlay()
        //        audio.play()
        
    }
    
    @IBAction func action_Play(sender: AnyObject) {
        
        if audio.playing {
            audio.pause()
            btn_Play.setBackgroundImage(UIImage(named: "play.png"), forState: .Normal)
        } else {
            audio.play()
            btn_Play.setBackgroundImage(UIImage(named: "pause.png"), forState: .Normal)
        }
    }
    
    @IBAction func sld_Volume(sender: UISlider) {
        audio.volume = sender.value
    }
    
    @IBAction func sld_Duration(sender: UISlider) {
        audio.currentTime = Double(sender.value) * Double(audio.duration)
    }
    
    
    @IBAction func action_Repeat(sender: UISwitch) {
        if sender.on {
            audio.numberOfLoops = -1
        } else {
            audio.numberOfLoops = 0
        }
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        if !sw_Repeate.on {
            //            btn_Play.setBackgroundImage(UIImage(named: "play.png"), forState: .Normal)
            current_Song++
            music()
            audio.play()
            var index = NSIndexPath(forRow: current_Song, inSection: 0)
            
            self.tableview.selectRowAtIndexPath(index, animated: true, scrollPosition: .None)
            
            self.tableView(self.tableview, didSelectRowAtIndexPath: index)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileMusic.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellMusic", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = fileMusic[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        current_Song = indexPath.row
        music()
        audio.play()
        if audio.playing {
            btn_Play.setBackgroundImage(UIImage(named: "pause.png"), forState: .Normal)
            
        } else {
            
            btn_Play.setBackgroundImage(UIImage(named: "play.png"), forState: .Normal)
        }
    }
    
    @IBAction func action_next(sender: AnyObject) {
        
        current_Song++
        
        if (current_Song) == fileMusic.count {
            current_Song = 0
        }
        var index = NSIndexPath(forRow: current_Song, inSection: 0)
        
        self.tableview.selectRowAtIndexPath(index, animated: true, scrollPosition: .None)
        self.tableView(self.tableview, didSelectRowAtIndexPath: index)
    }
    
    @IBAction func action_back(sender: UIButton){
        current_Song--
        
        if (current_Song) == -1 {
            current_Song = 4
        }
        var index = NSIndexPath(forRow: current_Song, inSection: 0)
        
        self.tableview.selectRowAtIndexPath(index, animated: true, scrollPosition: .None)
        self.tableView(self.tableview, didSelectRowAtIndexPath: index)
        
    }
    
    
}

