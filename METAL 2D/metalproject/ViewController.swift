//
//  ViewController.swift
//  metalproject
//
//  Created by Nandini B on 11/10/21.
//

import UIKit
import Metal


class ViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
   
    //creates array of floats on cpu
    //square
   /* let vertexData:[Float] = [
        -0.5 , 0 ,0,
        0.5, 0 , 0,
        0.5, 0.5, 0.0,
        -0.5 , 0.5 ,0,
        -0.5 , 0 , 0,
      0.5,0 , 0
       ]*/
    //triangle
//    let vertexData:[Float] = [
//        0 , -0.5 , 0 , //top
//        -0.5 , 0 , 0 , // bottom left
//        0.5 , 0 , 0   //bottom right
//    ]
    
    let vertexData:[Float] = [
        -0.5 , 0.5 ,0,
        -0.5 , -0.5 , 0 ,
        0.5 , -0.5 , 0 ,
        0.5 , 0.5 , 0 ,
        0.5 , -0.5 , 0 ,
        0.5 , 0.5 , 0
        
        ]
//
//    var vertexData: [Float] = [
//        Vertex(position: [0,1,0], color: [1,0,0,1]),
//        Vertex(position: [-1,-1,0], color: [0,1,0,1]),
//        Vertex(position: [1,-1,0], color: [0,0,1,1])
//        ]
    //indices
    let indices:[UInt32] = [
    0 , 1 , 2 ,
    2,  3 , 0
    ]

   
  
    // to send data to GPU
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    
    //reder pipeline
    var pipelineState: MTLRenderPipelineState!

    //command queue
    var commandQueue: MTLCommandQueue!
    
    //creating display link
    var timer: CADisplayLink!

    override func viewDidLoad() {
      super.viewDidLoad()
        
      device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer() //create new CAMetalLayer
        metalLayer.device = device //specifying MTLDevice the layer should use
        metalLayer.pixelFormat = .bgra8Unorm; //pixel format ,8 bytes for blue green red alpha
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame  //set frame of the layer to match frame of the view
        view.layer.addSublayer(metalLayer)  //add layer
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // to get size of the vertex data in bytes
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // create a new buffer on GPU
        
        //index buffer
        let dataSize1 = indices.count * MemoryLayout.size(ofValue: indices[0])
        indexBuffer = device.makeBuffer(bytes: indices, length: dataSize1, options: [])
        
        // render pipeline
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
            
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

         //command queue
        commandQueue = device.makeCommandQueue()
        
        //display link
        timer = CADisplayLink(target: self, selector: #selector(gameloop))
        timer.add(to: RunLoop.main, forMode: .default)
        
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0.5,
            green: 0.4 ,
            blue: 0.0,
          alpha: 1.0)
        
        //unwrap the indexbuffer
     let indexBuffer = indexBuffer
        
        //creating command buffer
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        //createing render command  encoder
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 10, instanceCount: 1)
        
        //index
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip, indexCount: indices.count, indexType: .uint32, indexBuffer: indexBuffer!, indexBufferOffset: 0)
        
        renderEncoder.endEncoding()

        //commiting the command buffer
        commandBuffer.present(drawable)
        commandBuffer.commit()

    

    }

    @objc func gameloop() {
      autoreleasepool {
        self.render()
      }
    }
}

