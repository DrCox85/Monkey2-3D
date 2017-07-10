#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"


Using std..
Using mojo..
Using mojo3d..

Global mapwidth:Int=80
Global mapheight:Int=80


Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _fog:FogEffect
	
	Field _camera:Camera
	
	Field _light:Light

	Field _ground:Model

	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		startgame()

	End Method
	
	Method OnRender( canvas:Canvas ) Override
	
		RequestRender()
		
		Fly( _camera,Self )
		
		If Mouse.X < 200 Then _camera.RotateY(0.1)
		If Mouse.X > Width-200 Then _camera.RotateY(-0.1)
		
		
		_scene.Render( canvas,_camera )
		
		If Keyboard.KeyReleased(Key.Space) Then startgame()
		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		canvas.DrawText("a/z - Cursor up/down/left/right and Left mouse button - space = new map.",0,20)
		canvas.DrawText("Move mouse to edges to turn left and right.",0,40)
	End Method

	Method startgame()
		
		If _camera Then _camera.Destroy()
		If _light Then _light.Destroy()
		If _scene Then _scene.Models.Clear() 'Remove previous models
		_scene=Scene.GetCurrent()
		
		_fog=New FogEffect( Color.Sky,480,512 )
		
		'create camera
		'
		_camera=New Camera
		_camera.Near=1
		_camera.Far=256
		_camera.Move( 0,2,0 )
		
		'create light
		'
		_light=New Light
		_light.RotateX( Pi/2 )	'aim directional light 'down' - Pi/2=90 degrees.

		'Create a ground
		Local groundBox:=New Boxf( -mapwidth*2,-1,-mapheight*2,mapwidth*2,0,mapheight*2 )		
		_ground=Model.CreateBox( groundBox,16,16,16,New PbrMaterial( Color.Grey ) )

		' Here we create the random map
		Local mymap:Int[,] = New Int[0,0]
		mymap = makemap()
		' Put it in the scene
		For Local y:=0 Until mapheight-2
		For Local x:=0 Until mapwidth-2
			'make walls on the x 
			If mymap[x,y] = 1 And mymap[x+1,y] = 1
				Local sx:Int=0
				Local cnt:Float=-1
				While mymap[x+sx,y] = 1
					mymap[x+sx,y] = 0
					sx+=1
					cnt+=1
				Wend
				Local mymesh := Mesh.CreateBox( New Boxf( -1,-15,-1,cnt*2+1,15,1 ),1,1,1 )
				Local material:=New PbrMaterial( New Color( Rnd(0.0,0.6),0,0) )
				Local model:=New Model( mymesh,material )
				model.Move( x*2-mapwidth/2,10,y*2-mapheight/2 )				
				
			End If
			' make walls on the y
			If mymap[x,y] = 1 And mymap[x,y+1] = 1
				Local sy:Int=0
				Local cnt:float=-1
				While mymap[x,y+sy] = 1
					mymap[x,y+sy] = 0
					sy+=1
					cnt+=1
				Wend				
				Local mymesh := Mesh.CreateBox( New Boxf( -1,-15,-1,1,15,cnt*2+1 ),1,1,1 )
				Local material:=New PbrMaterial( New Color( Rnd(0.0,0.6),0,0) )
				Local model:=New Model( mymesh,material )
				model.Move( x*2-mapwidth/2,10,y*2-mapheight/2 )				

			End If
		Next
		Next	

	End Method

	
End

'
' This function creates a random map. It carves a path
' between a number of random coordinates. It takes the
' edges and give these the value of 1. This map array
' is returned by the function.
'
Function makemap:Int[,]()
	Local mymap:Int[,] = New Int[mapwidth,mapheight]
	Local path:Int[,] = New Int[16,2]
	For Local i:=0 Until 15
		path[i,0] = Rnd(8,mapwidth-8)
		path[i,1] = Rnd(8,mapheight-8)		
	Next
	Local x:Int=path[0,0]
	Local y:Int=path[0,1]
	Local pos:Int=1
	Local exitloop:Bool=False
	While exitloop = False
		If x<path[pos,0] Then x+=1 
		If y<path[pos,1] Then y+=1 
		If x>path[pos,0] Then x-=1
		If y>path[pos,1] Then y-=1
		For Local y1:=-2 To 2
		For Local x1:=-2 To 2
			If x+x1 >=0 And y+y1 >= 0 And x+x1 < mapwidth And y+y1 < mapheight
				mymap[x+x1,y+y1] = 1
			End If
		Next
		Next
		If x = path[pos,0] And y = path[pos,1]
			If pos<14 Then 
				pos+=1
			Else
				exitloop = True
			End If
		End If
	Wend
	Local mymap2:Int[,] = New Int[mapwidth,mapheight]
	For Local y:=1 Until mapheight-1
	For Local x:=1 Until mapwidth-1
		If mymap[x,y] = 1
			Local cnt:Int=0
			For Local y2:=-1 To 1
			For Local x2:=-1 To 1
				If mymap[x+x2,y+y2] = 0 Then cnt+=1
			Next
			Next
			If cnt > 0 Then mymap2[x,y] = 1
		End If
	Next
	Next
	Return mymap2	
End Function

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
