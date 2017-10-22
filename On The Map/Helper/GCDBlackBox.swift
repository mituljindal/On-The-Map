//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by mitul jindal on 09/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
