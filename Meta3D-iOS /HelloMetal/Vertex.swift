//this structure stores the position & color of each vertex
struct Vertex{
  
  var x,y,z: Float     // position data
  var r,g,b,a: Float   // color data
  
  //return the the vertex data as an array of floats
  func floatBuffer() -> [Float] {
    return [x,y,z,r,g,b,a]
  }
  
}
