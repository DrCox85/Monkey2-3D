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
			
	Field worldmap:Int[,]
	' The camera position
	Field mapx:Int=40,mapy:Int=40
	
	Method New()
		' Create our world map and give it
		' random values
		worldmap = New Int[100,100]
		For Local y:Int=0 Until 100
		For Local x:Int=0 Until 100
			worldmap[x,y] = Rnd(0,4)
		Next
		Next
		
		'get scene
		'
		_scene=Scene.GetCurrent()
 
		'create camera
		'
		_camera=New Camera
		_camera.Near=.1
		_camera.Far=100
		_camera.Move( 0,-8,8 )
		_camera.PointAt(New Vec3f(0,0,0))
		
		'create light
		'
		_light=New Light
		_light.RotateX( Pi/2 )	'aim directional light downwards - Pi/2=90 degrees.
		
		createmap()
		
 
	End
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		
		scrollmap()
		'_model.RotateY( .1 )
		
		_scene.Render( canvas,_camera )
 
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method

	Method scrollmap()
		Local tx:Int=mapx
		Local ty:Int=mapy
		If Keyboard.KeyDown(Key.Right) Then tx -= 1 
		If Keyboard.KeyDown(Key.Left) Then tx += 1
		If Keyboard.KeyDown(Key.Up) Then ty += 1
		If Keyboard.KeyDown(Key.Down) Then ty -= 1


		If tx<0 Then tx = 0
		If tx+10>=worldmap.GetSize(0) Then tx = worldmap.GetSize(0)-10
		If ty<0 Then ty = 0
		If ty+10>=worldmap.GetSize(1) Then ty = worldmap.GetSize(1)-10
		
		Local redr:Bool=True
		If mapy <> ty Or mapx <> tx Then redr = True
		mapx = tx
		mapy = ty
		
		If redr Then 
			createmap()		
		End If
		
	End Method
	
	Method createmap()
		'Destroy all models
		_scene.DestroyAllEntities()
		' Draw the map
		For Local y:Int=0 Until 10
		For Local x:Int=0 Until 10
			Local mesh := createquad()
			
			'create model for the mesh
			'
			_model=New Model
			_model.Mesh=mesh
			'Color based on worldmap value
			Select worldmap[x+mapx,y+mapy] 
				Case 0
				_model.Material=New PbrMaterial( Color.Red )
				Case 1
				_model.Material=New PbrMaterial( Color.Green )
				Case 2
				_model.Material=New PbrMaterial( Color.Blue )
				Case 3
				_model.Material=New PbrMaterial( Color.White )				
			End Select
			_model.Material.CullMode=CullMode.None
			_model.Move(x-5,y-5,0)
			
		Next
		Next
	End Method	
	
	Method createquad:Mesh()
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
		
		Return mesh

	End Method
	
End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
