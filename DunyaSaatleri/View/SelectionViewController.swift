//
//  SelectionViewController.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//

import UIKit
import DropDown
import SwiftAnalogueClock
// Protocol for the fetching datas from API (local JSON).
protocol SelectionOutput {
    func saveDatas(values: [Times])
}

// MARK: The Selection VC's Class
final class SelectionViewController: UIViewController {

    private var clockView = AnalogueClockView()
    private var cityName = UILabel()
    private var clockBackgroundColor = UILabel()
    private var clockItemColor = UILabel()
    private var okButton = UIButton()
    private var cancelButton = UIButton()
    
    private let dropDownCity = DropDown()
    private let dropDownColor = DropDown()
    private let dropDownItemColor = DropDown()

    lazy var viewModel: ClocksViewModel = ClockViewModel()
    private lazy var result: [Time] = []
    
    private var citySelected: String = ""
    private var timeZoneSelected: String = ""
    private var colorNameSelected: String = ""
    private var colorCodeSelected: String = ""
    
    private var clockOfCity: [Time] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        frameConfigure()
        dropDownConfigureCity()
        dropDownConfigureColor()
        dropDownConfigureTintColor()

        viewModel.setSelectDelegate(output: self)
        viewModel.fethItems()

        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkDatas), userInfo: nil, repeats: true)
        
    }
    /// Checking datas for every 5 seconds.
    @objc func checkDatas() {
//        print("Data fetced")
        viewModel.fethItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            self.clockView.runClockOn(date: .now)
        }
    }
    
    /// The function of the citiy's selection combobox
    private func dropDownConfigureCity() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropDownCity))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        cityName.addGestureRecognizer(gesture)
    }
    
    /// The function of the citiy's selection combobox when its tapped.
    @objc func didTapDropDownCity() {
        dropDownCity.show()
    }
    
    /// The function of the clock's backgorund color selection combobox
    private func dropDownConfigureColor() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropDownColor))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        clockBackgroundColor.addGestureRecognizer(gesture)
    }
    
    /// The function of the clock's backgorund color selection combobox when its tapped
    @objc func didTapDropDownColor() {
        dropDownColor.show()
    }
    /// The function of the clock's titnt color selection combobox
    private func dropDownConfigureTintColor() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapDropDownTintColor))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        clockItemColor.addGestureRecognizer(gesture)
    }
    /// The function of the clock's titnt color selection combobox when its tapped
    @objc func didTapDropDownTintColor() {
        dropDownItemColor.show()
    }
    /// Configuration of the view
    private func viewConfigure() {
        title = "Saat Ekle"
        view.backgroundColor = .systemBackground
    }
    /// Frames are given for the SelectionVC
    private func frameConfigure() {
        
        let size = view.frame.size
        
        clockView.frame = CGRect(x: 50, y: 90, width: size.width - 100, height: size.width - 100)
        clockView.clockType = .normal
        clockView.clockLineWidth = 3
        view.addSubview(clockView)
        
        cityName.isUserInteractionEnabled = true
        cityName.text = "Şehir Adı"
        cityName.textColor = .black
        cityName.font = .boldSystemFont(ofSize: 20)
        cityName.textAlignment = .center
        cityName.layer.borderWidth = 5
        cityName.layer.cornerRadius = 20
        cityName.frame = CGRect(x: 10, y: size.width, width: size.width - 20, height: 50)
        view.addSubview(cityName)
        
        clockBackgroundColor.isUserInteractionEnabled = true
        clockBackgroundColor.text = "Saat Arkaplan Rengi"
        clockBackgroundColor.textColor = .black
        clockBackgroundColor.font = .boldSystemFont(ofSize: 20)
        clockBackgroundColor.textAlignment = .center
        clockBackgroundColor.layer.borderWidth = 5
        clockBackgroundColor.layer.cornerRadius = 20
        clockBackgroundColor.frame = CGRect(x: 10, y: size.width + 60, width: size.width - 20, height: 50)
        view.addSubview(clockBackgroundColor)
        
        clockItemColor.isUserInteractionEnabled = true
        clockItemColor.text = "Saat Sayaç - Rakam Rengi"
        clockItemColor.textColor = .black
        clockItemColor.font = .boldSystemFont(ofSize: 20)
        clockItemColor.textAlignment = .center
        clockItemColor.layer.borderWidth = 5
        clockItemColor.layer.cornerRadius = 20
        clockItemColor.frame = CGRect(x: 10, y: size.width + 120, width: size.width - 20, height: 50)
        view.addSubview(clockItemColor)
        
        let largeConfigOK = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let largeBoldDocOK = UIImage(systemName: "checkmark.circle", withConfiguration: largeConfigOK)
        okButton.setImage(largeBoldDocOK, for: .normal)
        okButton.frame = CGRect(x: (size.width / 2) - 60, y: size.height - 70, width: 50, height: 50)
        okButton.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
        view.addSubview(okButton)
        
        let largeConfigCancel = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let largeBoldDocCancel = UIImage(systemName: "multiply.circle", withConfiguration: largeConfigCancel)
        cancelButton.setImage(largeBoldDocCancel, for: .normal)
        cancelButton.frame = CGRect(x: (size.width / 2) + 10, y: size.height - 70, width: 50, height: 50)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
    }
    
    ///Functions of the OK button
    @objc func didTapOk() {
        // MARK: Save Data to UserDefaults
        
        /// Read existing data
        let defaults = UserDefaults.standard
        if let savedCity = defaults.object(forKey: "myKey") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([Time].self, from: savedCity) {
                clockOfCity = loadedData
            }
        }
        /// Append the selected data from comboboxes's selection
        let clockOfCityAppend = Time(city: citySelected, timeZone: timeZoneSelected, colorName: colorNameSelected, colorCode: colorCodeSelected)
        clockOfCity.append(clockOfCityAppend)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(clockOfCity) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "myKey")
        }
        /// Dismis view
        navigationController?.pushViewController(MasterViewController(), animated: true)
    }
    
    ///Functions of the Cancel  button
    @objc func didTapCancel() {
        /// Dismis view
        navigationController?.pushViewController(MasterViewController(), animated: true)
    }

}

