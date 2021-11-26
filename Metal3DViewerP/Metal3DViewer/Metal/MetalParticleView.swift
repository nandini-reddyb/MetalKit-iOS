//
//  TriangleMetalView.swift
//  MetalTriangle
//
//  Created by quockhai on 2019/3/5.
//  Copyright © 2019 Polymath. All rights reserved.
//

import UIKit
import MetalKit


class MetalParticleView: MTKView {
    
    var queue: MTLCommandQueue!
    var safetyRegionVertexBuffer: MTLBuffer!
    var safetyRegionUniformBuffer: MTLBuffer!
    var safetyRegionIndexBuffer: MTLBuffer!
   
    var sideScreenOneVertexBuffer: MTLBuffer!
    var sideScreenOneUniformBuffer: MTLBuffer!
    var sideScreenOneIndexBuffer: MTLBuffer!
   
    var sideScreenTwoVertexBuffer: MTLBuffer!
    var sideScreenTwoUniformBuffer: MTLBuffer!
    var sideScreenTwoIndexBuffer: MTLBuffer!
    
    var SensorsVertexBuffer: MTLBuffer!
    var SensorsUniformBuffer: MTLBuffer!
    var SensorsIndexBuffer: MTLBuffer!
    
    var VOBvertexBuffer: MTLBuffer!
    var VOBuniformBuffer: MTLBuffer!
    var VOBindexBuffer: MTLBuffer!
    
    var circleVertexBuffer: MTLBuffer!
    var circleUniformBuffer: MTLBuffer!
    var circleIndexBuffer: MTLBuffer!
   
    var rps: MTLRenderPipelineState!
    var rotation: Float = 0
    
    var cps: MTLComputePipelineState!
    
    private var circleVertices = [simd_float2]()
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        self.layer.isOpaque = true
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            self.device = defaultDevice
            self.queue = self.device!.makeCommandQueue()
            
