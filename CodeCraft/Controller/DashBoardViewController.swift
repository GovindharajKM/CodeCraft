//
//  DashBoardViewController.swift
//  CodeCraft
//
//  Created by Govindharaj Murugan on 21/01/21.
//

import UIKit

class DashBoardViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var viewFluctuation: UIView!
    @IBOutlet weak var viewEconomy: UIView!
    @IBOutlet weak var viewRank: UIView!
    @IBOutlet weak var viewSavings: UIView!
    
    @IBOutlet weak var btnLeftArrow: UIButton!
    @IBOutlet weak var btnRightArrow: UIButton!
    @IBOutlet weak var lblKwh: UILabel!
    @IBOutlet weak var lblDevices: UILabel!
    @IBOutlet weak var btnOptimumSwitch: UISwitch!
    @IBOutlet weak var basicBarChart: BasicBarChart!
    @IBOutlet weak var lblSaving: UILabel!
    

    // MARK:- Variables
    var timer: Timer!
    var valuFluct = 650
    var arrBarMetrics = [DataEntry]() {
        didSet {
            self.basicBarChart.updateDataEntries(dataEntries: arrBarMetrics, animated: false)
            if self.basicBarChart.scrollView.contentSize.width > (self.view.frame.width - 100) {
                self.basicBarChart.scrollView.setContentOffset(CGPoint(x: self.basicBarChart.scrollView.contentOffset.x + 20, y: 0), animated: true)
            }
        }
    }
    
    let appBlue = UIColor().hexStringToUIColor(hex: "#19EBFF")
    let appOrange = UIColor().hexStringToUIColor(hex: "#FFCF4F")
    let appRed = UIColor().hexStringToUIColor(hex: "#FF3D00")
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateOrbs), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.timer = nil
    }
    
    func setUpUIView() {
        self.view.setOptimumGradientColor()
        self.segmentedControl.addUnderlineForSelectedSegment()
        
        self.segmentedControl.selectedSegmentIndex = 1
        self.segmentedControl_Click(self.segmentedControl!)
        
        self.viewFluctuation.setRoundedCorner()
        self.viewEconomy.setRoundedCorner()
        self.viewRank.setRoundedCorner()
        self.viewSavings.setRoundedCorner()
        self.lblBadge.setRoundedCorner()
        
        self.btnLeftArrow.setRoundedCorner()
        self.btnRightArrow.setRoundedCorner()
        self.btnLeftArrow.setborderWith(.white)
        self.btnRightArrow.setborderWith(.white)
        
        self.viewFluctuation.setborderWith(self.appBlue)
        self.viewEconomy.setborderWith(.white)
        self.viewRank.setborderWith(.white)
        self.viewSavings.setborderWith(self.appBlue)
    }
    
    func generateDataEntry(_ color: UIColor) {
        arrBarMetrics.append(DataEntry(color: color, height: Float(self.valuFluct)/1000, textValue: "\(self.valuFluct)", title: ""))
    }
    
    @objc func updateOrbs() {
       
        let animation = CATransition()
        self.lblKwh.layer.add(animation, forKey: nil)
        self.lblKwh.text = "\(self.valuFluct)"
        
        switch self.valuFluct {
        case 820...830:
            self.viewFluctuation.setborderWith(self.appBlue)
            self.generateDataEntry(self.appBlue)
            self.viewSavings.setborderWith(self.appBlue)
            break
        case 830...840:
            self.viewFluctuation.setborderWith(self.appOrange)
            self.generateDataEntry(self.appOrange)
            break
        case 840...900:
            self.viewFluctuation.setborderWith(self.appRed)
            self.generateDataEntry(self.appRed)
            self.viewSavings.setborderWith(self.appRed)
        default:
            self.viewFluctuation.setborderWith(self.appBlue)
            self.generateDataEntry(self.appBlue)
            break
        }
        
        self.lblSaving.layer.add(animation, forKey: nil)
        self.lblSaving.text = "\(1000 - self.valuFluct)"
        switch (1000 - self.valuFluct) {
        case 250...350:
            self.viewSavings.setborderWith(UIColor.green)
            break
        case 150...250:
            self.viewSavings.setborderWith(self.appOrange)
            break
        case 0...150:
            self.viewSavings.setborderWith(self.appRed)
            break
        default:
            self.viewSavings.setborderWith(UIColor.green)
            break
        }
        
        self.valuFluct = Int.random(in: 650..<900)
    }
    
    // MARK:- IBAction
    @IBAction func btnOptimumSwitch_Click(_ sender: Any) {
        
        if self.btnOptimumSwitch.isOn {
            self.view.setOptimumGradientColor()
        } else {
            self.view.setGradientColor()
        }
        self.reloadInputViews()
        self.view.setNeedsDisplay()
    }
    
    @IBAction func segmentedControl_Click(_ sender: Any) {
        self.segmentedControl.changeUnderlinePosition()
        self.segmentedControl.unselectedSegmentTintColor()
        self.segmentedControl.selectedSegmentTintColor()
    }
    
    @IBAction func btnLeftArrow_Click(_ sender: Any) {
        let newCurrentOffset = self.basicBarChart.scrollView.contentOffset.x -  400
        if self.basicBarChart.scrollView.contentSize.width > self.view.frame.width {
            self.basicBarChart.scrollView.setContentOffset(CGPoint(x: newCurrentOffset, y: 0), animated: true)
        }
    }
    
    @IBAction func btnRightArrow_Click(_ sender: Any) {
        let newCurrentOffset = self.basicBarChart.scrollView.contentOffset.x + self.view.frame.width
        if self.basicBarChart.scrollView.contentSize.width > newCurrentOffset {
            self.basicBarChart.scrollView.setContentOffset(CGPoint(x: newCurrentOffset, y: 0), animated: true)
        }
    }
    
   
}


extension DashBoardViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
