//
//  ViewController.swift
//  ARKitSpitfire
//
//  Created by Christopher Webb-Orenstein on 10/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: PlaneSceneView!
    
    var locationService = LocationService()
    var startingLocation: CLLocation!
    var destinationLocation: CLLocation!
    
    var planeCanFly: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.destinationLocation = CLLocation(latitude: 40.7375124, longitude: -73.98076650000002)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        locationService.delegate = self
        
        locationService.startUpdatingLocation(locationManager: locationService.locationManager!)
        // Create a new scene
        sceneView.setupPlane()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if planeCanFly {
            sceneView.moveFrom(location: startingLocation, to: destinationLocation)
        }
    }

    // MARK: - ARSCNViewDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension ViewController: LocationServiceDelegate {
    
    func trackingLocation(for currentLocation: CLLocation) {
        startingLocation = currentLocation
        planeCanFly = true
    }
    
    func trackingLocationDidFail(with error: Error) {
        print(error.localizedDescription)
    }
}
