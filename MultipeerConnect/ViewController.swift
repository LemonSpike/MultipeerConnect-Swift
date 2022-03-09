//
//  ViewController.swift
//  MultipeerConnect
//
//  Created by Pranav Kasetti on 09/03/2022.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

  var viewModel = MultipeerViewModel()

  // Set this to false for in-store client.
  var browserMode = false

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if browserMode {
      joinSession()
    }
  }

  func joinSession() {
    let mcBrowser = MCBrowserViewController(serviceType: "hws-kb",
                                            session: viewModel.mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
}

extension ViewController: MCBrowserViewControllerDelegate {

  func browserViewController(_ browserViewController: MCBrowserViewController,
                             shouldPresentNearbyPeer peerID: MCPeerID,
                             withDiscoveryInfo info: [String : String]?) -> Bool {
    viewModel.devices.append(peerID.displayName)
    return true
  }

  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }

  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
}