// MARK: Implemention of the fetched datas
extension SelectionViewController: SelectionOutput {
    func saveDatas(values: [Times]) {
        /// Initial Data comes:
        result = values[0].times ?? []
        
        /// Collecting datas for the cities combobax
        var cityData: [String?] = []
        for i in 0...9 {
            let city = result[i].city
            cityData.append(city)
        }
        
        // MARK: Cities Combobox
        dropDownCity.anchorView = cityName
        guard let cityData = cityData as? [String] else { return }
        dropDownCity.dataSource = cityData
        
        /// Changing the city label according the selection
        dropDownCity.selectionAction = { [unowned self] (index: Int, item: String) in
            
            // MARK: Adaptive clock according the selecting city
            guard let timeZone = result[index].timeZone else { return }
            guard let time = TimeZone.init(identifier: timeZone) else { return }
            
            let date = Calendar.current.dateComponents(in: time, from: .now)
            guard let year = date.year, let month = date.month, let day = date.day, let hour = date.hour, let minute = date.minute, let second = date.second else { return }
            let clock = Date.from(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
            guard let clock = clock else { return }
            clockView.runClockOn(date: clock)
            /// Calculating time difference
            let diffs = Calendar.current.dateComponents([.hour], from: Date.now, to: clock)
            guard let dif = diffs.hour as Int? else { return }
            
            cityName.text = item + " (Saat Farkı: \(dif))"
            citySelected = item
            timeZoneSelected = timeZone
        }
        
        /// Collecting datas for the color combobax
        var colorData: [String?] = []
        for i in 0...9 {
            let color = result[i].colorName
            colorData.append(color)
        }
        
        // MARK: Backgorund Color Combobox
        dropDownColor.anchorView = clockBackgroundColor
        guard let colorData = colorData as? [String] else { return }
        dropDownColor.dataSource = colorData
        
        dropDownColor.selectionAction = { [unowned self] (index: Int, item: String) in
        /// Changing the color label according the selection
            clockBackgroundColor.text = item
            guard let color = UIColor(hexString: result[index].colorCode) else { return }
            clockView.clockFillColor = color
            guard let colorString = result[index].colorCode else { return }
            colorCodeSelected = colorString
            clockBackgroundColor.text = result[index].colorName
        }
        
        // MARK: Accessorie Color Combobox
        dropDownItemColor.anchorView = clockItemColor
        dropDownItemColor.dataSource = colorData
        dropDownItemColor.selectionAction = { [unowned self] (index: Int, item: String) in
            
        // MARK: Changing the item color of clock according the selection
            guard let color = UIColor(hexString: result[index].colorCode) else { return }
            /// Clock frame border color
            clockView.clockStrokeColor = color
            /// Clock hour stick (akrep ) color
            clockView.hoursHandStrokeColor = color
            clockView.hoursHandFillColor = color
            clockView.hoursMarkFillColor = color
            clockView.hoursHandStrokeColor = color
            clockView.hoursMarkStrokeColor = color
            /// Clock minute stick (yelkovan) color
            clockView.minutesHandFillColor = color
            clockView.minutesHandStrokeColor = color
            clockView.minutesMarkFillColor = color
            clockView.minutesMarkStrokeColor = color
            /// Clock second stick color
            clockView.secondsHandFillColor = color
            clockView.secondsHandStrokeColor = color
            /// Clock number color
            clockView.hourMarkingTextColor = color
            guard let backgrounColor = result[index].colorCode else { return }
            colorNameSelected = backgrounColor
            clockItemColor.text = result[index].colorName
        }
    }
}
