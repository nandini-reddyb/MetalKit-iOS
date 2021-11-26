//
//  SideScreen2.swift
//  HelloMetal
//
//  Created by Nandini B on 25/10/21.
//  Copyright © 2021 razeware. All rights reserved.
//

import Foundation
import Metal

class SideScreen2: Node {
  
  init(device: MTLDevice){
    
    let A = Vertex(x: -0.85, y:   2.2, z:   0.05,   r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let B = Vertex(x: -0.85, y:  -2.2, z:   0.05,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let C = Vertex(x:  0.85, y:  -2.2, z:   0.05,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let D = Vertex(x:  0.85, y:   2.2, z:   0.05,   r:  1.0, g:  1.0, b:  1.0, a:  0.5)

    let Q = Vertex(x: -0.85,  y:   2.2,  z:  -0.45,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let R = Vertex(x:  0.85, y:  2.2,    z: -0.45,      r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let S = Vertex(x: -0.85,   y:  -2.2, z:  -0.45,     r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let T = Vertex(x:  0.85,  y:  -2.2,  z:  -0.45,     r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    

    let verticesArray:Array<Vertex> = [
      A,B,C ,A,C,D,   //Front
      R,T,S ,Q,R,S,   //Back
      
      Q,S,B ,Q,B,A,   //Left
      D,C,T ,D,T,R,   //Right
      
      Q,A,D ,Q,D,R,   //Top
      B,S,T ,B,T,C    //Bottom
    ]
    
    super.init(name: "SideScreen2", vertices: verticesArray, device: device)
  }
}

