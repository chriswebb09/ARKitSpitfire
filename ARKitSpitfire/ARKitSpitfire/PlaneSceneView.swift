//
//  PlaneSceneView.swift
//  ARKitSpitfire
//
//  Created by Christopher Webb-Orenstein on 10/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit
import CoreLocation
import GLKit

class PlaneSceneView: ARSCNView {
    
    var planeNode: SCNNode!
    var rearNode:SCNNode!
    var engineNode: SCNNode!
    var leftWing: SCNNode!
    var rightWing: SCNNode!
    var wheelSupport: SCNNode!
    var landingLight: SCNNode!
    var cockpit: SCNNode!
    var bodyFront: SCNNode!
    var glass: SCNNode!
    var pilot: SCNNode!
    var reflect: SCNNode!
    var nodes: [SCNNode] = []
    
    
    func setupPlane() {
        scene = SCNScene(named: "art.scnassets/spitfiremodelplane.scn")!
        planeNode = scene.rootNode
        engineNode = planeNode.childNode(withName: "engine", recursively: false)
        bodyFront = planeNode.childNode(withName: "body_front", recursively: false)
        leftWing = planeNode.childNode(withName: "left_wing", recursively: false)
        rightWing = planeNode.childNode(withName: "right_wing", recursively: false)
        cockpit = planeNode.childNode(withName: "cockpit", recursively: false)
        rearNode = planeNode.childNode(withName: "rear", recursively: false)
        pilot = planeNode.childNode(withName: "pilot", recursively: false)
        glass = planeNode.childNode(withName: "glass", recursively: false)
        landingLight = planeNode.childNode(withName: "landing_light", recursively: false)
        wheelSupport = planeNode.childNode(withName: "wheel_support", recursively: false)
        reflect = planeNode.childNode(withName: "reflect", recursively: false)
        planeNode.scale = SCNVector3(0.055, 0.055, 0.055)
        planeNode.position = SCNVector3(0, 0, -2.25)
        nodes = [planeNode, engineNode, bodyFront, leftWing, rightWing, cockpit, rearNode, pilot, glass, landingLight, wheelSupport, reflect]
        let nodeArray = scene.rootNode.childNodes
        startEngine()
        for childNode in nodeArray {
            planeNode.addChildNode(childNode as SCNNode)
        }
    }
    
    func startEngine() {
        DispatchQueue.main.async {
            let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 85, duration: 0.5)
            let moveSequence = SCNAction.sequence([rotate])
            let moveLoop = SCNAction.repeatForever(moveSequence)
            self.engineNode.runAction(moveLoop, forKey: "engine")
        }
    }
    
    func stopEngine() {
        self.engineNode.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -85, duration: 0.5), forKey: "engine")
        engineNode.removeAnimation(forKey: "engine")
    }
    
    func moveFrom(location: CLLocation, to destination: CLLocation) {
        self.engineNode.isHidden = true
        let bearing = location.bearingToLocationRadian(destination)
        
        DispatchQueue.main.async {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.25
            for node in self.nodes {
                let rotation = SCNMatrix4MakeRotation(Float(-1 * bearing), 0, 1, 0)
                node.transform = SCNMatrix4Mult(node.transform, rotation)
            }
            SCNTransaction.commit()
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 20
            let translation = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: location, location: destination)
            let position = SCNVector3.positionFromTransform(translation)
            for node in self.nodes {
                node.position = position
            }
            SCNTransaction.commit()
        }
    }
}

