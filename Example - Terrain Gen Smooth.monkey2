#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"


Using std..
Using mojo..
Using mojo3d..

Global mapsize:Int=512


Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _fog:FogEffect
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _material:Material
	
	Field _terrain:Model
	
	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		startgame()

	End Method
	
	Method OnRender( canvas:Canvas ) Override
	
		RequestRender()
		
		Fly( _camera,Self )
		
		_scene.Render( canvas,_camera )
		
		If Keyboard.KeyReleased(Key.Space) Then startgame()
		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		canvas.DrawText("Cursor up/down/left/right a/z and Left mouse button - space = new map.",0,20)
	End Method

	Method startgame()
		
		If _scene Then _scene.DestroyAllEntities()
		'If _terrain Then _terrain.Destroy()
		'If _camera Then _camera.Destroy()
		'If _light Then _light.Destroy()
		'If _material Then _material.Discard()		
			
		
		
		_scene = Scene.GetCurrent()
		
		
		_fog=New FogEffect( Color.Sky,480,512 )
		
		'create camera
		'
		_camera=New Camera
		_camera.Near=1
		_camera.Far=512
		_camera.Move( 0,66,0 )
		
		'create light
		'
		_light=New Light
		_light.RotateX( Pi/2 )	'aim directional light 'down' - Pi/2=90 degrees.
		
		_material = New PbrMaterial( Color.Brown,1,0.5 )
		_material.ScaleTextureMatrix( 32,32 )
		
		Local heightMap:= New Pixmap(mapsize,mapsize)
		heightMap = makeheightmap()
		
		'_terrain=New Terrain( heightMap,New Boxf( -mapsize,0,-mapsize,mapsize,64,mapsize ),_material )
		_terrain=Model.CreateTerrain( heightMap,New Boxf( -256,0,-256,256,32,256 ),_material )
		_terrain.CastsShadow=False		
		heightMap.Discard()
	End Method
	
End


'
' This function creates a pixmap with a random map
' inside it for the use of the mojo3d terrain.
'
'
Function makeheightmap:Pixmap()
	SeedRnd(Millisecs()) 'Different seed is different map
	Local pm:Pixmap
	pm = New Pixmap(mapsize,mapsize)
	pm.Clear(Color.Black)

	' Create random points on the map
	For Local i:Int=0 Until mapsize
		Local x:Int=Rnd(mapsize)
		Local y:Int=Rnd(mapsize)

		Local ran:Float = Rnd(0,1)
		'If Rnd()<.1 Then ran=1
		
		pm.SetPixel(x,y,New Color(ran,ran,ran))
	Next
	
	
	'smooth the map
	For Local i:Int=0 Until mapsize*mapsize*10
			Local x:Int=Rnd(mapsize)
			Local y:Int=Rnd(mapsize)
			Local mc:Color
			Local mr:Float
			mc = pm.GetPixel(x,y)
			mr = mc.r
			For Local x1:Int=-1 To 1
			For Local y1:Int=-1 To 1
				If x1=0 And y1 = 0 Then Continue
				Local x2:Int=x+x1
				Local y2:Int=y+y1
				If x2<0 Or x2>=mapsize Or y2<0 Or y2>=mapsize Then Continue
				'If Rnd()<.5 Then Continue
				'If (x1=0 And y1=0) Then Continue
				Local mc2:Color
				Local mr2:Float
				mc2 = pm.GetPixel(x2,y2)
				mr2 = mc2.r
				Local mc3:Color
				Local mr3:Float
				
				If mr2<mr
					mr3 = mr2 + (Abs(mr-mr2)/2)
					mc3 = New Color(mr3,mr3,mr3)
				
				  	pm.SetPixel(x2,y2,mc3)

'					Elseif mr<mr2
'					mr3 = mr + (Abs(mr2-mr)/2)
'					mc3 = New Color(mr3,mr3,mr3)
				
'					pm.SetPixel(x2,y2,mc3)
' 
'					'mr3 = mr2/2
				End If
				
			Next
			Next
	Next
	
	'stretch
	For Local y:Int=0 Until mapsize
	For Local x:Int=0 Until mapsize
		Local mc:Color
		Local mr:Float
		mc = pm.GetPixel(x,y)
		mr = mc.r
		'mr = (mr*9)
		'If mr>.5 Then mr=1
		If mr<.5 Then mr/=2
		If mr>1 Then Print "to high"+mr
		If mr<0 Then Print "to low"+mr
		mc = New Color(mr,mr,mr)
		pm.SetPixel(x,y,mc)
	Next
	Next
	
	Return pm
End Function

' Taken from the mojo3d test
Function Fly( entity:Entity,view:View )

	If Keyboard.KeyDown( Key.Up )
		entity.RotateX( 1 )
	Else If Keyboard.KeyDown( Key.Down )
		entity.RotateX( -1 )
	Endif
	
	If Keyboard.KeyDown( Key.Q )
		entity.RotateZ( 1 )
	Else If Keyboard.KeyDown( Key.W )
		entity.RotateZ( -1 )
	Endif
	
	If Keyboard.KeyDown( Key.Left )
		entity.RotateY( 1,True )
	Else If Keyboard.KeyDown( Key.Right )
		entity.RotateY( -1,True )
	Endif

	If Mouse.ButtonDown( MouseButton.Left )
		If Mouse.X<view.Width/3
			entity.RotateY( 1,True )
		Else If Mouse.X>view.Width/3*2
			entity.RotateY( -1,True )
		Else
			entity.Move( New Vec3f( 0,0,.1 ) )
		Endif
	Endif
	
	If Keyboard.KeyDown( Key.A )
		entity.MoveZ( 1 )	'( New Vec3f( 0,0,.1 ) )
	Else If Keyboard.KeyDown( Key.Z )
		entity.MoveZ( -1 )	'( New Vec3f( 0,0,-.1 ) )
	Endif
		
End Function


Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End
