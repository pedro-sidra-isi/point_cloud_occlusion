#pragma once

#include "IndexBuffer.h"
#include "VertexArray.h"
#include "VertexBufferLayout.h"
#include "happly.h"
#include "util.h"
#include <GL3/gl3.h>
#include <GL3/gl3w.h>
#include <GLFW/glfw3.h>
#include <cstdlib>
#include <glm/vec3.hpp> // glm::vec3
#include <iostream>
#include <memory>
#include <stdio.h>
#include <vector>

class PlyObject {
public:
  PlyObject(char const *FileName);
  ~PlyObject();

  GLuint numTriangles();
  GLuint numVertices();

  VertexArray VA;
  std::shared_ptr<VertexBuffer> VB;
  std::shared_ptr<IndexBuffer> IB;
  VertexBufferLayout layout;
  std::vector<Vertex> vertex_data;
  std::vector<Material> materials;
  std::vector<VertexIndex> index_data;

private:
  GLuint NumTris;

  void Load(char const *FileName);
};