            createSafetyRegionBuffers()
            createSideScreenBuffers()
            createSideScreen2Buffers()
            createSensorBuffers()
          //  createVertexPoints()
           // createVOBbuffers()
            createPipeline()
           // createPipelineState()
            registerShaders()
         
        } else {
            print("[MetalKit]: Your device is not supported Metal 🤪")
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSafetyRegionBuffers() {
        let vertexData = [
            Vertex(pos: [-0.85, 0,  0.05, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [ 1.2, 0,  0.05, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [ 1.2,  2.2,  0.05, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [-0.85,  2.2,  0.05, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [-0.85, 0, -0.45, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [ 0.85, 0, -0.45, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [ 0.85,  2.2, -0.45, 1.0], col: [1, 0.6, 0, 1]),
            Vertex(pos: [-0.85,  2.2, -0.45, 1.0], col: [1, 0.6, 0, 1])]
        
        safetyRegionVertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count, options: [])
        safetyRegionIndexBuffer = device!.makeBuffer(bytes: indexDataArray(), length: MemoryLayout<UInt16>.size * indexDataArray().count , options: [])
        safetyRegionUniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    
    func createSideScreenBuffers() {
        let vertexData = [
            Vertex(pos: [-1.7, 0,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ -0.85,  0,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ -0.85, 2.2,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [-1.7,  2.2,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [-1.7, 0, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ -1.07, 0, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ -1.07,  2.2, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [-1.7,  2.2, -0.15, 1.0], col: [0, 1, 0, 1])]
        
        sideScreenOneVertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count, options: [])
        sideScreenOneIndexBuffer = device!.makeBuffer(bytes: indexDataArray(), length: MemoryLayout<UInt16>.size * indexDataArray().count , options: [])
        sideScreenOneUniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    
    func indexDataArray() -> [UInt16]
    {
        let indexData: [UInt16] = [0, 1, 2, 2, 3, 0,   // front
            1, 5, 6, 6, 2, 1,   // right
            3, 2, 6, 6, 7, 3,   // top
            4, 5, 1, 1, 0, 4,   // bottom
            4, 0, 3, 3, 7, 4,   // left
            7, 6, 5, 5, 4, 7]   // back
        
        return indexData
    }

    func createSideScreen2Buffers() {
        let vertexData = [
            Vertex(pos: [1.2, 0,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ 1.7, 0,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ 1.7, 2.2,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [1.2,  2.2,  0.05, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [1.2, 0, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ 1.7, 0, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [ 1.7,  2.2, -0.15, 1.0], col: [0, 1, 0, 1]),
            Vertex(pos: [1.2,  2.2, -0.15, 1.0], col: [0, 1, 0, 1])]
        
        sideScreenTwoVertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count, options: [])
        sideScreenTwoIndexBuffer = device!.makeBuffer(bytes: indexDataArray(), length: MemoryLayout<UInt16>.size * indexDataArray().count , options: [])
        sideScreenTwoUniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    
    func createSensorBuffers() {
        let vertexData = [
            Vertex(pos: [-0.1, 2.2,0.0, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [ 0.1,2.2, 0.0, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [ 0.1,  2.3,  0, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [-0.1,  2.3,  0, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [-0.1, 2.2, -0.1, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [ 0.1, 2.2, -0.1, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [ 0.1, 2.3, -0.1, 1.0], col: [0, 0, 0, 1]),
            Vertex(pos: [-0.1,  2.3, 0, 1.0], col: [0, 0, 0, 1])]
        
        SensorsVertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count, options: [])
        SensorsIndexBuffer = device!.makeBuffer(bytes: indexDataArray(), length: MemoryLayout<UInt16>.size * indexDataArray().count , options: [])
        SensorsUniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    func createVOBbuffers() {
        let vertexData = [
            Vertex(pos: [1, 1.2,0.05, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [ 1.2,1.2, 0.05, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [ 1.2,  1.4,  0.05, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [1,  1.4,  0.05, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [1, 1.2, -0.15, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [ 1.2, 1.2, -0.15, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [ 1.2, 1.4, -0.15, 1.0], col: [1, 1, 0, 1]),
            Vertex(pos: [1,  1.4, -0.15, 1.0], col: [1, 1, 0, 1])]
        
        VOBvertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count, options: [])
        VOBindexBuffer = device!.makeBuffer(bytes: indexDataArray(), length: MemoryLayout<UInt16>.size * indexDataArray().count , options: [])
        VOBuniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
    }
    func createPipeline() {
//        let input: String?
        let library: MTLLibrary
        let vert_func: MTLFunction
        let frag_func: MTLFunction
        do {
            library = device!.makeDefaultLibrary()!
            vert_func = library.makeFunction(name: "vertex_func")!
            frag_func = library.makeFunction(name: "fragment_func")!
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vert_func
            rpld.fragmentFunction = frag_func
            rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
          
            rps = try device!.makeRenderPipelineState(descriptor: rpld)
        } catch let e {
            Swift.print("\(e)")
        }
    }
    
    fileprivate func createPipelineState(){
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        //finds the metal file from the main bundle
        let library = device!.makeDefaultLibrary()!
        
        //give the names of the function to the pipelineDescriptor
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")

        //set the pixel format to match the MetalView's pixel format
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat
        
        //make the pipelinestate using the gpu interface and the pipelineDescriptor
        rps = try! device!.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func registerShaders() {
            device = MTLCreateSystemDefaultDevice()!
        queue = device!.makeCommandQueue()
       
            do {
                let library = device!.makeDefaultLibrary()!
                let kernel = library.makeFunction(name: "compute")!
                cps = try device!.makeComputePipelineState(function: kernel)
            } catch let e {
                Swift.print("\(e)")
            }
        }
    
    fileprivate func createVertexPoints(){
          func rads(forDegree d: Float)->Float32{
              return (Float.pi*d)/180
          }

          let origin = simd_float2(0, 0)

          for i in 0...720 {
              let position : simd_float2 = [cos(rads(forDegree: Float(Float(i)))),sin(rads(forDegree: Float(Float(i))))]
              circleVertices.append(position)
              if (i+1)%2 == 0 {
                  circleVertices.append(origin)
              }
          }
        
        circleVertexBuffer = device!.makeBuffer(bytes: circleVertices, length: circleVertices.count * MemoryLayout<simd_float2>.stride, options: [])!
        circleUniformBuffer = device!.makeBuffer(length: MemoryLayout<matrix_float4x4>.size, options: [])
      }
    
    func update(uniformBuffer: MTLBuffer) {
        let scaled = scalingMatrix(scale: 0.6)
        rotation = 7
        let rotatedY = rotationMatrix(angle: rotation, axis:  SIMD3<Float>(0, 1, 0))
        let rotatedX = rotationMatrix(angle: Float.pi / 4, axis:  SIMD3<Float>(0, 0, 0))
        let modelMatrix = matrix_multiply(matrix_multiply(rotatedX, rotatedY), scaled)
        let cameraPosition = vector_float3(-0.1, -0.5, -3)
        let viewMatrix = translationMatrix(position: cameraPosition)
        let projMatrix = projectionMatrix(near: 0, far: 10, aspect: 1, fovy: 1)
        let modelViewProjectionMatrix = matrix_multiply(projMatrix, matrix_multiply(viewMatrix, modelMatrix))
        let bufferPointer = uniformBuffer.contents()
        var uniforms = Uniforms(modelViewProjectionMatrix: modelViewProjectionMatrix)
        memcpy(bufferPointer, &uniforms, MemoryLayout<Uniforms>.size)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
            update(uniformBuffer: safetyRegionUniformBuffer)
            update(uniformBuffer: sideScreenOneUniformBuffer)
            update(uniformBuffer: sideScreenTwoUniformBuffer)
           update(uniformBuffer: SensorsUniformBuffer)
           //update(uniformBuffer: circleUniformBuffer)
         
        
        renderPassDescriperWithBuffers(vertexBuffer: safetyRegionVertexBuffer, indexBuffer: safetyRegionIndexBuffer, uniformBuffer: safetyRegionUniformBuffer)
        renderPassDescriperWithBuffers(vertexBuffer: sideScreenOneVertexBuffer, indexBuffer: sideScreenOneIndexBuffer, uniformBuffer: sideScreenOneUniformBuffer)
        renderPassDescriperWithBuffers(vertexBuffer: sideScreenTwoVertexBuffer, indexBuffer: sideScreenTwoIndexBuffer, uniformBuffer: sideScreenTwoUniformBuffer)
        renderPassDescriperWithBuffers(vertexBuffer: SensorsVertexBuffer, indexBuffer: SensorsIndexBuffer, uniformBuffer: SensorsUniformBuffer)
//        circleBuffer(vertexBuffer: circleVertexBuffer)
        circleDrawable(in: self)
       
    }
    
    func renderPassDescriperWithBuffers(vertexBuffer: MTLBuffer, indexBuffer: MTLBuffer, uniformBuffer: MTLBuffer){
        if let rpd = currentRenderPassDescriptor,
           let drawable = currentDrawable
            {
            
            
            rpd.colorAttachments[0].loadAction = .load
            rpd.colorAttachments[0].storeAction = .store
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0,0,0, 0.0)
            
            
            let commandBuffer = queue!.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            
            commandEncoder?.setRenderPipelineState(rps)
            commandEncoder?.setFrontFacing(.counterClockwise)
            commandEncoder?.setCullMode(.back)
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
            commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indexBuffer.length / MemoryLayout<UInt16>.size, indexType: MTLIndexType.uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
            commandBuffer?.waitUntilCompleted()
        }
    }
    
    func circleBuffer(vertexBuffer: MTLBuffer){
        
        guard let commandBuffer = queue!.makeCommandBuffer() else {return}
        //Creating the interface for the pipeline
        guard let renderDescriptor = currentRenderPassDescriptor else {return}
        //Setting a "background color"
        
        guard let drawable = currentDrawable else {return}
      //  renderDescriptor.colorAttachments[0].loadAction = .load
        renderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 1, 1)
        
        //Creating the command encoder, or the "inside" of the pipeline
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor) else {return}
        
        // We tell it what render pipeline to use
        renderEncoder.setRenderPipelineState(rps)
        
        /*********** Encoding the commands **************/
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 1081)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func circleDrawable(in view:MTKView){
        
        if let drawable = view.currentDrawable,
                   let commandBuffer = queue.makeCommandBuffer(),
                   let commandEncoder = commandBuffer.makeComputeCommandEncoder() {
                    commandEncoder.setComputePipelineState(cps)
                    commandEncoder.setTexture(drawable.texture, index: 0)
                    let threadGroupCount = MTLSizeMake(8, 8, 1)
                    let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width, drawable.texture.height / threadGroupCount.height, 1)
                    commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
                    commandEncoder.endEncoding()
                    commandBuffer.present(drawable)
                    commandBuffer.commit()
                }
    }
    
}
