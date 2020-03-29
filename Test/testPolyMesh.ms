/*! © 2020 imaoki | MIT License | https://github.com/imaoki */
struct TestStruct (
  public CurrentDir,
  public CurrentFile,
  public ParentDir,

  private actual,
  private expected,
  private testDef,
  private testObj,

  private meshNode,
  private polyNode,

  private meshPM,
  private polyPM,

  private polyMod,
  private polyModNode,
  private polyModPM,

  public fn Setup = (
    setCommandPanelTaskMode #Create
    this.createTestObjects()
    ok
  ),

  public fn SetupStruct = (
    -- this.createTestObjects()

    this.testDef = ::unitTest.Import (this.ParentDir + @"\PolyMesh.ms")
    -- this.testObj = this.testDef()

    ::unitTest.InvokeTest()
    ok
  ),

  public fn Teardown = (
    this.deleteTestObjects()
    ok
  ),

  public fn TeardownStruct = (
    -- this.testObj.Dump()
    ok
  ),

  public fn Test00Type = (
    -- Editable_Mesh
    this.actual = ::TestValue (this.meshPM.GetType())
    this.expected = ::TestValue 1
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly
    this.actual = ::TestValue (this.polyPM.GetType())
    this.expected = ::TestValue 2
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly
    this.actual = ::TestValue (this.polyModPM.GetType())
    this.expected = ::TestValue 3
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test01CalculateEdgeAngle = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.CalculateEdgeAngle #{1..3})
    this.expected = ::TestValue undefined
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.CalculateEdgeAngle #{1, 2})
    this.expected = ::TestValue 90
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.CalculateEdgeAngle #{1, 3})
    this.expected = ::TestValue 45
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.CalculateEdgeAngle #{1..3})
    this.expected = ::TestValue undefined
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.CalculateEdgeAngle #{1, 2})
    this.expected = ::TestValue 90
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.CalculateEdgeAngle #{1, 3})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.CalculateEdgeAngle #{1..3})
    this.expected = ::TestValue undefined
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.CalculateEdgeAngle #{1, 2})
    this.expected = ::TestValue 90
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.CalculateEdgeAngle #{1, 3})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test02CalculateFaceAngle = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.CalculateFaceAngle #{1..3})
    this.expected = ::TestValue undefined
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.CalculateFaceAngle #{1, 2})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.CalculateFaceAngle #{1, 3})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.CalculateFaceAngle #{1..3})
    this.expected = ::TestValue undefined
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.CalculateFaceAngle #{1, 2})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.CalculateFaceAngle #{1, 3})
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test03DeleteEdges = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.DeleteEdges #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.DeleteEdges #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.DeleteEdges #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.DeleteEdges #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.DeleteEdges #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.DeleteEdges #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test04DeleteFaces = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.DeleteFaces #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.DeleteFaces #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.DeleteFaces #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.DeleteFaces #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.DeleteFaces #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.DeleteFaces #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test05DeleteVertices = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.DeleteVertices #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.DeleteVertices #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.DeleteVertices #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.DeleteVertices #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.DeleteVertices #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.DeleteVertices #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test06GetEdgeCount = (
    -- Editable_Mesh
    this.actual = ::TestValue (this.meshPM.GetEdgeCount())
    this.expected = ::TestValue 66
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly
    this.actual = ::TestValue (this.polyPM.GetEdgeCount())
    this.expected = ::TestValue 34
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly
    this.actual = ::TestValue (this.polyModPM.GetEdgeCount())
    this.expected = ::TestValue 34
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test07GetEdgesFaces = (
    -- Editable_Mesh
    this.actual = ::TestValue (this.meshPM.GetEdgesFaces #{2})
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly
    this.actual = ::TestValue (this.polyPM.GetEdgesFaces #{3})
    this.expected = ::TestValue #{1..2}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly
    this.actual = ::TestValue (this.polyModPM.GetEdgesFaces #{3})
    this.expected = ::TestValue #{1..2}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test08GetEdgesNormals = (
    ok
  ),

  public fn Test09GetEdgesPositions = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetEdgesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetEdgesPositions #{1})
    this.expected = ::TestValue #([-7.5, -10, 0])
    assert (this.actual.Equals this.expected == true)
    -- 移動
    this.meshPM.Node[3][1].Value = [0, 0, 10]
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetEdgesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([-7.5, -10, 10])
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetEdgesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetEdgesPositions #{1})
    this.expected = ::TestValue #([-10, -7.5, 0])
    assert (this.actual.Equals this.expected == true)
    -- 移動
    this.polyPM.Node[3][1].Value = [0, 0, 10]
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetEdgesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([-10, -7.5, 10])
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetEdgesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetEdgesPositions #{1})
    this.expected = ::TestValue #([-10, -7.5, 0])
    assert (this.actual.Equals this.expected == true)
    -- 移動
    this.polyModPM.Node[3][1].Value = [0, 0, 10]
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetEdgesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([-10, -7.5, 10])
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test10GetEdgesVectors = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetEdgesVectors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetEdgesVectors #{1})
    this.expected = ::TestValue #([1, 0, 0])
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetEdgesVectors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetEdgesVectors #{1})
    this.expected = ::TestValue #([0, 1, 0])
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetEdgesVectors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetEdgesVectors #{1})
    this.expected = ::TestValue #([0, 1, 0])
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test11GetEdgesVertices = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetEdgesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetEdgesVertices #{1})
    this.expected = ::TestValue #{1, 2}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetEdgesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetEdgesVertices #{1})
    this.expected = ::TestValue #{1, 6}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetEdgesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetEdgesVertices #{1})
    this.expected = ::TestValue #{1, 6}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test12GetFaceCount = (
    -- Editable_Mesh
    this.actual = ::TestValue (this.meshPM.GetFaceCount())
    this.expected = ::TestValue 22
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly
    this.actual = ::TestValue (this.polyPM.GetFaceCount())
    this.expected = ::TestValue 11
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly
    this.actual = ::TestValue (this.polyModPM.GetFaceCount())
    this.expected = ::TestValue 11
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test13GetFacesEdges = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesEdges #{1})
    this.expected = ::TestValue #{1, 2, 3}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesEdges #{1})
    this.expected = ::TestValue #{1, 2, 3, 4}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetFacesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetFacesEdges #{1})
    this.expected = ::TestValue #{1, 2, 3, 4}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test14GetFacesElements = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesElements #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesElements #{1})
    this.expected = ::TestValue #{1..4, 7..10}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesElements #{21} fence:#{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesElements #{21} fence:#{13, 20})
    this.expected = ::TestValue #{13..14, 19..22}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesElements #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesElements #{1})
    this.expected = ::TestValue #{1..2, 4..5}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesElements #{11} fence:#{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesElements #{11} fence:#{10, 7})
    this.expected = ::TestValue #{7, 10..11}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetFacesElements #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetFacesElements #{1})
    this.expected = ::TestValue #{1..2, 4..5}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly非対応
    this.actual = ::TestValue (this.polyModPM.GetFacesElements #{11} fence:#{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly非対応
    this.actual = ::TestValue (this.polyModPM.GetFacesElements #{11} fence:#{10, 7})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test15GetFacesNormals = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesNormals #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesNormals #{1})
    this.expected = ::TestValue #([0, 0, 1])
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.meshPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesNormals #{1})
    this.expected = ::TestValue #([0, 0, 1])
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesNormals #{1} inWorld:true)
    this.expected = ::TestValue #([1, 0, 0])
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesNormals #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesNormals #{1})
    this.expected = ::TestValue #([0, 0, 1])
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.polyPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesNormals #{1})
    this.expected = ::TestValue #([0, 0, 1])
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesNormals #{1} inWorld:true)
    this.expected = ::TestValue #([1, 0, 0])
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test16GetFacesPositions = (
    local meshPos1 = ([-10, -10, 0] + [-5, -10, 0] + [-5, -5, 0]) / 3.0
    local meshPos2 = meshPos1 + [0, 0, 10]

    local polyPos1 = [-4.4375, -4.4375, 0]
    local polyPos2 = polyPos1 + [0, 0, 10]

    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesPositions #{1})
    this.expected = ::TestValue #(meshPos1)
    assert (this.actual.Equals this.expected == true)
    -- 移動
    this.meshPM.Node[3][1].Value = [0, 0, 10]
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesPositions #{1} inWorld:true)
    this.expected = ::TestValue #(meshPos2)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesPositions #{5})
    this.expected = ::TestValue #(polyPos1)
    assert (this.actual.Equals this.expected == true)
    -- 移動
    this.polyPM.Node[3][1].Value = [0, 0, 10]
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesPositions #{5} inWorld:true)
    this.expected = ::TestValue #(polyPos2)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test17GetFacesVertices = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetFacesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetFacesVertices #{1})
    this.expected = ::TestValue #{1, 2, 7}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetFacesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetFacesVertices #{1})
    this.expected = ::TestValue #{1, 2, 6, 7}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetFacesVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetFacesVertices #{1})
    this.expected = ::TestValue #{1, 2, 6, 7}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test18GetMapVertexCount = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetMapVertexCount -3)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetMapVertexCount 2)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetMapVertexCount -2)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetMapVertexCount 1)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetMapVertexCount -3)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetMapVertexCount 2)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetMapVertexCount -2)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetMapVertexCount 1)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetMapVertexCount -3)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetMapVertexCount 2)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetMapVertexCount -2)
    this.expected = ::TestValue 0
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetMapVertexCount 0)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetMapVertexCount 1)
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test19GetMaterialIds = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetMaterialIds #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetMaterialIds #{1, 3, 5})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetMaterialIds #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetMaterialIds #{1, 2, 3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetMaterialIds #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetMaterialIds #{1, 2, 3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test20GetSelectedEdges = (
    -- エッジ選択
    setEdgeSelection this.meshPM.Node.BaseObject.Mesh #{1}
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetSelectedEdges())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- エッジ選択
    PolyOp.SetEdgeSelection this.polyPM.Node.BaseObject #{1}
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetSelectedEdges())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- エッジ選択
    this.setSubObjectLevel this.polyModPM.Modifier 2
    this.polyModPM.Modifier.Select #Edge #{1}
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetSelectedEdges())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test21GetSelectedFaces = (
    -- 面選択
    setFaceSelection this.meshPM.Node.BaseObject.Mesh #{1}
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetSelectedFaces())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- 面選択
    PolyOp.SetFaceSelection this.polyPM.Node.BaseObject #{1}
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetSelectedFaces())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- 面選択
    this.setSubObjectLevel this.polyModPM.Modifier 4
    this.polyModPM.Modifier.Select #Face #{1}
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetSelectedFaces())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test22GetSelectedVertices = (
    -- 頂点選択
    setVertSelection this.meshPM.Node.BaseObject.Mesh #{1}
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetSelectedVertices())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- 頂点選択
    PolyOp.SetVertSelection this.polyPM.Node.BaseObject #{1}
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetSelectedVertices())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)

    -- 頂点選択
    this.setSubObjectLevel this.polyModPM.Modifier 1
    this.polyModPM.Modifier.Select #Vertex #{1}
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetSelectedVertices())
    this.expected = ::TestValue #{1}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test23GetSmoothingGroups = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetSmoothingGroups #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetSmoothingGroups #{1, 19})
    this.expected = ::TestValue #{1, 3, 4}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetSmoothingGroups #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetSmoothingGroups #{1, 10})
    this.expected = ::TestValue #{1, 3, 4}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetSmoothingGroups #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetSmoothingGroups #{1, 10})
    this.expected = ::TestValue #{1, 3, 4}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test24GetVertexCount = (
    -- Editable_Mesh
    this.actual = ::TestValue (this.meshPM.GetVertexCount())
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly
    this.actual = ::TestValue (this.polyPM.GetVertexCount())
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly
    this.actual = ::TestValue (this.polyModPM.GetVertexCount())
    this.expected = ::TestValue 25
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test25GetVerticesAlphas = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetVerticesAlphas #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesAlphas #{1, 25})
    this.expected = ::TestValue #(0.5, 0.25)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetVerticesAlphas #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesAlphas #{1, 25})
    this.expected = ::TestValue #(0.5, 0.25)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test26GetVerticesColors = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetVerticesColors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesColors #{1, 25})
    this.expected = ::TestValue #(Color 255 0 0, Color 0 0 255)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetVerticesColors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesColors #{1, 25})
    this.expected = ::TestValue #(Color 255 0 0, Color 0 0 255)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetVerticesColors #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetVerticesColors #{1, 25})
    this.expected = ::TestValue #(Color 255 0 0, Color 0 0 255)
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test27GetVerticesEdges = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetVerticesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesEdges #{1})
    this.expected = ::TestValue #{1, 3, 5, 6}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetVerticesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesEdges #{1})
    this.expected = ::TestValue #{1, 4}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetVerticesEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetVerticesEdges #{1})
    this.expected = ::TestValue #{1, 4}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test28GetVerticesFaces = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetVerticesFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesFaces #{2})
    this.expected = ::TestValue #{1, 3, 4}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetVerticesFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesFaces #{2})
    this.expected = ::TestValue #{1, 2}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetVerticesFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetVerticesFaces #{2})
    this.expected = ::TestValue #{1, 2}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test29GetVerticesNormals = (
    ok
  ),

  public fn Test30GetVerticesPositions = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.GetVerticesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.meshPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesPositions #{1})
    this.expected = ::TestValue #([-10.0, -10.0, 0.0])
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.GetVerticesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([0.0, -10.0, 10.0])
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.GetVerticesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.polyPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesPositions #{1})
    this.expected = ::TestValue #([-10.0, -10.0, 0.0])
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.GetVerticesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([0.0, -10.0, 10.0])
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.GetVerticesPositions #{100})
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.polyModPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetVerticesPositions #{1})
    this.expected = ::TestValue #([-10.0, -10.0, 0.0])
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.GetVerticesPositions #{1} inWorld:true)
    this.expected = ::TestValue #([0.0, -10.0, 10.0])
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test31RemoveEdges = (
    -- Editable_Mesh非対応
    this.actual = ::TestValue (this.meshPM.RemoveEdges #{1})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.RemoveEdges #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly失敗（境界エッジ）
    this.actual = ::TestValue (this.polyPM.RemoveEdges #{1})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.RemoveEdges #{2})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.RemoveEdges #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly失敗（境界エッジ）
    this.actual = ::TestValue (this.polyModPM.RemoveEdges #{1})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.RemoveEdges #{2})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test32RemoveVertices = (
    -- Editable_Mesh非対応
    this.actual = ::TestValue (this.meshPM.RemoveVertices #{1})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.RemoveVertices #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.RemoveVertices #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.RemoveVertices #{100})
    this.expected = ::TestValue false
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.RemoveVertices #{1})
    this.expected = ::TestValue true
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test33SelectEdges = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SelectEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SelectEdges #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SelectEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SelectEdges #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SelectEdges #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SelectEdges #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test34SelectFaces = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SelectFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SelectFaces #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SelectFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SelectFaces #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SelectFaces #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SelectFaces #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test35SelectVertices = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SelectVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SelectVertices #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SelectVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SelectVertices #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SelectVertices #{100})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SelectVertices #{1..3})
    this.expected = ::TestValue #{1..3}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test36SetMaterialIds = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SetMaterialId #{100} 1)
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetMaterialId #{1..4} 4)
    this.expected = ::TestValue #{4}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SetMaterialId #{100} 1)
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetMaterialId #{1..2} 4)
    this.expected = ::TestValue #{4}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SetMaterialId #{100} 1)
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SetMaterialId #{1..2} 4)
    this.expected = ::TestValue #{4}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test37SetSmoothingGroups = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SetSmoothingGroups #{100} #{5, 6})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetSmoothingGroups #{1..4} #{5, 6})
    this.expected = ::TestValue #{5, 6}
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SetSmoothingGroups #{100} #{5, 6})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetSmoothingGroups #{1..2} #{5, 6})
    this.expected = ::TestValue #{5, 6}
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SetSmoothingGroups #{100} #{5, 6})
    this.expected = ::TestValue #{}
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SetSmoothingGroups #{1..2} #{5, 6})
    this.expected = ::TestValue #{5, 6}
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  public fn Test38SetVerticesAlphas = (
    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SetVerticesAlphas #{100} 0.75)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetVerticesAlphas #{1, 25} 0.75)
    this.expected = ::TestValue #(0.75, 0.75)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SetVerticesAlphas #{100} 0.75)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetVerticesAlphas #{1, 25} 0.75)
    this.expected = ::TestValue #(0.75, 0.75)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test39SetVerticesColors = (
    local col = Color 0 255 0

    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SetVerticesColors #{100} col)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetVerticesColors #{1, 25} col)
    this.expected = ::TestValue #(col, col)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SetVerticesColors #{100} col)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetVerticesColors #{1, 25} col)
    this.expected = ::TestValue #(col, col)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly非対応
    ok
  ),

  public fn Test40SetVerticesNormals = (
    ok
  ),

  public fn Test41SetVerticesPosition = (
    local pos = [10, 10, 10]

    -- Editable_Mesh失敗
    this.actual = ::TestValue (this.meshPM.SetVerticesPosition #{100} pos)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetVerticesPosition #{1} pos)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.meshPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Mesh成功
    this.actual = ::TestValue (this.meshPM.SetVerticesPosition #{1} pos inWorld:true)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)

    -- Editable_Poly失敗
    this.actual = ::TestValue (this.polyPM.SetVerticesPosition #{100} pos)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetVerticesPosition #{1} pos)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.polyPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Editable_Poly成功
    this.actual = ::TestValue (this.polyPM.SetVerticesPosition #{1} pos inWorld:true)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)

    -- Edit_Poly失敗
    this.actual = ::TestValue (this.polyModPM.SetVerticesPosition #{100} pos)
    this.expected = ::TestValue #()
    assert (this.actual.Equals this.expected == true)
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SetVerticesPosition #{1} pos)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)
    -- 回転
    this.polyModPM.Node[3][2].Value = Quat 90 [0, -1, 0]
    -- Edit_Poly成功
    this.actual = ::TestValue (this.polyModPM.SetVerticesPosition #{1} pos inWorld:true)
    this.expected = ::TestValue #(pos)
    assert (this.actual.Equals this.expected == true)
    ok
  ),

  private fn createTestPoly = (
    local n = Plane \
        Length:20 \
        LengthSegs:4 \
        Transform:(Matrix3 1) \
        Width:20 \
        WidthSegs:4

    n[3].Controller = PRS()
    n[3][1].Controller = Position_XYZ()
    n[3][2].Controller = TCB_Rotation()
    n[3][3].Controller = Bezier_Scale()

    convertTo n Editable_Poly
    PolyOp.SetFaceMatId n.BaseObject #{1, 16} 1
    PolyOp.SetFaceMatId n.BaseObject #{2, 5..6} 2
    PolyOp.SetFaceMatId n.BaseObject #{4, 8, 12..15} 3

    PolyOp.SetFaceSmoothGroup n.BaseObject #{1..16} 0
    PolyOp.SetFaceSmoothGroup n.BaseObject #{1, 16} (this.intToDWORD 1)
    PolyOp.SetFaceSmoothGroup n.BaseObject #{2, 5..6} (this.intToDWORD 2)
    PolyOp.SetFaceSmoothGroup n.BaseObject #{4, 8, 12..15} (this.intToDWORD 3)
    PolyOp.SetFaceSmoothGroup n.BaseObject #{12, 15} (this.intToDWORD 4) add:true

    PolyOp.SetMapSupport n.BaseObject -2 true
    PolyOp.SetMapSupport n.BaseObject 0 true

    PolyOp.SetMapVert n.BaseObject -2 1 ([1, 1, 1] * 0.5)
    PolyOp.SetMapVert n.BaseObject -2 25 ([1, 1, 1] * 0.25)

    PolyOp.SetMapVert n.BaseObject 0 1 [1.0, 0.0, 0.0]
    PolyOp.SetMapVert n.BaseObject 0 25 [0.0, 0.0, 1.0]

    PolyOp.SetVert n.BaseObject 13 [-4, -4, 0]
    PolyOp.SetVert n.BaseObject 21 [-6.25, 6.25, 1.25]

    PolyOp.DeleteFaces n.BaseObject #{3, 7, 9..11} delIsoVerts:true
    n
  ),

  private fn createTestObjects = (
    this.meshNode = this.createTestPoly()
    this.meshNode.Name = "Mesh"
    this.meshNode.WireColor = Color 0 255 255
    convertTo this.meshNode Editable_Mesh

    this.polyNode = this.createTestPoly()
    this.polyNode.Name = "Poly"
    this.polyNode.WireColor = Color 255 0 255

    this.polyModNode = this.createTestPoly()
    this.polyModNode.Name = "Mod"
    this.polyModNode.WireColor = Color 0 255 0
    this.polyMod = Edit_Poly()
    addModifier this.polyModNode this.polyMod

    -- モディファイアの追加直後にメソッドの呼び出しに失敗する現象の対策
    validModifier this.polyModNode this.polyMod

    this.meshPM = this.testDef Node:this.meshNode
    this.polyPM = this.testDef Node:this.polyNode
    this.polyModPM = this.testDef Modifier:this.polyMod Node:this.polyModNode
    ok
  ),

  private fn deleteTestObjects = (
    if isValidNode this.meshNode do (
      delete this.meshNode
    )
    if isValidNode this.polyNode do (
      delete this.polyNode
    )
    if isValidNode this.polyModNode do (
      delete this.polyModNode
    )

    this.meshNode = undefined
    this.polyNode = undefined

    this.meshPM = undefined
    this.polyPM = undefined

    this.polyMod = undefined
    this.polyModNode = undefined
    this.polyModPM = undefined
    ok
  ),

  private fn intToDWORD num = (
    if 1 <= num and num <= 32 then (
      Bit.Shift 1 (num - 1)
    )
    else (
      0
    )
  ),

  private fn setSubObjectLevel obj level = (
    setCommandPanelTaskMode #Modify
    ModPanel.SetCurrentObject obj
    subObjectLevel = level
    ok
  ),

  on Create do (
    this.CurrentFile = ::unitTest.GetFullPath (getSourceFileName())
    this.CurrentDir = ::unitTest.GetDirectoryName this.CurrentFile
    this.ParentDir = ::unitTest.GetDirectoryName this.CurrentDir
  )
)

::unitTest.Run (::TestStruct())
