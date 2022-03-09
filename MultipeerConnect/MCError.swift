//
//  MCError.swift
//  MultipeerConnect
//
//  Created by Pranav Kasetti on 09/03/2022.
//

import Foundation

enum MCError: Error {
  case sendError(description: String)
}

extension MCError: LocalizedError {
  public var errorDescription: String? {
    switch self {
      case .sendError(let description):
        return NSLocalizedString(description,
                                 comment: "Send error")
    }
  }
}
