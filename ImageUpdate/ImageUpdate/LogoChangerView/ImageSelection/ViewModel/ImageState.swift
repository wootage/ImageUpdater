//
//  ImageState.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 02/11/2023.
//

import SwiftUI

enum ImageState: Hashable {
    
    case empty
    case loading(Progress)
    case success(Image, TimeInterval)
    case initials(InitialsModel)
    case failure(Error)
    
    static func == (lhs: ImageState, rhs: ImageState) -> Bool {
        switch (lhs, rhs) {
        case (.initials(let lhsModel), .initials(let rhsModel)):
            return lhsModel.color == rhsModel.color && lhsModel.title == rhsModel.title
        case (.success(_, let lhsTime), .success(_, let rhsTime)):
            return lhsTime == rhsTime
        case (.empty, .empty), (.loading(_), .loading(_)), (.failure(_), .failure(_)):
            return true
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
            
        case .empty, .loading(_), .failure(_):
            break
        case .success(_, let timeInterval):
            hasher.combine(timeInterval)
        case .initials(let model):
            hasher.combine(model.color)
            hasher.combine(model.title)
        }
    }
}
