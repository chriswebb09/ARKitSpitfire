//
//  PlaneSceneView.swift
//  ARKitSpitfire
//
//  Created by Christopher Webb-Orenstein on 10/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

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
        planeNode.scale = SCNVector3(0.025, 0.025, 0.025)
        planeNode.position = SCNVector3(0, 0, -2.25)
        nodes = [planeNode, engineNode, bodyFront, leftWing, rightWing, cockpit, rearNode, pilot, glass, landingLight, wheelSupport, reflect]
        let nodeArray = scene.rootNode.childNodes
        for childNode in nodeArray {
            planeNode.addChildNode(childNode as SCNNode)
        }
        spinPropellor()
    }
    func spinPropellor() {
        DispatchQueue.main.async {
            let spin = SCNAction.rotateBy(x: 0, y: 0, z: 127.5, duration: 0.85)
            let spinSequence = SCNAction.sequence([spin])
            let spinLoop = SCNAction.repeatForever(spinSequence)
            self.engineNode.runAction(spinLoop)
        }
    }
    
    var duration: TimeInterval = 0.35
    var counter: Int = 0
    
    func moveForward() {
        DispatchQueue.main.async {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            for node in self.nodes {
                node.transform = SCNMatrix4Mult(node.transform, SCNMatrix4MakeTranslation(0, node.position.y + 1, node.position.z + -2))
            }
            self.rearNode.position = SCNVector3(self.rearNode.position.x, self.rearNode.position.y - 0.05, self.rearNode.position.z)
            
            SCNTransaction.commit()
        }
    }
}
