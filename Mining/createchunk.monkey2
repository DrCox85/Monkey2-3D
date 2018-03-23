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
	 		
	 	'Here we create our chunk array
		Local chunk:Int[,,] = New Int[3,3,3]
		chunk[1,1,1] = 1
		chunk[0,1,1] = 1
		chunk[1,2,1] = 1
		
		'Here we create our chunk mesh
		Local chunkmesh:= New Mesh()
		For Local z:Int=0 Until 3
		For Local y:Int=0 Until 3
		For Local x:Int=0 Until 3
			If chunk[x,y,z] = 1 Then 
				Local mesh2:=createcube(x*2,y*2,z*2)
				chunkmesh.AddMesh(mesh2)
			endif
		Next
		Next
		Next 
		' Here we create our model containing the chunk
		_model=New Model
		_model.Mesh=chunkmesh
		_model.Material=New PbrMaterial( Color.Green )
		_model.Material.CullMode=CullMode.None
 		_model.Move(2,0,0)

	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		
		_model.RotateY( 1 )
		_model.RotateZ( -1 )
		
		_scene.Render( canvas,_camera )
 		 		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method


	Method createcube:Mesh(x:Float=0,y:Float=0,z:Float=0)
		
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
 
		Local indices:=New UInt[36]
		'front
		indices[0]=0
		indices[1]=1
		indices[2]=2
		indices[3]=0
		indices[4]=2
		indices[5]=3
		' left side
		indices[6]=4
		indices[7]=0
		indices[8]=3
		indices[9]=4
		indices[10]=3
		indices[11]=5
		'back side
		indices[12]=4
		indices[13]=6
		indices[14]=7
		indices[15]=4
		indices[16]=7
		indices[17]=5
		'right side
		indices[18]=1
		indices[19]=6
		indices[20]=7
		indices[21]=1
		indices[22]=7
		indices[23]=2
		'top side
		indices[24]=0
		indices[25]=4
		indices[26]=6
		indices[27]=0
		indices[28]=6
		indices[29]=1
		'bottom side
		indices[30]=3
		indices[31]=5
		indices[32]=7
		indices[33]=3
		indices[34]=7
		indices[35]=2
				
		Return New Mesh( vertices,indices )		
		
	End Method
	
End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
