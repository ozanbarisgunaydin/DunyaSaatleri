//
//  ClockViewModel.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//

import Foundation

protocol ClocksViewModel {
    func fethItems()
    
    var timeZones: [Times] { get set }
    var clockService: ClocksService { get }
    
//    var clockOutput: ClockOutput? { get }
    var selectionOutput: SelectionOutput? { get }
    
//    func setDelegate(output: ClockOutput)
    func setSelectDelegate(output: SelectionOutput)
    
}

final class ClockViewModel: ClocksViewModel {
   
//    var clockOutput: ClockOutput?
    var selectionOutput: SelectionOutput?
    
//    func setDelegate(output: ClockOutput) {
//        self.clockOutput = output
//    }
    
    func setSelectDelegate(output: SelectionOutput) {
        self.selectionOutput = output
    }
    
    var timeZones: [Times] = []
    let clockService: ClocksService
    
    init() {
        clockService = ClockService()
    }
    
    func fethItems() {
        clockService.getAllDatas { [weak self] (response)  in
            self?.timeZones = response ?? []
//            self?.clockOutput?.saveDatas(values: self?.timeZones ?? [])
            self?.selectionOutput?.saveDatas(values: self?.timeZones ?? [])
        }
    }
}
