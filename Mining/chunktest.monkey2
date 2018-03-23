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
		_camera.Move( 0,0,-35 )
		
		'create light
		'
		_light=New Light
		_light.Move(110,110,120)
		_light.PointAt(New Vec3f(0,0,0))
'		_light.RotateX( 90 )	'aim directional light downwards - 90 degrees.
	 		
	 	'Here we create our chunk array
	 	Local chunkwidth:Int=10
	 	Local chunkheight:Int=10
	 	Local chunkdepth:Int=10
		Local chunk:Int[,,] = New Int[chunkwidth,chunkheight,chunkdepth]

	
		For Local z:Int=0 Until 10
		For Local y:Int=0 Until 10
		For Local x:Int=0 Until 10
			chunk[x,y,z] = 1
		Next
		Next
		Next
		For Local z:Int=0 Until 10
		For Local y:Int=0 Until 10
		For Local x:Int=2 Until 8
			chunk[x,y,z] = Int(Rnd(0,2))
			If Rnd() <.7 Then chunk[x,y,z]=0
		Next
		Next
		Next
		
		
		'Here we create our chunk mesh
		
		Local chunkmesh:= New Mesh()
		For Local z:Int=0 Until chunkdepth
		For Local y:Int=0 Until chunkheight
		For Local x:Int=0 Until chunkwidth
			If chunk[x,y,z] <> 0 Then 
				Local sides:Bool[] = New Bool[6]
				If z-1>=0 And chunk[x,y,z-1] <> 0 Then sides[0] = False Else sides[0] = True
				If x-1>=0 And chunk[x-1,y,z] <> 0 Then sides[1] = False Else sides[1] = true
				If z+1<chunkdepth And chunk[x,y,z+1] <> 0 Then sides[2] = False Else sides[2] = True
				If x+1<chunkwidth And chunk[x+1,y,z] <> 0 Then sides[3] = False Else sides[3] = True
				If y+1<chunkheight And chunk[x,y+1,z] <> 0 Then sides[4] = False Else sides[4] = True
				If y-1>=0 And chunk[x,y-1,z] <> 0 Then sides[5] = False Else sides[5] = True				
				Local mesh2:=createcube(x*2,y*2,z*2,sides)								
				chunkmesh.AddMesh(mesh2)
			endif
		Next
		Next
		Next 
		' Here we create our model containing the chunk
		chunkmesh.UpdateNormals()
		_model=New Model
		_model.Mesh=chunkmesh
		'_model.Material=New PbrMaterial( Color.Green )
		'_model.Material.CullMode=CullMode.None
 		'_model.Move(2,0,0)
		_model.Mesh=chunkmesh
		_model.Materials = _model.Materials.Resize(chunkmesh.NumMaterials)	

	 	Local sm:= New PbrMaterial()
		
		_rectImage=New Image( 256, 256 )
	 
		_rectCanvas=New Canvas( _rectImage )
	
		sm.ColorTexture = _rectImage.Texture
	 	sm.ColorTexture.Flags = TextureFlags.FilterMipmap	
		sm.CullMode=CullMode.None
	 
 
		_model.Materials[chunkmesh.NumMaterials - 1] = sm
		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		RenderTexture()
		'_model.RotateY( 1 )
		'_model.RotateZ( -1 )
		'_model.RotateX( 1 )
		controls()
		_scene.Update()
		_scene.Render( canvas,_camera )
 		 		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method

	'sides (0-front,1=left,2=back,3=right,4=top,5=bottom)
	'x,y,z is location in the chunk
	Method createcube:Mesh(x:Float=0,y:Float=0,z:Float=0,sides:Bool[])
		
		'create cube mesh
		'
		Local vertices:=New Vertex3f[8]
		vertices[0].position=New Vec3f( -1+x, 1+y,-1+z )'left front top
		vertices[1].position=New Vec3f(  1+x, 1+y,-1+z )'right front top
		vertices[2].position=New Vec3f(  1+x,-1+y,-1+z )'right front bottom
		vertices[3].position=New Vec3f( -1+x,-1+y,-1+z )'left front bottom
		vertices[4].position=New Vec3f( -1+x, 1+y, 1+z )'left back top
		vertices[5].position=New Vec3f( -1+x,-1+y, 1+z )'left back bottom
 		vertices[6].position=New Vec3f(  1+x, 1+y, 1+z )'right back top
 		vertices[7].position=New Vec3f(  1+x,-1+y, 1+z )'right back bottom


'  Texture coordinates represent coordinates within the image, where 
'	0,0=top left, 1,0=top right, 1,1=bottom right, 0,1=bottom left
		vertices[0].texCoord0 = New Vec2f(0,0)
		vertices[1].texCoord0 = New Vec2f(1,0)
		vertices[2].texCoord0 = New Vec2f(1,1)
		vertices[3].texCoord0 = New Vec2f(0,1)
		
		vertices[4].texCoord0 = New Vec2f(1,0)
		vertices[5].texCoord0 = New Vec2f(0,1)
		vertices[6].texCoord0 = New Vec2f(0,0)
		vertices[7].texCoord0 = New Vec2f(0,1)		 		

 		Local inds:Int=0
 		For Local i:Int=0 Until 6
	 		If sides[i] = True Then inds+=6
	 	Next
 		
		Local indices:=New UInt[inds]
		
		Local cnt:Int=0
		'front
		If sides[0] = True
		indices[cnt]=0;cnt+=1
		indices[cnt]=1;cnt+=1
		indices[cnt]=2;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=2;cnt+=1
		indices[cnt]=3;cnt+=1
		End if
		If sides[1] = True
		' left side
		indices[cnt]=4;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=5;cnt+=1
		End If
		If sides[2] = True
		'back side
		indices[cnt]=4;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=5;cnt+=1
		End If
		If sides[3] = True
		'right side
		indices[cnt]=1;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=1;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=2;cnt+=1
		End If
		If sides[4] = True
		'top side
		indices[cnt]=0;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=1;cnt+=1
		End If
		If sides[5] = true
		'bottom side
		indices[cnt]=3;cnt+=1
		indices[cnt]=5;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=2;cnt+=1
		End If
				
		Return New Mesh( vertices,indices )		
		
	End Method
	
	Method controls()
		If Keyboard.KeyDown(Key.W) Then _camera.Move(0,0,.5)
		If Keyboard.KeyDown(Key.S) Then _camera.Move(0,0,-.5)
		If Keyboard.KeyDown(Key.A) Then _camera.Move(-.5,0,0)
		If Keyboard.KeyDown(Key.D) Then _camera.Move(.5,0,0)
		If Keyboard.KeyDown(Key.Up) Then _camera.Rotate(1,0,0)
		If Keyboard.KeyDown(Key.Down) Then _camera.Rotate(-1,0,0)
		If Keyboard.KeyDown(Key.Left) Then _camera.Rotate(0,1,0)
		If Keyboard.KeyDown(Key.Right) Then _camera.Rotate(0,-1,0)
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
End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
