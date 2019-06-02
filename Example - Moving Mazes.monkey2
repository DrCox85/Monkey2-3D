#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"


Using std..
Using mojo..
Using mojo3d.. 'The new mojo 3d module.


Class MyWindow Extends Window
	' What are we going to use.
	Field myscene:Scene
	Field mycamera:Camera
	Field mylight:Light	
	Field mybox:Model

	Field tempmap:=New String[6]
	Field map:=New Int[8,6]

	Field boxmap:=New Model[8,6]

	Field px:Int,py:Int

	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		' Our map 1 = wall - 0 = open
		tempmap[0] = "11111111"
		tempmap[1] = "10000101"
		tempmap[2] = "10100101"
		tempmap[3] = "10101101"
		tempmap[4] = "10000001"
		tempmap[5] = "11111111"
		map = New Int[tempmap[0].Length,tempmap.GetSize(0)]
		For Local i:Int=0 Until map.GetSize(0)
		For Local j:Int=0 Until tempmap.Length
			If tempmap[j][i] = 49 Then map[i,j] = 1 Else map[i,j] = 0
		Next
		Next
		
		
		' Get the current scene
		myscene=Scene.GetCurrent()
		myscene.ClearColor = New Color( 0,0,0 )
		myscene.AmbientLight = myscene.ClearColor * 0.25
		myscene.FogColor = myscene.ClearColor
		myscene.FogNear = 1.0
		myscene.FogFar = 20.0		
		'create camera
		'
		mycamera = New Camera
		mycamera.Near = 1 '??
		mycamera.Far = 256 'how far should we render
		mycamera.Move(4,0,4) 'move the camera to position x,y,z
		
		

		'create light (Light seems to be broken on my version of monkey2)
		'
		'mylight = New Light
		'mylight.RotateX(Pi/2)	'aim directional light 'down' - Pi/2=90 degrees.

		'
		' Create the maze
		'
		' This is the mesh with which we create the model.
		Local mymesh := Mesh.CreateBox( New Boxf( -2,-2,-2,2,2,2 ),1,1,1 )
		' Here we create the material that we put on the box.
		Local material:=New PbrMaterial( New Color( 1,0,0) )
	 
	 	Local sm:= New PbrMaterial()
		
		Local _rectImage:=New Image( 256, 256 )
	 
		Local _rectCanvas:=New Canvas( _rectImage )
	
		For Local y:Int=0 Until 256 Step 32
		For Local x:Int=0 Until 256 Step 32
		Local col:Float=Rnd(0.3,0.6)
		_rectCanvas.Color=New Color(col,col/2,col/2)
		_rectCanvas.DrawRect(x,y,32,32)
		Next
		Next
		For Local i:Int=0 Until 15000
			_rectCanvas.Color = Color.Black
			
			_rectCanvas.Alpha = Rnd(0,0.5)			
			_rectCanvas.DrawRect(128+(Cos(Rnd(TwoPi))*128),128+(Sin(Rnd(TwoPi))*128),Rnd(1,2),Rnd(1,2))
			
		Next
		_rectCanvas.Flush()
		
		
		sm.ColorTexture = _rectImage.Texture
	 	sm.ColorTexture.Flags = TextureFlags.FilterMipmap	
		'sm.CullMode=CullMode.None
	 
 
		'_model.Materials[mesh.NumMaterials - 1] = sm	
	
				
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			If map[x,y] = 1 Then 
			Local rc:Float=Rnd(0.3,0.5)
			boxmap[x,y] = New Model( mymesh,New PbrMaterial( New Color( rc,rc,rc) ))
			boxmap[x,y].Materials[mymesh.NumMaterials - 1] = sm	
			boxmap[x,y].Move(x*4,0,y*4)	
			End If	
		Next
		Next		


	End Method
	
	' This method is the main loop.
	Method OnRender( canvas:Canvas ) Override
	
		RequestRender()
	
		' Move the camera through the maze	
		' First store our old position...
		Local oldx:Int = mycamera.LocalPosition.x/4
		Local oldy:Int = mycamera.LocalPosition.z/4
		' check keys and move or turn if needed
		If Keyboard.KeyReleased(Key.Up) Then mycamera.Move(0,0,4)
		If Keyboard.KeyReleased(Key.Down) Then mycamera.Move(0,0,-4)
		If Keyboard.KeyReleased(Key.Right) Then mycamera.RotateY(-90)
		If Keyboard.KeyReleased(Key.Left) Then mycamera.RotateY(90)
		' get our new location
		Local x:Int = mycamera.LocalPosition.x/4
		Local y:Int = mycamera.LocalPosition.z/4		
		' if we are inside a wall then restore to our previous position
		If map[x,y] = 1 Then mycamera.Position = New Vec3f(oldx*4,0,oldy*4)
		
		' render our scene
		myscene.Render( canvas ) 'render the 3d scene

		' draw our minimap
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			If map[x,y] = 1
			canvas.Color=Color.Black
			canvas.DrawRect(x*10,y*10,10,10)
			Else
			canvas.Color=Color.White
			canvas.DrawRect(x*10,y*10,10,10)
			End If
		Next
		Next

		'Draw some infotmation
		canvas.Color = Color.White
		canvas.DrawText("Cursor keys to move.. (esc = exit)",200,0)

		' quit key
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		
	End Method

End Class

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End Function
