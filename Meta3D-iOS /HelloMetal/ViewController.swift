
import UIKit
import Metal

@available(iOS 13.0, *)
class ViewController: UIViewController {

  var objectToDraw: Cube!
  var triangletodraw:SideScreen!
  var sidescreen2:SideScreen2!
// var trianglerender:Triangle!
    
   var projectionMatrix: Matrix4!
  
  var device: MTLDevice!
  var metalLayer: CAMetalLayer!
  var pipelineState: MTLRenderPipelineState!
  var commandQueue: MTLCommandQueue!
  var timer: CADisplayLink!
    
    //rotation
   // var lastFrameTimestamp: CFTimeInterval = 0.0

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    device = MTLCreateSystemDefaultDevice()
    
    metalLayer = CAMetalLayer()          // 1
    metalLayer.device = device           // 2
    metalLayer.pixelFormat = .bgra8Unorm // 3
    metalLayer.framebufferOnly = true    // 4
    metalLayer.frame = view.layer.frame  // 5
    view.layer.addSublayer(metalLayer)   // 6
    
    objectToDraw = Cube(device: device)
    triangletodraw = SideScreen(device: device)
    sidescreen2 = SideScreen2(device: device)
  //  trianglerender = Triangle(device: device)
    //moving along 3 axis at once --> translation parameters
//    objectToDraw.positionX = 0.0
//    objectToDraw.positionY =  0.0
//    objectToDraw.positionZ = -2.0
//
//    objectToDraw.rotationZ = Matrix4.degrees(toRad: 45)
//    objectToDraw.scale = 0.5

    
    // 1
    let defaultLibrary = device.makeDefaultLibrary()!
    let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
    let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
    
    // 2
    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    
    // 3
    pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    
    commandQueue = device.makeCommandQueue()
    
   timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
    //rotation
    //timer = CADisplayLink(target: self, selector: #selector(ViewController.newFrame(displayLink:)))

    timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    
    projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.1, farZ: 100.0)

  }
  
  func render() {
    guard let drawable = metalLayer?.nextDrawable() else { return }
    let worldModelMatrix = Matrix4()
    worldModelMatrix.translate(0.0, y: 0.0, z: -8.0)
    worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 30), y: -0.3, z: 0.0)
    objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)
    print("Cube Rendered - middle")
    
    
    worldModelMatrix.translate(1.75, y: -1.4, z: 0.0)
    worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 0), y: 0.0, z: 0.0)
    triangletodraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    print("Side Screen redered -  right")

    worldModelMatrix.translate(-5.0, y: 0, z: 0)
    worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 0), y: 0.0, z: 0.0)
    sidescreen2.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)
    print("sidescreen2 rendered - left")

//    worldModelMatrix.translate(-6.0, y: -3.5, z: 0.0)
//worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 40), y: 0.0, z: 0.0)
//trianglerender.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
//print("Object rendered-3")

  }

    @objc func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
    
    //rotation
    // The display link now calls newFrame() every time the display refreshes.
//    @objc func newFrame(displayLink: CADisplayLink){
//
//      if lastFrameTimestamp == 0.0
//      {
//        lastFrameTimestamp = displayLink.timestamp
//      }
//
//      //
//      let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
//      lastFrameTimestamp = displayLink.timestamp
//
//      // 3
//      gameloop(timeSinceLastUpdate: elapsed)
//    }
//
//    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
//
//      // 4
//      objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
//
//      // 5
//      autoreleasepool {
//        self.render()
//      }
    }

    


