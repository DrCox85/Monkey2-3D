#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
 
Using std..
Using mojo..
Using mojo3d..

Global mymodels:List<Model> = New List<Model>
Global finalmodels:List<Model> = New List<Model>

 
Class world
	Function maketop()
		For Local y:=-2 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f( -1+x,0, 1+y )
			vertices[1].position=New Vec3f(  1+x,0, 1+y )
			vertices[2].position=New Vec3f(  1+x,0,-1+y )
			vertices[3].position=New Vec3f( -1+x,0,-1+y )
	
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
	
			Local mesh:=New Mesh( vertices,indices)
	
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			_model.MoveY(2)
			_model.MoveZ(-3)
			mymodels.AddLast(_model)
		Next
		Next		
	
	
	End Function

	
	Function makebottom()
		For Local y:=-2 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f( -1+x,0, 1+y )
			vertices[1].position=New Vec3f(  1+x,0, 1+y )
			vertices[2].position=New Vec3f(  1+x,0,-1+y )
			vertices[3].position=New Vec3f( -1+x,0,-1+y )
	
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
	
			Local mesh:=New Mesh( vertices,indices)
	
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			_model.MoveY(-2)
			_model.MoveZ(-3)
			mymodels.AddLast(_model)
		Next
		Next		
	
	
	End Function
	
	Function makefrontwall(wall:Bool=True)
		
		For Local y:=-1 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			If wall=True And y=-1 And x=0 Then Continue
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f( -1+x, 1+y,0 )
			vertices[1].position=New Vec3f(  1+x, 1+y,0 )
			vertices[2].position=New Vec3f(  1+x,-1+y,0 )
			vertices[3].position=New Vec3f( -1+x,-1+y,0 )
		
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
		
			Local mesh:=New Mesh( vertices,indices)
		
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			_model.MoveZ(-6)
			mymodels.AddLast(_model)
		Next
		Next		
	End Function



	Function makerightsidewall(wall:Bool=True)
		For Local y:=-1 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			If wall=True And y=-1 And x=0 Then Continue
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f(  0, 1+y,-1+x )
			vertices[1].position=New Vec3f(  0 ,1+y,1+x )
			vertices[2].position=New Vec3f(  0,-1+y,1+x )
			vertices[3].position=New Vec3f(  0,-1+y,-1+x )
		
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
		
			Local mesh:=New Mesh( vertices,indices)
		
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			_model.MoveX(3)
			_model.MoveZ(-3)
			mymodels.AddLast(_model)
		Next
		Next		


	End Function


	Function makeleftsidewall(wall:Bool=True)
		For Local y:=-1 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			If wall=True And y=-1 And x=0 Then Continue
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f(  0, 1+y,-1+x )
			vertices[1].position=New Vec3f(  0 ,1+y,1+x )
			vertices[2].position=New Vec3f(  0,-1+y,1+x )
			vertices[3].position=New Vec3f(  0,-1+y,-1+x )
		
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
		
			Local mesh:=New Mesh( vertices,indices)
		
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			_model.MoveX(-3)
			_model.MoveZ(-3)
			mymodels.AddLast(_model)
		Next
		Next		


	End Function
	Function makebackwall(wall:Bool=True)
		
		For Local y:=-1 To 2 Step 2
		For Local x:=-2 To 2 Step 2
			If wall=True And y=-1 And x=0 Then Continue
			'create quad mesh
			'
			Local vertices:=New Vertex3f[4]
			vertices[0].position=New Vec3f( -1+x, 1+y,0 )
			vertices[1].position=New Vec3f(  1+x, 1+y,0 )
			vertices[2].position=New Vec3f(  1+x,-1+y,0 )
			vertices[3].position=New Vec3f( -1+x,-1+y,0 )
		
			Local indices:=New UInt[6]
			indices[0]=0
			indices[1]=1
			indices[2]=2
			indices[3]=0
			indices[4]=2
			indices[5]=3
		
			Local mesh:=New Mesh( vertices,indices)
		
			'create model for the mesh
			'
			Local _model:=New Model
			_model.Mesh=mesh
			_model.Material=New PbrMaterial( New Color(Rnd(1),0,0) )
			_model.Material.CullMode=CullMode.None
			mymodels.AddLast(_model)
		Next
		Next		
	End Function
	Function makequad:Model(_model:Model)
		'create quad mesh
		'
		Local vertices:=New Vertex3f[4]
		vertices[0].position=New Vec3f( -1, 1,0 )
		vertices[1].position=New Vec3f(  1, 1,0 )
		vertices[2].position=New Vec3f(  1,-1,0 )
		vertices[3].position=New Vec3f( -1,-1,0 )
	
		Local indices:=New UInt[6]
		indices[0]=0
		indices[1]=1
		indices[2]=2
		indices[3]=0
		indices[4]=2
		indices[5]=3
	
		Local mesh:=New Mesh( vertices,indices )
	
		'create model for the mesh
		'
		_model.Mesh=mesh
		_model.Material=New PbrMaterial( Color.Red )
		_model.Material.CullMode=CullMode.None		
		Return _model
	End Function
End Class  
 
Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _model:Model
	
	Field myworld:world
	
	Method New()
		
		myworld = New world()
		
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

		For Local z:Int=-10 To 10 Step 6
		For Local x:int=-10 To 10 Step 6
			myworld.makebackwall()
			myworld.makeleftsidewall()		
			myworld.makerightsidewall()
			myworld.makefrontwall()
			myworld.makebottom()
			myworld.maketop()
			For Local i:=Eachin mymodels
				i.MoveX(x)
				i.MoveZ(z)
			Next
			For Local i:=Eachin mymodels
				finalmodels.Add(i)
			Next
			mymodels.Clear()			
		Next
	End
	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		
		Fly( _camera,Self )		
		
'' 		_model.RotateY( .1 )
		
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
