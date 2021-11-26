//
//  ClocksCollectionViewCell.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//

import UIKit
import SwiftAnalogueClock
/// Costum cell of the collection view.
final class ClocksCollectionViewCell: UICollectionViewCell {
    /// Custom cell indetifier
    static let identifier = "ClocksCollectionViewCell"
    // MARK: Subview Properties
    private let clockView: AnalogueClockView = {
        let clock = AnalogueClockView()
        clock.contentMode = .scaleAspectFit
        clock.clipsToBounds = true
        clock.clockLineWidth = 3
        clock.clockType = .normalMinimum
        return clock
    }()
    
    private let cityLabel: UILabel = {
       let label = UILabel()
        label.text = "Custom"
        label.textAlignment = .center
        return label
    }()
    
    private let selectLabel: UIImageView = {
        let select = UIImageView()
        select.image = UIImage(systemName: "checkmark.circle")
        select.contentMode = .scaleAspectFill
        select.clipsToBounds = true
        select.isUserInteractionEnabled = false
        select.isHidden = true
        return select
    }()
    
    var isEditing: Bool = false {
        didSet{
            selectLabel.isHidden = !isEditing
        }
    }
    
    private var clockForWatch: Date?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(cityLabel)
        contentView.addSubview(clockView)
        contentView.addSubview(selectLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.frame.size
        // MARK: Layout - Frame Properties
        cityLabel.frame = CGRect(x: 5, y: size.height - 50, width: size.width - 10, height: 50)
        clockView.frame = CGRect(x: 25, y: 0, width: size.height - 50, height: size.height - 50)
        selectLabel.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        DispatchQueue.main.async {
            self.clockView.runClockOn(date: self.clockForWatch)
        }
        /// Changing the CheckMark color according to the tapping
        if selectLabel.isHighlighted == true {
            selectLabel.tintColor = .red
        } else {
            selectLabel.tintColor = .systemBlue
        }
        

    }
    // MARK: Taking datas from MasterVC
    func saveModel(model: Time) {
        
        /// Time arrangements
        guard let timeZone = model.timeZone else { return }
        guard let time = TimeZone.init(identifier: timeZone) else { return }
        let date = Calendar.current.dateComponents(in: time, from: .now)
        guard let year = date.year, let month = date.month, let day = date.day, let hour = date.hour, let minute = date.minute, let second = date.second else { return }
        let clock = Date.from(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        guard let clock = clock else { return }
        clockForWatch = clock
        
        let backgroundColor = UIColor(hexString: model.colorName)
        clockView.clockFillColor = backgroundColor
        
        let color = UIColor(hexString: model.colorCode)
        guard let color = color else { return }
        
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
        
        /// Label text arrangement
        let diffs = Calendar.current.dateComponents([.hour], from: Date.now, to: clock)
        guard let dif = diffs.hour as Int?, let cityName = model.city else { return }
        cityLabel.text = cityName + " (\(dif))"
    }
    
}


