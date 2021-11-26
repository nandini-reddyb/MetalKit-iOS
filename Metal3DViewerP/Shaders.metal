

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float4 color;
};
struct VertexOut {
    vector_float4 pos [[position]];
    vector_float4 color;
};
struct Uniforms {
    float4x4 modelViewProjectionMatrix;
};

vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]], constant Uniforms &uniforms [[buffer(1)]], uint vid [[vertex_id]]) {
    float4x4 matrix = uniforms.modelViewProjectionMatrix;
    Vertex in = vertices[vid];
    Vertex out;
    out.position = matrix * float4(in.position);
    out.color = in.color;
    return out;
}

fragment half4 fragment_func(Vertex vert [[stage_in]]) {
    return half4(vert.color);
}

vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]]){
    vector_float2 currentVertex = vertexArray[vid]; //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    VertexOut output;
    
    output.pos = vector_float4(currentVertex.x, currentVertex.y, 0, 1); //populate the output position with the x and y values of our input vertex data
    output.color = vector_float4(1,1,1,1);//set the color
    
    return output;
}

fragment vector_float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}

float dist(float2 point, float2 center, float radius)
{
    return length(point - center) - radius;
}

kernel void compute(texture2d<float, access::write> output [[texture(0)]],
                    uint2 gid [[thread_position_in_grid]])
{
//    int width = output.get_width();
//    int height = output.get_height();
//    float red = float(gid.x) / float(width);
//    float green = float(gid.y) / float(height);
//    float2 uv = float2(gid) / float2(width, height);
//    uv = uv * 2.0 - 1.0;
//    float distToCircle = dist(uv, float2(0), 0.5);
//    float distToCircle2 = dist(uv, float2(-0.1, 0.1), 0.5);
//    bool inside = distToCircle2 < 0;
//    output.write(inside ? float4(0) : float4(1, 0.7, 0, 1) * (1 - distToCircle), gid);
    
    int width = output.get_width() - 10;
    int height = output.get_height() - 10;
    float red = float(gid.x) / float(width);
    float green = float(gid.y) / float(height);

    float2 uv = float2(gid) / float2(width, height);
    uv = uv * 2.0 - 1.0;
    bool inside = length(uv) > 0.5;
    output.write(inside ? float4(0) : float4(red, green, 0, 0), gid);
}
