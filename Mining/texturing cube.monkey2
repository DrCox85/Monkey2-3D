#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
 
Using std..
Using mojo..
Using mojo3d..
 
Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _model:Model

	Field _rectCanvas:Canvas
	Field _rectImage:Image	
	
	Method New()
		
		'get scene
		'
		_scene=Scene.GetCurrent()
 
		'create camera
		'
		_camera=New Camera
		_camera.Near=.1
		_camera.Far=100
		_camera.Move( 0,0,-5 )
		
		'create light
		'
		_light=New Light
		_light.RotateX( 90 )	'aim directional light downwards - 90 degrees.
		
		
		local mesh:=createcube()
		'create model for the mesh
		'
'		_model = New Model()
'		_model.Mesh=mesh
'		_model.Material=New PbrMaterial( Color.Red )
''		_model.Material.CullMode=CullMode.None

		_model = New Model()
		_model.Mesh=mesh
		_model.Materials = _model.Materials.Resize(mesh.NumMaterials)	

	 	Local sm:= New PbrMaterial()
		
		_rectImage=New Image( 256, 256 )
	 
		_rectCanvas=New Canvas( _rectImage )
	
		sm.ColorTexture = _rectImage.Texture
	 	sm.ColorTexture.Flags = TextureFlags.FilterMipmap	
		'sm.CullMode=CullMode.None
	 
 
		_model.Materials[mesh.NumMaterials - 1] = sm		
 
	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		RenderTexture()
		controls()
		'_model.RotateY( 1 )		
		'_model.RotateZ( -1 )
		_scene.Update()
		_scene.Render( canvas,_camera )
 		 		
		canvas.DrawText( "cursors and wasd - Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method


	Method createcube:Mesh()
		
		'create cube mesh
		'
		Local vertices:=New Vertex3f[24]
		'front
		vertices[0].position=New Vec3f( -1, 1,-1 )'left front top
		vertices[1].position=New Vec3f(  1, 1,-1 )'right front top
		vertices[2].position=New Vec3f(  1,-1,-1 )'right front bottom
		vertices[3].position=New Vec3f( -1,-1,-1 )'left front bottom
		'back
		vertices[4].position=New Vec3f(  1, 1, 1 )'right back top
		vertices[5].position=New Vec3f( -1, 1, 1 )'left back top
 		vertices[6].position=New Vec3f( -1,-1, 1 )'left back bottom
 		vertices[7].position=New Vec3f(  1, -1, 1 )'right back bottom
		'right
		vertices[8].position=New Vec3f(  1, 1, -1 )'right front top
		vertices[9].position=New Vec3f(  1, 1, 1 )'right back top
 		vertices[10].position=New Vec3f( 1,-1, 1 )'right back bottom
 		vertices[11].position=New Vec3f( 1,-1, -1 )'right front bottom
		'left
		vertices[12].position=New Vec3f( -1, 1, 1 )'left back top
		vertices[13].position=New Vec3f( -1, 1,-1 )'left front top
 		vertices[14].position=New Vec3f( -1,-1,-1 )'left front bottom
 		vertices[15].position=New Vec3f( -1,-1, 1 )'left back bottom
		'top
		vertices[16].position=New Vec3f( -1, 1, 1 )'left back top
		vertices[17].position=New Vec3f(  1, 1, 1 )'right back top
 		vertices[18].position=New Vec3f(  1, 1,-1 )'right front top
 		vertices[19].position=New Vec3f( -1, 1,-1 )'left front top
		'bottom
		vertices[20].position=New Vec3f( -1,-1,-1 )'left front bottom
		vertices[21].position=New Vec3f(  1,-1,-1 )'right front bottom
 		vertices[22].position=New Vec3f(  1,-1,1 )'right back bottom
 		vertices[23].position=New Vec3f( -1,-1,1 )'left back bottom
		

	'  Texture coordinates represent coordinates within the image, where 
	'	0,0=top left, 1,0=top right, 1,1=bottom right, 0,1=bottom left
		
		'front texture
		vertices[0].texCoord0 = New Vec2f(0,0)
		vertices[1].texCoord0 = New Vec2f(1,0)
		vertices[2].texCoord0 = New Vec2f(1,1)
		vertices[3].texCoord0 = New Vec2f(0,1)
		'back texture		
		vertices[4].texCoord0 = New Vec2f(0,0)
		vertices[5].texCoord0 = New Vec2f(1,0)
		vertices[6].texCoord0 = New Vec2f(1,1)
		vertices[7].texCoord0 = New Vec2f(0,1)
		'right texture
		vertices[8].texCoord0 = New Vec2f(0,0)
		vertices[9].texCoord0 = New Vec2f(1,0)
		vertices[10].texCoord0 = New Vec2f(1,1)
		vertices[11].texCoord0 = New Vec2f(0,1)
		'left texture
		vertices[12].texCoord0 = New Vec2f(0,0)
		vertices[13].texCoord0 = New Vec2f(1,0)
		vertices[14].texCoord0 = New Vec2f(1,1)
		vertices[15].texCoord0 = New Vec2f(0,1)
		'top texture
		vertices[16].texCoord0 = New Vec2f(0,0)
		vertices[17].texCoord0 = New Vec2f(1,0)
		vertices[18].texCoord0 = New Vec2f(1,1)
		vertices[19].texCoord0 = New Vec2f(0,1)
		'bottom texture
		vertices[20].texCoord0 = New Vec2f(0,0)
		vertices[21].texCoord0 = New Vec2f(1,0)
		vertices[22].texCoord0 = New Vec2f(1,1)
		vertices[23].texCoord0 = New Vec2f(0,1)

'		 
		Local indices:=New UInt[36]
		'front
		indices[0]=0
		indices[1]=1
		indices[2]=2
		indices[3]=0
		indices[4]=2
		indices[5]=3
		'back side
		indices[12]=4
		indices[13]=5
		indices[14]=6
		indices[15]=4
		indices[16]=6
		indices[17]=7	
		'right side
		indices[18]=8
		indices[19]=9
		indices[20]=10
		indices[21]=8
		indices[22]=10
		indices[23]=11
'		' left side
		indices[6]=12
		indices[7]=13
		indices[8]=14
		indices[9]=12
		indices[10]=14
		indices[11]=15		
'		'top side
		indices[24]=16
		indices[25]=17
		indices[26]=18
		indices[27]=16
		indices[28]=18
		indices[29]=19
		'bottom side
		indices[30]=20
		indices[31]=21
		indices[32]=22
		indices[33]=20
		indices[34]=22
		indices[35]=23
		
		Return New Mesh( vertices,indices )		
		
	End Method
	Method RenderTexture()
		If Not _rectCanvas Then
			_rectCanvas=New Canvas( _rectImage )
	 
		Endif
		
		'This should be orange with white text on
		'But since I'm drawing something in the top left corner -
		'I'm just getting that top left pixel on the entire rectangle
		
		_rectCanvas.Clear( Color.Blue )
		_rectCanvas.Color = Color.White
		_rectCanvas.DrawText( "Hello World", Rnd(8,12), 8 )
		_rectCanvas.Color = Color.Orange
		_rectCanvas.DrawRect( 50, 50 , 200 ,90) 'White in the top left
		
		
		
		_rectCanvas.Flush()
		
	End	Method

	Method controls()
		If Keyboard.KeyDown(Key.W) Then _camera.Move(0,0,.2)
		If Keyboard.KeyDown(Key.S) Then _camera.Move(0,0,-.2)
		If Keyboard.KeyDown(Key.A) Then _camera.Move(-.2,0,0)
		If Keyboard.KeyDown(Key.D) Then _camera.Move(.2,0,0)
		If Keyboard.KeyDown(Key.Up) Then _camera.Rotate(1,0,0)
		If Keyboard.KeyDown(Key.Down) Then _camera.Rotate(-1,0,0)
		If Keyboard.KeyDown(Key.Left) Then _camera.Rotate(0,1,0)
		If Keyboard.KeyDown(Key.Right) Then _camera.Rotate(0,-1,0)
	End Method

End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
