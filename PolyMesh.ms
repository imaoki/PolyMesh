/*! © 2015 imaoki | MIT License | https://github.com/imaoki */
/**
`Editable_Mesh`、`Editable_Poly`、および`Edit_Poly`の操作を共通化するためのラッパー。
*/
struct PolyMesh (
  /** @prop <Edit_Poly>  */
  public Modifier,
  /** @prop <Node> */
  public Node,

  /** @prop <Editable_Mesh|Editable_Poly> */
  private baseObject,

  /** @prop <Name> サブオブジェクトレベルの指定が必要な処理の実行後に状態を復元するために利用する。 */
  private lastCommandPanel = #Create,
  /** @prop <Integer> サブオブジェクトレベルの指定が必要な処理の実行後に状態を復元するために利用する。 */
  private lastSubObjectLevel = 0,

  /**
  @prop <Integer> 操作対象の種類。
  | 値  | 型              |
  | --- | --------------- |
  | `0` | 不明            |
  | `1` | `Editable_Mesh` |
  | `2` | `Editable_Poly` |
  | `3` | `Edit_Poly`     |
  */
  private type = 0,

  /**
  二つのエッジの角度を計算する。
  @param edges <BitArray>
  @return <Float|UndefinedClass>
  */
  public fn CalculateEdgeAngle edges = (
    local result = undefined
    if this.isEdgesInRange edges and edges.NumberSet == 2 do (
      local vectors = this.GetEdgesVectors edges
      result = acos (dot vectors[1] vectors[2])
    )
    result
  ),

  /**
  二つの面の角度を計算する。
  @param faces <BitArray>
  @return <Float|UndefinedClass>
  @remark `Edit_Poly`は非対応。
  */
  public fn CalculateFaceAngle faces = (
    local result = undefined
    if this.isFacesInRange faces and faces.NumberSet == 2 do (
      local vectors = this.GetFacesNormals faces
      result = acos (dot vectors[1] vectors[2])
    )
    result
  ),

  /**
  エッジを削除する。
  @param edges <BitArray>
  @return <BooleanClass>
  @remark 選択は解除される。
  */
  public fn DeleteEdges edges = (
    local result = false
    if this.isEdgesInRange edges do (
      local oldEdgeCount = this.GetEdgeCount()
      case this.type of (
        (1): MeshOp.DeleteEdges this.baseObject edges delIsoVerts:true
        (2): PolyOp.DeleteEdges this.baseObject edges delIsoVerts:true
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 2

          m.SetSelection #Edge #{} node:n
          m.Select #Edge edges node:n

          m.SetOperation #DeleteEdge
          m.Commit()

          this.restoreSubObjectLevel()
        )
        default: ()
      )
      result = this.GetEdgeCount() != oldEdgeCount
    )
    result
  ),

  /**
  面を削除する。
  @param faces <BitArray>
  @return <BooleanClass>
  @remark 選択は解除される。
  */
  public fn DeleteFaces faces = (
    local result = false
    if this.isFacesInRange faces do (
      local oldFaceCount = this.GetFaceCount()
      case this.type of (
        (1): MeshOp.DeleteFaces this.baseObject faces delIsoVerts:true
        (2): PolyOp.DeleteFaces this.baseObject faces delIsoVerts:true
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 4

          m.SetSelection #Face #{} node:n
          m.Select #Face faces node:n

          m.SetOperation #DeleteFace
          m.Commit()

          this.restoreSubObjectLevel()
        )
        default: ()
      )
      result = this.GetFaceCount() != oldFaceCount
    )
    result
  ),

  /**
  頂点を削除する。
  @param vertices <BitArray>
  @return <BooleanClass>
  @remark 選択は解除される。
  */
  public fn DeleteVertices vertices = (
    local result = false
    if this.isVerticesInRange vertices do (
      local oldVertexCount = this.GetVertexCount()
      case this.type of (
        (1): MeshOp.DeleteVerts this.baseObject vertices
        (2): PolyOp.DeleteVerts this.baseObject vertices
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 1

          m.SetSelection #Vertex #{} node:n
          m.Select #Vertex vertices node:n

          m.SetOperation #DeleteVertex
          m.Commit()

          this.restoreSubObjectLevel()
        )
        default: ()
      )
      result = this.GetVertexCount() != oldVertexCount
    )
    result
  ),

  /**
  エッジの数を取得する。
  @return <Integer>
  */
  public fn GetEdgeCount = (
    case this.type of (
      (1): this.baseObject.Mesh.Edges.Count
      (2): PolyOp.GetNumEdges this.baseObject
      (3): this.Modifier.GetNumEdges node:this.Node
      default: 0
    )
  ),

  /**
  エッジを使用する面を取得する。
  @param edges <BitArray>
  @return <BitArray>
  */
  public fn GetEdgesFaces edges = (
    local result = #{}
    if this.isEdgesInRange edges do (
      case this.type of (
        (1): result = MeshOp.GetFacesUsingEdge this.baseObject edges
        (2): result = PolyOp.GetFacesUsingEdge this.baseObject edges
        (3): (
          for i in edges do (
            local index1 = this.Modifier.GetEdgeFace i 1 node:this.Node
            local index2 = this.Modifier.GetEdgeFace i 2 node:this.Node
            if index1 > 0 do (
              result[index1] = true
            )
            if index2 > 0 do (
              result[index2] = true
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  @param edges <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn GetEdgesNormals edges inWorld:false = (
    #()
  ),

  /**
  エッジの中点位置を取得する。
  @param edges <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn GetEdgesPositions edges inWorld:false = (
    local result = #()
    if this.isEdgesInRange edges do (
      result = for i in edges collect (
        local vertices = this.GetEdgesVertices #{i}
        local positions = this.GetVerticesPositions vertices
        local pos = positions[1] + (positions[2] - positions[1]) / 2.0
        if inWorld do (
          pos *= this.Node.Transform
        )
        pos
      )
    )
    result
  ),

  /**
  エッジのベクトルを取得する。
  @param edges <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn GetEdgesVectors edges inWorld:false = (
    local result = #()
    if this.isEdgesInRange edges do (
      result = for i in edges collect (
        local vertices = this.GetEdgesVertices #{i}
        local positions = this.GetVerticesPositions vertices inWorld:inWorld
        normalize (positions[2] - positions[1])
      )
    )
    result
  ),

  /**
  エッジを使用する頂点を取得する。
  @param edges <BitArray>
  @return <BitArray>
  */
  public fn GetEdgesVertices edges = (
    local result = #{}
    if this.isEdgesInRange edges do (
      case this.type of (
        (1): result = MeshOp.GetVertsUsingEdge this.baseObject edges
        (2): result = PolyOp.GetVertsUsingEdge this.baseObject edges
        (3): (
          for i in edges do (
            local index1 = this.Modifier.GetEdgeVertex i 1 node:this.Node
            local index2 = this.Modifier.GetEdgeVertex i 2 node:this.Node
            if index1 > 0 do (
              result[index1] = true
            )
            if index2 > 0 do (
              result[index2] = true
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  面の数を取得する。
  @return <Integer>
  */
  public fn GetFaceCount = (
    case this.type of (
      (1): MeshOp.GetNumFaces this.baseObject
      (2): PolyOp.GetNumFaces this.baseObject
      (3): this.Modifier.GetNumFaces node:this.Node
      default: 0
    )
  ),

  /**
  面を使用するエッジを取得する。
  @param faces <BitArray>
  @return <BitArray>
  */
  public fn GetFacesEdges faces = (
    local result = #{}
    if this.isFacesInRange faces do (
      case this.type of (
        (1): result = MeshOp.GetEdgesUsingFace this.baseObject faces
        (2): result = PolyOp.GetEdgesUsingFace this.baseObject faces
        (3): (
          for i in faces do (
            local degree = this.Modifier.GetFaceDegree i node:this.Node
            for j = 1 to degree do (
              local index = this.Modifier.GetFaceEdge i j node:this.Node
              if index > 0 do (
                result[index] = true
              )
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  面を使用する要素を取得する。
  @param faces <BitArray>
  @param fence: <BitArray> 境界となる面。`Edit_Poly`は非対応。
  @return <BitArray>
  @remark `fence`は要素に含まれる。よって要素とみなす領域の外周を`fence`に指定する。
  */
  public fn GetFacesElements faces fence:#{} = (
    local result = #{}
    if this.isFacesInRange faces and this.isFacesInRange fence do (
      case this.type of (
        (1): (
          result = MeshOp.GetElementsUsingFace \
              this.baseObject faces fence:fence
        )
        (2): (
          result = PolyOp.GetElementsUsingFace \
              this.baseObject faces fence:fence
        )
        (3): (
          if fence.IsEmpty do (
            local m = this.Modifier
            local n = this.Node

            this.setSubObjectLevel 4
            local oldSelection = m.GetSelection #Face node:n

            m.SetSelection #Face #{} node:n
            m.Select #Face faces node:n

            m.ConvertSelection #Face #Element
            result = m.GetSelection #Face node:n

            m.Select #Face oldSelection node:n
            this.restoreSubObjectLevel()
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  @param faces <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  @remark `Edit_Poly`は非対応。
  */
  public fn GetFacesNormals faces inWorld:false = (
    local result = #()
    if this.isFacesInRange faces do (
      case this.type of (
        (1): (
          result = for i in faces collect (
            local normal = getFaceNormal this.baseObject.Mesh i
            if inWorld do (
              normal *= this.Node.Transform
            )
            normal
          )
        )
        (2): (
          result = for i in faces collect (
            local normal = PolyOp.GetFaceNormal this.baseObject i
            if inWorld do (
              normal *= this.Node.Transform
            )
            normal
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  面の中心位置を取得する。
  @param faces <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  @remark `Edit_Poly`は非対応。
  */
  public fn GetFacesPositions faces inWorld:false = (
    local result = #()
    if this.isFacesInRange faces do (
      case this.type of (
        (1): (
          result = for i in faces collect (
            local pos = MeshOp.GetFaceCenter this.baseObject i
            if inWorld do (
              pos *= this.Node.Transform
            )
            pos
          )
        )
        (2): (
          result = for i in faces collect (
            local pos = PolyOp.GetSafeFaceCenter this.baseObject i
            if classOf pos != Point3 do (
              pos = PolyOp.GetFaceCenter this.baseObject i
            )
            if inWorld do (
              pos *= this.Node.Transform
            )
            pos
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  面を使用する頂点を取得する。
  @param faces <BitArray>
  @return <BitArray>
  */
  public fn GetFacesVertices faces = (
    local result = #{}
    if this.isFacesInRange faces do (
      case this.type of (
        (1): result = MeshOp.GetVertsUsingFace this.baseObject faces
        (2): result = PolyOp.GetVertsUsingFace this.baseObject faces
        (3): (
          for i in faces do (
            local degree = this.Modifier.GetFaceDegree i node:this.Node
            for j = 1 to degree do (
              local index = this.Modifier.GetFaceVertex i j node:this.Node
              if index > 0 do (
                result[index] = true
              )
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  マップチャンネルの頂点の数を取得する。
  @param mapChannel <Integer> マップチャンネル。
  | 値   | マップ                   |
  | ---- | ------------------------ |
  | `-2` | ビューポート頂点アルファ |
  | `0`  | 頂点カラー               |
  | `1`  | 既定のテクスチャマップ   |
  @return <Integer>
  */
  public fn GetMapVertexCount mapChannel = (
    local result = 0
    if this.isMapChannelInRange mapChannel do (
      case this.type of (
        (1): (
          MeshOp.SetMapSupport this.baseObject mapChannel true
          if this.isMapChannelActive mapChannel do (
            result = MeshOp.GetNumMapVerts this.baseObject mapChannel
          )
        )
        (2): (
          PolyOp.SetMapSupport this.baseObject mapChannel true
          if this.isMapChannelActive mapChannel do (
            result = PolyOp.GetNumMapVerts this.baseObject mapChannel
          )
        )
        (3): (
          if this.isMapChannelActive mapChannel do (
            result = this.Modifier.GetNumMapVertices mapChannel node:this.Node
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  面のマテリアルIDを取得する。
  @param faces <BitArray>
  @return <BitArray>
  */
  public fn GetMaterialIds faces = (
    local result = #{}
    if this.isFacesInRange faces do (
      case this.type of (
        (1): (
          for i in faces do (
            result[getFaceMatId this.baseObject.Mesh i] = true
          )
        )
        (2): (
          for i in faces do (
            result[PolyOp.GetFaceMatId this.baseObject i] = true
          )
        )
        (3): (
          for i in faces do (
            result[this.Modifier.GetFaceMaterial i node:this.Node] = true
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  選択されたエッジを取得する。
  @return <BitArray>
  */
  public fn GetSelectedEdges = (
    local result = #{}
    case this.type of (
      (1): result = getEdgeSelection this.baseObject.Mesh
      (2): result = PolyOp.GetEdgeSelection this.baseObject
      (3): (
        this.setSubObjectLevel 2
        result = this.Modifier.GetSelection #Edge node:this.Node
        this.restoreSubObjectLevel()
      )
      default: ()
    )
    result
  ),

  /**
  選択された面を取得する。
  @return <BitArray>
  */
  public fn GetSelectedFaces = (
    local result = #{}
    case this.type of (
      (1): result = getFaceSelection this.baseObject.Mesh
      (2): result = PolyOp.GetFaceSelection this.baseObject
      (3): (
        this.setSubObjectLevel 4
        result = this.Modifier.GetSelection #Face node:this.Node
        this.restoreSubObjectLevel()
      )
      default: ()
    )
    result
  ),

  /**
  選択された頂点を取得する。
  @return <BitArray>
  */
  public fn GetSelectedVertices = (
    local result = #{}
    case this.type of (
      (1): result = getVertSelection this.baseObject.Mesh
      (2): result = PolyOp.GetVertSelection this.baseObject
      (3): (
        this.setSubObjectLevel 1
        result = this.Modifier.GetSelection #Vertex node:this.Node
        this.restoreSubObjectLevel()
      )
      default: ()
    )
    result
  ),

  /**
  面のスムージンググループを取得する。
  @param faces <BitArray>
  @return <BitArray>
  */
  public fn GetSmoothingGroups faces = (
    local result = #{}
    if this.isFacesInRange faces do (
      case this.type of (
        (1): (
          for i in faces do (
            local num = getFaceSmoothGroup this.baseObject.Mesh i
            result += this.dwordToIndices num
          )
        )
        (2): (
          for i in faces do (
            local num = PolyOp.GetFaceSmoothGroup this.baseObject i
            result += this.dwordToIndices num
          )
        )
        (3): (
          for i in faces do (
            local num = this.Modifier.GetFaceSmoothingGroups i node:this.Node
            result += this.dwordToIndices num
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  @return <Integer> 操作対象の種類。
  | 値  | 型              |
  | --- | --------------- |
  | `0` | 不明            |
  | `1` | `Editable_Mesh` |
  | `2` | `Editable_Poly` |
  | `3` | `Edit_Poly`     |
  */
  public fn GetType = (
    this.type
  ),

  /**
  頂点の数を取得する。
  @return <Integer>
  */
  public fn GetVertexCount = (
    case this.type of (
      (1): MeshOp.GetNumVerts this.baseObject
      (2): PolyOp.GetNumVerts this.baseObject
      (3): this.Modifier.GetNumVertices node:this.Node
      default: 0
    )
  ),

  /**
  マップ頂点のアルファ値を取得する。
  @param vertices <BitArray>
  @return <Array<Float>>
  @remark `Edit_Poly`は非対応。
  */
  public fn GetVerticesAlphas vertices = (
    local result = #()
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): (
          MeshOp.SetMapSupport this.baseObject -2 true
          if this.isMapChannelActive -2 do (
            result = for i in vertices collect (
              (MeshOp.GetMapVert this.baseObject -2 i).X
            )
          )
        )
        (2): (
          PolyOp.SetMapSupport this.baseObject -2 true
          if this.isMapChannelActive -2 do (
            result = for i in vertices collect (
              (PolyOp.GetMapVert this.baseObject -2 i).X
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  マップ頂点のカラー値を取得する。
  @param vertices <BitArray>
  @return <Array<Color>>
  */
  public fn GetVerticesColors vertices = (
    local result = #()
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): (
          MeshOp.SetMapSupport this.baseObject 0 true
          if this.isMapChannelActive 0 do (
            result = for i in vertices collect (
              ((MeshOp.GetMapVert this.baseObject 0 i) * 255.0) as Color
            )
          )
        )
        (2): (
          PolyOp.SetMapSupport this.baseObject 0 true
          if this.isMapChannelActive 0 do (
            result = for i in vertices collect (
              ((PolyOp.GetMapVert this.baseObject 0 i) * 255.0) as Color
            )
          )
        )
        (3): (
          if this.isMapChannelActive 0 do (
            result = for i in vertices collect (
              ((this.Modifier.GetMapVertex 0 i node:this.Node) * 255.0) as Color
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  頂点を使用するエッジを取得する。
  @param vertices <BitArray>
  @return <BitArray>
  */
  public fn GetVerticesEdges vertices = (
    local result = #{}
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): result = MeshOp.GetEdgesUsingVert this.baseObject vertices
        (2): result = PolyOp.GetEdgesUsingVert this.baseObject vertices
        (3): (
          for i in vertices do (
            local edgeCount = this.Modifier.GetVertexEdgeCount i node:this.Node
            for j = 1 to edgeCount do (
              local index = this.Modifier.GetVertexEdge i j node:this.Node
              if index > 0 do (
                result[index] = true
              )
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  頂点を使用する面を取得する。
  @param vertices <BitArray>
  @return <BitArray>
  */
  public fn GetVerticesFaces vertices = (
    local result = #{}
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): result = MeshOp.GetFacesUsingVert this.baseObject vertices
        (2): result = PolyOp.GetFacesUsingVert this.baseObject vertices
        (3): (
          for i in vertices do (
            local faceCount = this.Modifier.GetVertexFaceCount i node:this.Node
            for j = 1 to faceCount do (
              local index = this.Modifier.GetVertexFace i j node:this.Node
              if index > 0 do (
                result[index] = true
              )
            )
          )
        )
        default: ()
      )
    )
    result
  ),

  /**
  @param vertices <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn GetVerticesNormals vertices inWorld:false = (
    local result = #()
    if this.isVerticesInRange vertices do (
    )
    result
  ),

  /**
  頂点の位置を取得する。
  @param vertices <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn GetVerticesPositions vertices inWorld:false = (
    local result = #()
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): (
          result = for i in vertices collect (
            local pos = MeshOp.GetVert this.baseObject i
            if inWorld do (
              pos *= this.Node.Transform
            )
            pos
          )
        )
        (2): (
          result = for i in vertices collect (
            local pos = PolyOp.GetVert this.baseObject i
            if inWorld do (
              pos *= this.Node.Transform
            )
            pos
          )
        )
        (3): (
          this.setSubObjectLevel 1
          result = for i in vertices collect (
            local pos = this.Modifier.GetVertex i node:this.Node
            if not inWorld do (
              pos *= inverse this.Node.Transform
            )
            pos
          )
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    result
  ),

  /**
  エッジを除去する。
  @param edges <BitArray>
  @return <BooleanClass>
  @remark `Editable_Mesh`は非対応。
  */
  public fn RemoveEdges edges = (
    local result = false
    if this.isEdgesInRange edges do (
      local oldEdgeCount = this.GetEdgeCount()
      case this.type of (
        (2): (
          local oldSelection = this.GetSelectedEdges()
          local newSelection = this.removeIndices oldSelection edges

          this.SelectEdges edges
          this.baseObject.Remove selLevel:#Edge flag:1

          result = this.GetEdgeCount() != oldEdgeCount
          if result then (
            this.SelectEdges newSelection
          )
          else (
            this.SelectEdges oldSelection
          )
        )
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 2
          local oldSelection = m.GetSelection #Edge node:n
          local newSelection = this.removeIndices oldSelection edges

          m.SetSelection #Edge #{} node:n
          m.Select #Edge edges node:n

          m.SetOperation #RemoveEdge
          m.Commit()

          result = this.GetEdgeCount() != oldEdgeCount
          if result then (
            m.Select #Edge newSelection node:n
          )
          else (
            m.Select #Edge oldSelection node:n
          )
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    result
  ),

  /**
  頂点を除去する。
  @param vertices <BitArray>
  @return <BooleanClass>
  @remark `Editable_Mesh`は非対応。
  */
  public fn RemoveVertices vertices = (
    local result = false
    if this.isVerticesInRange vertices do (
      local oldVertexCount = this.GetVertexCount()
      case this.type of (
        (2): (
          local oldSelection = this.GetSelectedVertices()
          local newSelection = this.removeIndices oldSelection vertices

          this.SelectVertices vertices
          this.baseObject.Remove selLevel:#Vertex flag:1

          result = this.GetVertexCount() != oldVertexCount
          if result then (
            this.SelectVertices newSelection
          )
          else (
            this.SelectVertices oldSelection
          )
        )
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 1
          local oldSelection = m.GetSelection #Vertex node:n
          local newSelection = this.removeIndices oldSelection vertices

          m.SetSelection #Vertex #{} node:n
          m.Select #Vertex vertices node:n

          m.SetOperation #RemoveVertex
          m.Commit()

          result = this.GetVertexCount() != oldVertexCount
          if result then (
            m.Select #Vertex newSelection node:n
          )
          else (
            m.Select #Vertex oldSelection node:n
          )
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    result
  ),

  /**
  エッジを選択する。
  @param edges <BitArray>
  @return <BitArray> 選択されたエッジ。
  */
  public fn SelectEdges edges = (
    if this.isEdgesInRange edges do (
      case this.type of (
        (1): setEdgeSelection this.baseObject.Mesh edges
        (2): PolyOp.SetEdgeSelection this.baseObject edges
        (3): (
          this.setSubObjectLevel 2
          this.Modifier.SetSelection #Edge #{} node:this.Node
          this.Modifier.Select #Edge edges node:this.Node
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetSelectedEdges()
  ),

  /**
  面を選択する。
  @param faces <BitArray>
  @return <BitArray> 選択された面。
  */
  public fn SelectFaces faces = (
    if this.isFacesInRange faces do (
      case this.type of (
        (1): setFaceSelection this.baseObject.Mesh faces
        (2): PolyOp.SetFaceSelection this.baseObject faces
        (3): (
          this.setSubObjectLevel 4
          this.Modifier.SetSelection #Face #{} node:this.Node
          this.Modifier.Select #Face faces node:this.Node
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetSelectedFaces()
  ),

  /**
  頂点を選択する。
  @param vertices <BitArray>
  @return <BitArray> 選択された頂点。
  */
  public fn SelectVertices vertices = (
    if this.isVerticesInRange vertices do (
      case this.type of (
        (1): setVertSelection this.baseObject.Mesh vertices
        (2): PolyOp.SetVertSelection this.baseObject vertices
        (3): (
          this.setSubObjectLevel 1
          this.Modifier.SetSelection #Vertex #{} node:this.Node
          this.Modifier.Select #Vertex vertices node:this.Node
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetSelectedVertices()
  ),

  /**
  面のマテリアルIDを設定する。
  @param faces <BitArray>
  @param id <Integer>
  @return <BitArray>
  */
  public fn SetMaterialId faces id = (
    if this.isFacesInRange faces do (
      case this.type of (
        (1): (
          for i in faces do (
            setFaceMatId this.baseObject.Mesh i id
          )
        )
        (2): PolyOp.SetFaceMatId this.baseObject faces id
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 4
          local oldSelection = m.GetSelection #Face node:n

          m.SetSelection #Face #{} node:n
          m.Select #Face faces node:n

          m.SetOperation #SetMaterial
          m.MaterialIdToSet = id - 1
          m.Commit()

          m.Select #Face oldSelection node:n
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetMaterialIds faces
  ),

  /**
  面のスムージンググループを設定する。
  @param faces <BitArray>
  @param groups <BitArray> `1`から`32`の範囲で指定する。
  @return <BitArray>
  */
  public fn SetSmoothingGroups faces groups = (
    if this.isFacesInRange faces do (
      local groupNumber = this.indicesToDWORD groups
      case this.type of (
        (1): (
          for i in faces do (
            setFaceSmoothGroup this.baseObject.Mesh i groupNumber
          )
        )
        (2): PolyOp.SetFaceSmoothGroup this.baseObject faces groupNumber
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 4
          local oldSelection = m.GetSelection #Face node:n

          m.SetSelection #Face #{} node:n
          m.Select #Face faces node:n

          m.SetOperation #SetSmooth
          m.SmoothingGroupsToClear = this.indicesToDWORD #{1..32}
          m.SmoothingGroupsToSet = groupNumber
          m.Commit()

          m.Select #Face oldSelection node:n
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetSmoothingGroups faces
  ),

  /**
  マップ頂点のアルファ値を設定する。
  @param vertices <BitArray>
  @param alphaValue <Float>
  @return <Array<Float>>
  @remark `Edit_Poly`は非対応。
  */
  public fn SetVerticesAlphas vertices alphaValue = (
    if this.isVerticesInRange vertices do (
      local uvw = [1.0, 1.0, 1.0] * alphaValue
      case this.type of (
        (1): (
          MeshOp.SetMapSupport this.baseObject -2 true
          if this.isMapChannelActive -2 do (
            for i in vertices do (
              MeshOp.SetMapVert this.baseObject -2 i uvw
            )
          )
        )
        (2): (
          PolyOp.SetMapSupport this.baseObject -2 true
          if this.isMapChannelActive -2 do (
            for i in vertices do (
              PolyOp.SetMapVert this.baseObject -2 i uvw
            )
          )
        )
        default: ()
      )
    )
    this.GetVerticesAlphas vertices
  ),

  /**
  マップ頂点のカラー値を設定する。
  @param vertices <BitArray>
  @return <Array<Color>>
  @remark `Edit_Poly`は非対応。
  */
  public fn SetVerticesColors vertices col = (
    if this.isVerticesInRange vertices do (
      local uvw = (col as Point3) / 255.0
      case this.type of (
        (1): (
          MeshOp.SetMapSupport this.baseObject 0 true
          if this.isMapChannelActive 0 do (
            for i in vertices do (
              MeshOp.SetMapVert this.baseObject 0 i uvw
            )
          )
        )
        (2): (
          PolyOp.SetMapSupport this.baseObject 0 true
          if this.isMapChannelActive 0 do (
            for i in vertices do (
              PolyOp.SetMapVert this.baseObject 0 i uvw
            )
          )
        )
        default: ()
      )
    )
    this.GetVerticesColors vertices
  ),

  /**
  @param vertices <BitArray>
  @param normals <BitArray>
  @return <BooleanClass>
  */
  public fn SetVerticesNormals vertices normals = (
    false
  ),

  /**
  頂点の位置を設定する。
  @param vertices <BitArray>
  @param inWorld: <BooleanClass> ワールド座標系の場合は`true`、ローカル座標系の場合は`false`。既定値は`false`。
  @return <Array<Point3>>
  */
  public fn SetVerticesPosition vertices pos inWorld:false = (
    if this.isVerticesInRange vertices do (
      if inWorld and this.type != 3 do (
        pos *= inverse this.Node.Transform
      )
      case this.type of (
        (1): MeshOp.SetVert this.baseObject vertices pos
        (2): PolyOp.SetVert this.baseObject vertices pos
        (3): (
          local m = this.Modifier
          local n = this.Node

          this.setSubObjectLevel 1
          local oldSelection = m.GetSelection #Vertex node:n

          m.SetOperation #Transform
          for i in vertices do (
            m.SetSelection #Vertex #{} node:n
            m.Select #Vertex #{i} node:n

            local oldPos = m.GetVertex i node:n
            if not inWorld do (
              oldPos *= inverse n.Transform
            )
            local amount = pos - oldPos
            m.MoveSelection amount
          )
          m.Commit()

          m.Select #Vertex oldSelection node:n
          this.restoreSubObjectLevel()
        )
        default: ()
      )
    )
    this.GetVerticesPositions vertices inWorld:inWorld
  ),

  /**
  32ビット整数を要素数32の`BitArray`に変換する。
  @param bitNumber <Integer>
  @return <BitArray>
  */
  private fn dwordToIndices bitNumber = (
    local indices = #{}
    for i = 1 to 32 do (
      indices[i] = Bit.Get bitNumber i
    )
    indices
  ),

  /**
  `1`から`32`までの整数を32ビット整数に変換する。
  @param index <Integer>
  @param addition: <Integer> 既存の32ビット整数に追加する場合は指定する。
  @return <Integer>
  */
  private fn indexToDWORD index addition:0 = (
    if 1 <= index and index <= 32 then (
      Bit.Shift 1 (index - 1) + addition
    )
    else (
      addition
    )
  ),

  /**
  `1`から`32`までの整数配列を32ビット整数に変換する。
  @param indices <BitArray>
  @return <Integer>
  */
  private fn indicesToDWORD indices = (
    local bitNumber = 0
    for i in indices do (
      bitNumber = this.indexToDWORD i addition:bitNumber
    )
    bitNumber
  ),

  /**
  @param edges <BitArray>
  @return <BooleanClass>
  */
  private fn isEdgesInRange edges = (
    edges.IsEmpty or amax (edges as Array) <= this.GetEdgeCount()
  ),

  /**
  @param faces <BitArray>
  @return <BooleanClass>
  */
  private fn isFacesInRange faces = (
    faces.IsEmpty or amax (faces as Array) <= this.GetFaceCount()
  ),

  /**
  @param mapChannel <Integer>
  @return <BooleanClass>
  */
  private fn isMapChannelActive mapChannel = (
    case this.type of (
      (1): MeshOp.GetMapSupport this.baseObject mapChannel
      (2): PolyOp.GetMapSupport this.baseObject mapChannel
      (3): this.Modifier.GetMapChannelActive mapChannel node:this.Node
      default: false
    )
  ),

  /**
  @param mapChannel <Integer>
  @return <BooleanClass>
  */
  private fn isMapChannelInRange mapChannel = (
    -2 <= mapChannel and mapChannel <= 1
  ),

  /**
  @param vertices <BitArray>
  @return <BooleanClass>
  */
  private fn isVerticesInRange vertices = (
    vertices.IsEmpty or amax (vertices as Array) <= this.GetVertexCount()
  ),

  /**
  インデックス配列から任意のインデックスを削除し、欠番が生じないようインデックスを補正する。
  @param indices <BitArray>
  @param removeIndices <BitArray>
  @return <BitArray>
  */
  private fn removeIndices indices removeIndices = (
    indices = indices as Array
    removeIndices = removeIndices as Array
    for i = removeIndices.Count to 1 by -1 do (
      for j = indices.Count to 1 by -1 \
          while indices[j] >= removeIndices[i] do (
        if indices[j] == removeIndices[i] then (
          deleteItem indices j
        )
        else (
          indices[j] -= 1
        )
      )
    )
    indices as BitArray
  ),

  /**
  サブオブジェクトレベルを復元する。
  @return <OkClass>
  */
  private fn restoreSubObjectLevel = (
    subObjectLevel = this.lastSubObjectLevel
    setCommandPanelTaskMode this.lastCommandPanel
    ok
  ),

  /**
  サブオブジェクトレベルを設定する。
  @param level <Integer>
  @return <BooleanClass>
  */
  private fn setSubObjectLevel level = (
    this.lastCommandPanel = getCommandPanelTaskMode()
    this.lastSubObjectLevel = subObjectLevel
    if classOf this.lastSubObjectLevel != Integer do (
      this.lastSubObjectLevel = 0
    )

    setCommandPanelTaskMode #Modify
    if validModifier this.Node this.Modifier \
        and findItem this.Node.Modifiers this.Modifier > 0 do (
      ModPanel.SetCurrentObject this.Modifier
    )
    subObjectLevel = level

    subObjectLevel == level
  ),

  on Create do (
    if isValidNode this.Node do (
      this.baseObject = this.Node.BaseObject
    )
    this.type = case classOf this.Modifier of (
      (Edit_Poly): 3
      default: (
        case classOf this.baseObject of (
          (Editable_Mesh): 1
          (Editable_Poly): 2
          default: 0
        )
      )
    )
  )
)
