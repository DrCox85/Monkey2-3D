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
		
		'create Wall(cube sized) with door mesh
		'
		Local vertices:=New Vertex3f[20]
		'
		' Front side of wall with door
		vertices[0].position=New Vec3f(  -1, 1, 1 ) 'left front top (x,y,z)
		vertices[1].position=New Vec3f(   1, 1, 1 ) 'right top frontview
		vertices[2].position=New Vec3f(   1, 0, 1 ) 'right middle front
		vertices[3].position=New Vec3f(  -1, 0, 1 ) 'left middle front
		vertices[4].position=New Vec3f( -.5, 0, 1 ) 'left top door front
		vertices[5].position=New Vec3f( -.5,-1, 1 ) 'left botton door front
		vertices[6].position=New Vec3f(  -1,-1, 1 ) 'left bottom front
	 	vertices[7].position=New Vec3f(  .5, 0, 1 ) 'right top door front
	 	vertices[8].position=New Vec3f(   1,-1, 1 ) 'right bottom front
	 	vertices[9].position=New Vec3f(  .5,-1, 1 ) 'right bottom door front
 		'
 		' Back side of wall with door
		vertices[10].position=New Vec3f(  -1, 1, -1 ) 'left front top
		vertices[11].position=New Vec3f(   1, 1, -1 ) 'right top frontview
		vertices[12].position=New Vec3f(   1, 0, -1 ) 'right middle front
		vertices[13].position=New Vec3f(  -1, 0, -1 ) 'left middle front
		vertices[14].position=New Vec3f( -.5, 0, -1 ) 'left top door front
		vertices[15].position=New Vec3f( -.5,-1, -1 ) 'left botton door front
		vertices[16].position=New Vec3f(  -1,-1, -1 ) 'left bottom front
	 	vertices[17].position=New Vec3f(  .5, 0, -1 ) 'right top door front
	 	vertices[18].position=New Vec3f(   1,-1, -1 ) 'right bottom front
	 	vertices[19].position=New Vec3f(  .5,-1, -1 ) 'right bottom door front
  		'
  
		Local indices:=New UInt[66]
		' Front side of wall with door
		indices[0]=0 
		indices[1]=1
		indices[2]=3
		indices[3]=1
		indices[4]=2
		indices[5]=3
		
		indices[6]=3
		indices[7]=4
		indices[8]=6
		indices[9]=4
		indices[10]=5
		indices[11]=6
		
		indices[12]=7
		indices[13]=2
		indices[14]=9
		indices[15]=2
		indices[16]=8
		indices[17]=9
		
		'back side of wall with door
		
		indices[18]=10 
		indices[19]=11
		indices[20]=13
		indices[21]=11
		indices[22]=12
		indices[23]=13
		
		indices[24]=13
		indices[25]=14
		indices[26]=16
		indices[27]=14
		indices[28]=15
		indices[29]=16
		
		indices[30]=17
		indices[31]=12
		indices[32]=19
		indices[33]=12
		indices[34]=18
		indices[35]=19
		
		
		' right side wall
		indices[36]=1
		indices[37]=11
		indices[38]=8
		indices[39]=11
		indices[40]=18
		indices[41]=8 
		
		'left side wall
		indices[42]=10
		indices[43]=0
		indices[44]=16
		indices[45]=0
		indices[46]=6
		indices[47]=16
		
		' door ceiling 
		indices[48]=14
		indices[49]=17
		indices[50]=4
		indices[51]=17
		indices[52]=7
		indices[53]=4
		
		'door left inside
		indices[54]=4
		indices[55]=14
		indices[56]=5
		indices[57]=14
		indices[58]=15
		indices[59]=5
		
		'door inside right side
		indices[60]=17
		indices[61]=7
		indices[62]=19
		indices[63]=7
		indices[64]=9
		indices[65]=19
		
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
