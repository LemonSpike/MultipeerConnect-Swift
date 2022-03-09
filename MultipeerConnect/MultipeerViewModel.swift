//
//  MultipeerViewModel.swift
//  MultipeerConnect
//
//  Created by Pranav Kasetti on 09/03/2022.
//

import UIKit
import MultipeerConnectivity

class MultipeerViewModel: NSObject {

  var peerID: MCPeerID
  var mcSession: MCSession
  var mcAdvertiserAssistant: MCAdvertiserAssistant

  var devices: [String] = []
  var error: MCError? {
    didSet {
      print(error?.errorDescription ?? "")
    }
  }

  var isErrorPresented = false

  override init() {
    self.peerID = MCPeerID(displayName: UUID().uuidString)
    self.mcSession = MCSession(peer: peerID,
                              securityIdentity: nil,
                              encryptionPreference: .required)
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb",
                                                  discoveryInfo: nil,
                                                  session: mcSession)
    super.init()
    self.mcSession.delegate = self
    self.mcAdvertiserAssistant.start()
  }

  func sendServerName(text: String) {
    if let textData = text.data(using: .utf8),
        mcSession.connectedPeers.count > 0 {
      do {
        try mcSession.send(textData,
                           toPeers: mcSession.connectedPeers,
                           with: .reliable)
      } catch {
        self.error = MCError
          .sendError(description: error.localizedDescription)
      }
    }
  }
}

extension MultipeerViewModel: MCSessionDelegate {

  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
      case MCSessionState.connected:
        print("Connected: \(peerID.displayName)")

      case MCSessionState.connecting:
        print("Connecting: \(peerID.displayName)")

      case MCSessionState.notConnected:
        print("Not Connected: \(peerID.displayName)")
      @unknown default:
        print("Unknown state: \(peerID.displayName)")
    }
  }

  func session(_ session: MCSession,
               didReceive data: Data,
               fromPeer peerID: MCPeerID) {
    let device = String(data: data, encoding: .utf8) ?? "N/A"
    devices.append(device)
  }

  func session(_ session: MCSession,
               didReceive stream: InputStream,
               withName streamName: String,
               fromPeer peerID: MCPeerID) { }

  func session(_ session: MCSession,
               didStartReceivingResourceWithName resourceName: String,
               fromPeer peerID: MCPeerID, with progress: Progress) { }

  func session(_ session: MCSession,
               didFinishReceivingResourceWithName resourceName: String,
               fromPeer peerID: MCPeerID,
               at localURL: URL?,
               withError error: Error?) { }
}
