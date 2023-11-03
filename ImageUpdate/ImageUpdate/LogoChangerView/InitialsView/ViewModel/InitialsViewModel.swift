//
//  InitialsViewModel.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 02/11/2023.
//

import SwiftUI

struct InitialsModel {
    var title: String = ""
    var color: Color = Color.defaultProfileColor
}

extension InitialsView {
    class ViewModel: ObservableObject {
        
        enum Option: CaseIterable {
            case text
            case style
            
            var title: String {
                switch self {
                case .text: return "Text"
                case .style: return "Style"
                }
            }
        }
        
        var defaultColors = Color.defaultColors
        
        @Published var initialsModel: InitialsModel
        @Published var selectedUpdate: Option = .text
        
        init(_ initialsModel: InitialsModel) {
            self.initialsModel = initialsModel
        }
        
        var isPickerVisible: Bool {
#if targetEnvironment(macCatalyst)
            return false
#else
            return true
#endif
        }
        
        var isColorCollectionVisible: Bool {
#if targetEnvironment(macCatalyst)
            return true
#else
            return selectedUpdate == .style
#endif
        }
    }
}
