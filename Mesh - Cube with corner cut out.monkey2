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
		_light.RotateX( Pi/2 )	'aim directional light downwards - Pi/2=90 degrees.
		
		'create Cube with corner cut out
		'
		Local vertices:=New Vertex3f[14]
		' negative z is towards the camera,
		' Front side of cube with corner out
		vertices[0 ].position=New Vec3f(  -1, 1, -1 ) 'left top front
		vertices[1 ].position=New Vec3f(   0, 1, -1 ) 'middle top front
		vertices[2 ].position=New Vec3f(   0,-1, -1 ) 'middle bottom front
		vertices[3 ].position=New Vec3f(  -1,-1, -1 ) 'left bottom front
		vertices[4 ].position=New Vec3f(   0, 1,  0 ) 'middle middle front
		vertices[5 ].position=New Vec3f(   1, 1,  0 ) 'right middle front
		vertices[6 ].position=New Vec3f(   1,-1,  0 ) 'right middle front
		vertices[7 ].position=New Vec3f(   0,-1,  0 ) 'middle bottom front
		vertices[8 ].position=New Vec3f(   1, 1,  1 ) 'backside right top
		vertices[9 ].position=New Vec3f(  -1, 1,  1 ) 'topview left top
		vertices[10].position=New Vec3f(  -1,-1,  1 ) 'bottomview left bottom
		vertices[11].position=New Vec3f(   1,-1,  1 ) 'bottomview right bottom
		vertices[12].position=New Vec3f(  -1, 1,  0 ) 'topview left center
		vertices[13].position=New Vec3f(  -1, 0, -1 ) 'bottomview left center
		Local indices:=New UInt[60]
		' Front side
		indices[0]=0
		indices[1]=1
		indices[2]=3
		indices[3]=1
		indices[4]=2
		indices[5]=3
		indices[6]=4
		indices[7]=5
		indices[8]=7
		indices[9]=5
		indices[10]=6
		indices[11]=7 
		'right side
		indices[12]=1
		indices[13]=4
		indices[14]=2
		indices[15]=4
		indices[16]=7
		indices[17]=2
		indices[18]=5
		indices[19]=8
		indices[20]=6
		indices[21]=8
		indices[22]=11
		indices[23]=6
		'back side
		indices[24]=8
		indices[25]=9
		indices[26]=11
		indices[27]=9
		indices[28]=10
		indices[29]=11
		'left side
		indices[30]=9
		indices[31]=0
		indices[32]=10
		indices[33]=0
		indices[34]=3
		indices[35]=10
		' top view
		indices[36]=9
		indices[37]=8
		indices[38]=12
		indices[39]=8
		indices[40]=5
		indices[41]=12
		indices[42]=12
		indices[43]=4
		indices[44]=0
		indices[45]=4
		indices[46]=1
		indices[47]=0
		'bottom view
		indices[48]=3
		indices[49]=2
		indices[50]=13
		indices[51]=2
		indices[52]=7
		indices[53]=13
		indices[54]=13
		indices[55]=6
		indices[56]=10
		indices[57]=6
		indices[58]=11
		indices[59]=10
		
		Local mesh:=New Mesh( vertices,indices )
		
		'create model for the mesh
		'
		_model=New Model
		_model.Mesh=mesh
		_model.Material=New PbrMaterial( Color.Red )
		_model.Material.CullMode=CullMode.None
 
	End
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		
		Fly( _camera,Self )		
		
		
		_scene.Render( canvas,_camera )
 
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
	End


	
End

' Taken from the mojo3d test
Function Fly( entity:Entity,view:View )


	If Keyboard.KeyDown( Key.Up )
		entity.RotateX( .1 )
	Else If Keyboard.KeyDown( Key.Down )
		entity.RotateX( -.1 )
	Endif
	
	If Keyboard.KeyDown( Key.Q )
		entity.RotateZ( .1 )
	Else If Keyboard.KeyDown( Key.W )
		entity.RotateZ( -.1 )
	Endif
	
	If Keyboard.KeyDown( Key.Left )
		entity.RotateY( .1,True )
	Else If Keyboard.KeyDown( Key.Right )
		entity.RotateY( -.1,True )
	Endif

	If Mouse.ButtonDown( MouseButton.Left )
		If Mouse.X<view.Width/3
			entity.RotateY( .1,True )
		Else If Mouse.X>view.Width/3*2
			entity.RotateY( -.1,True )
		Else
			entity.Move( New Vec3f( 0,0,.1 ) )
		Endif
	Endif
	
	If Keyboard.KeyDown( Key.A )
		entity.MoveZ( .5 )	'( New Vec3f( 0,0,.1 ) )
	Else If Keyboard.KeyDown( Key.Z )
		entity.MoveZ( -.5 )	'( New Vec3f( 0,0,-.1 ) )
	Endif
		
End Function

 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
