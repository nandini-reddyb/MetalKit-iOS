import Foundation
import Metal
// a node represents a object to draw , need to provide it with vertices, a device to create buffers & render later
class Node {
  
  let device: MTLDevice
  let name: String
  var vertexCount: Int
  var vertexBuffer: MTLBuffer
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0

    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0
    
//rotation
    //var time:CFTimeInterval = 0.0

  
  init(name: String, vertices: Array<Vertex>, device: MTLDevice){
//go through each vertex and form a single buffer with floats ... [ x,y,z,r,g,b,a , x,y,z,r,g,b,a ,... ]
    var vertexData = Array<Float>()
    for vertex in vertices{
      vertexData += vertex.floatBuffer()
    }
    
    // 
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
    
    // 3
    self.name = name
    self.device = device
    vertexCount = vertices.count
  }
  
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: Matrix4, projectionMatrix: Matrix4, clearColor: MTLClearColor?) {
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
       // MTLClearColorMake(0.1, 0.1, 0.1, 1);
        
    renderPassDescriptor.colorAttachments[0].loadAction = .load
    renderPassDescriptor.colorAttachments[0].storeAction = .store
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    
    let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    renderEncoder?.setRenderPipelineState(pipelineState)
    renderEncoder!.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    
    // converts position and rotation into a model matrix
    let nodeModelMatrix = self.modelMatrix()
        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)

    // create a buffer with shared memory
        let uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2, options: [])

    // get raw pointer from buffer
    let bufferPointer = uniformBuffer?.contents()
    // copy matrix data into buffer
        memcpy(bufferPointer, nodeModelMatrix.raw(), MemoryLayout<Float>.size*Matrix4.numberOfElements())
        memcpy(bufferPointer! + MemoryLayout<Float>.size * Matrix4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())

        

    // pass uniformbuffer(with data copies) to the vertex shader 
    renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

    
        renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
    renderEncoder?.endEncoding()
    
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
  }
  
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
    
    //rotation
//    func updateWithDelta(delta: CFTimeInterval){
//        time += delta
//    }


}
