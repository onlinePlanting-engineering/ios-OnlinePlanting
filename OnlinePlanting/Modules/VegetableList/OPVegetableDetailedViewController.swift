//
//  OPVegetableDetailedViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 03/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import Charts

class OPVegetableDetailedViewController: UIViewController {


    @IBOutlet weak var detaildInfor: UIView!
    @IBOutlet weak var comment: UIView!
    @IBOutlet weak var price: UIView!
    @IBOutlet weak var cycle: UIView!
    @IBOutlet weak var checkDetailedButton: UIButton!
    
    @IBOutlet weak var checkCommentButton: UIButton!
    
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var titleLable: UIView!
    @IBOutlet weak var lifeCycle: BubbleChartView!
    @IBOutlet weak var vegetableImage: UIImageView!

    var picture: UIImage?
    var vegetabletitle: String?
    
    let months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    let plant: [Double] = [0.0, 0.0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let harvest: [Double] = [0, 0.0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigarationBar()
        lifeCycle.xAxis.valueFormatter = self
        lifeCycle.xAxis.granularity = 1
        lifeCycle.chartDescription?.enabled = false
        lifeCycle.leftAxis.drawZeroLineEnabled = false
        lifeCycle.setScaleEnabled(false)
        lifeCycle.leftAxis.axisMinimum = 0
        lifeCycle.leftAxis.axisMaximum = 10
        lifeCycle.drawBordersEnabled = true
        lifeCycle.leftAxis.drawGridLinesEnabled = false
        lifeCycle.xAxis.drawGridLinesEnabled = false
        lifeCycle.delegate = self
        let format = NumberFormatter()
        format.generatesDecimalNumbers = false
        let formatter = DefaultValueFormatter(formatter: format)
        lifeCycle.leftAxis.valueFormatter = (formatter as? IAxisValueFormatter)
        setChartBubble(months, plant: plant, harvest: harvest)
        
        showAnimation()
        
        vegetableImage.image = picture
        
    }
    
    func prepareUI() {
        comment.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        comment.layer.borderWidth = 1.5
        comment.layer.cornerRadius = 4
        comment.layer.masksToBounds = true
        
        price.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        price.layer.borderWidth = 1.5
        price.layer.cornerRadius = 4
        price.layer.masksToBounds = true
        
        cycle.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        cycle.layer.borderWidth = 1.5
        cycle.layer.cornerRadius = 4
        cycle.layer.masksToBounds = true
        
        detaildInfor.layer.borderColor = UIColor.init(hexString: OPGreenColor).cgColor
        detaildInfor.layer.borderWidth = 1.5
        detaildInfor.layer.cornerRadius = 4
        detaildInfor.layer.masksToBounds = true
        
        checkDetailedButton.layer.cornerRadius = 4
        checkDetailedButton.layer.masksToBounds = true
        
        checkCommentButton.layer.cornerRadius = 4
        checkCommentButton.layer.masksToBounds = true
        
    }
    
    func setNavigarationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#2D363C")
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white]
        navigationItem.title = vegetabletitle
    }
    
    func showAnimation() {

        cycle.transform = CGAffineTransform.init(translationX: -300, y: 0)
        detaildInfor.transform = CGAffineTransform.init(translationX: -200, y: 0)
        comment.transform = CGAffineTransform.init(translationX: 200, y: 0)
        price.transform = CGAffineTransform.init(translationX: 300, y: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.8, animations: {[weak self] in
                self?.detaildInfor.transform = .identity
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.8, animations: {[weak self] in
                self?.cycle.transform = .identity
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.8, animations: {[weak self] in
                self?.comment.transform = .identity
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.8, animations: {[weak self] in
                self?.price.transform = .identity
            })
        }
    }
    
    func dismissCurrentView() {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    func setChartBubble(_ dataPoints: [String], plant: [Double], harvest: [Double]) {
        
        
        var plantEntries: [BubbleChartDataEntry] = []
        var harvestEntries: [BubbleChartDataEntry] = []
    
        for i in 0..<dataPoints.count {
            let dataEntry = BubbleChartDataEntry(x: Double(i), y: plant[i], size: plant[i] > 0 ? CGFloat(1): 0)
            plantEntries.append(dataEntry)
        }
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BubbleChartDataEntry(x: Double(i), y: harvest[i], size: harvest[i] > 0 ? CGFloat(1): 0)
            harvestEntries.append(dataEntry)
        }
        
        let plantData1 = BubbleChartDataSet(values: plantEntries,label: "播种" )
        plantData1.drawValuesEnabled = false
        let harvestData1 = BubbleChartDataSet(values: harvestEntries,label: "收割" )
        harvestData1.drawValuesEnabled = false
        
        
        plantData1.colors =  [UIColor.init(hexString: OPGreenColor)]
        harvestData1.colors = [UIColor.orange]
        let dataSets: [BubbleChartDataSet] = [plantData1,harvestData1]
        let data = BubbleChartData.init(dataSets: dataSets)
        
        lifeCycle.data = data
        lifeCycle.xAxis.labelPosition = .top
        lifeCycle.rightAxis.enabled = false
        lifeCycle.leftAxis.enabled = false
        lifeCycle.xAxis.labelCount = 12
        lifeCycle.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
    }
}
extension OPVegetableDetailedViewController: IAxisValueFormatter, ChartViewDelegate {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
