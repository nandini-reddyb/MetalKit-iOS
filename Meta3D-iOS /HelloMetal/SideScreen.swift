//
//  SideScreen.swift
//  HelloMetal
//
//  Created by Nandini B on 19/10/21.
//  Copyright © 2021 razeware. All rights reserved.
//

import Foundation
import Metal

class SideScreen: Node {
  
  init(device: MTLDevice){
//    let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  1.0, b:  1.0, a:  0.0)
//    let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  1.0, a:  0.0)
//    let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  1.0, a:  0)
//    let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.0, g:  1.0, b:  1.0, a:  0.0)
//
//    let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  1.0, b:  1.0, a:  0.0)
//    let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  1.0, g:  1.0, b:  1.0, a:  0.0)
//    let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  1.0, g:  1.0, b:  1.0, a:  0.0)
//    let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  1.0, g:  1.0, b:  1.0, a:  0.0)
    
    let A = Vertex(x: -0.85, y:   2.2, z:   0.05,   r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let B = Vertex(x: -0.85, y:  -2.2, z:   0.05,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let C = Vertex(x:  0.85, y:  -2.2, z:   0.05,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let D = Vertex(x:  0.85, y:   2.2, z:   0.05,   r:  1.0, g:  1.0, b:  1.0, a:  0.5)

    let Q = Vertex(x: -0.85,  y:   2.2,  z:  -0.45,    r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let R = Vertex(x:  0.85, y:  2.2,    z: -0.45,      r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let S = Vertex(x: -0.85,   y:  -2.2, z:  -0.45,     r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    let T = Vertex(x:  0.85,  y:  -2.2,  z:  -0.45,     r:  1.0, g:  1.0, b:  1.0, a:  0.5)
    
//    let A = Vertex(x: -1.3, y:   1.3, z:   1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let B = Vertex(x: -1.3, y:  -1.3, z:   1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let C = Vertex(x:  1.3, y:  -1.3, z:   1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let D = Vertex(x:  1.3, y:   1.3, z:   1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//
//    let Q = Vertex(x: -1.3, y:   1.3, z:  -1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let R = Vertex(x:  1.3, y:   1.3, z:  -1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let S = Vertex(x: -1.3, y:  -1.3, z:  -1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)
//    let T = Vertex(x:  1.3, y:  -1.3, z:  -1.3, r:  1.0, g:  0.5, b:  0.0, a:  0.4)


    
    let verticesArray:Array<Vertex> = [
      A,B,C ,A,C,D,   //Front
      R,T,S ,Q,R,S,   //Back
      
      Q,S,B ,Q,B,A,   //Left
      D,C,T ,D,T,R,   //Right
      
      Q,A,D ,Q,D,R,   //Top
      B,S,T ,B,T,C    //Bottom
    ]
    
    super.init(name: "SideScreen", vertices: verticesArray, device: device)
  }
}

