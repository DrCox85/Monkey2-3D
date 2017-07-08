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
	
	Field _terrain:Terrain
	
	Field _water:Model
	
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
		
		
		If _terrain Then _terrain.Destroy()
		If _camera Then _camera.Destroy()
		If _light Then _light.Destroy()
		If _material Then _material.Discard()		
		If _scene Then 
			_scene.Terrains.Clear()
			
		End If
			
		
		
		_scene = Scene.GetCurrent()
		
		
		_fog=New FogEffect( Color.Black,480,512 )
		
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
		

		Local waterMaterial:=New WaterMaterial
		waterMaterial.ScaleTextureMatrix( 10,10 )
		waterMaterial.ColorTexture=Texture.ColorTexture( Color.SeaGreen )
		waterMaterial.Roughness=0
		waterMaterial.Velocities=New Vec2f[]( 
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		_water=Model.CreateBox( New Boxf( -mapsize,1,-mapsize,mapsize,5,mapsize ),1,1,1,waterMaterial )


		
		_material = New PbrMaterial( New Color(.5,.05,0),1,0.5 )
		_material.ScaleTextureMatrix( 32,32 )
		
		
		Local heightMap:= New Pixmap(mapsize,mapsize)
		heightMap = makeheightmap()		
		
		_terrain=New Terrain( heightMap,New Boxf( -mapsize,0,-mapsize,mapsize,64,mapsize ),_material )
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

	' This is a lambda function that increases the 
	' color on the pixmap by a bit. 
	Local myrect:=Lambda(x1:int,y1:Int,w:Int,h:Int)
		Local inc:Float=Rnd(-0.1,0.1)
		For Local y2:=y1 Until y1+h
		For Local x2:=x1 Until x1+w
			If x2>=0 And x2<mapsize And y2>=0 And y2<mapsize
				
				Local mc:Color
				mc = pm.GetPixel(x2,y2)				
				Local r:Float=mc.r + inc
				Local g:Float=mc.g + inc
				Local b:Float=mc.b + inc
				If r>1 Then r=1
				If g>1 Then g=1
				If b>1 Then b=1
				If r<0 Then r=0
				If g<0 Then g=0
				If b<0 Then b=0
				pm.SetPixel(x2,y2,New Color(r,g,b))
			End If
		Next
		Next
	End Lambda
	
	' This lambda takes one input coordinate where
	' it takes a color and next and below it also a color
	' this then is avaraged(divided by 3) and put back
	' on the pixmap(blurring/smoothing it)
	' 
	Local blur:=Lambda(x1:Int,y1:Int)
		Local c1:Color = pm.GetPixel(x1,y1)		
		Local c2:Color = pm.GetPixel(x1+1,y1)
		Local c3:Color = pm.GetPixel(x1,y1+1)
		Local nr:Float=(c1.r+c2.r+c3.r)/3
		pm.SetPixel(x1,y1,New Color(nr,nr,nr))
	End Lambda
	
	' Here we create a map
	For Local i:=0 Until (mapsize*mapsize)/200
		Local x:Int=Rnd(-50,mapsize)
		Local y:Int=Rnd(-50,mapsize)
		Local w:Int=Rnd(5,mapsize/4)
		Local h:Int=Rnd(5,mapsize/4)
		myrect(x,y,w,h)
	Next

	'blur some
 	For Local i:=0 Until (mapsize*mapsize)*3
		blur(Rnd(1,mapsize-1),Rnd(1,mapsize-1))
	Next

	For Local y:Int = 4 Until mapsize-5
	For Local x:Int = 4 Until mapsize-5
		If pm.GetPixel(x,y).r < .25 And pm.GetPixel(x,y).r >.15
			Local h:Float=.16
			pm.SetPixel(x,y,New Color(h,h,h))
		End If
	Next
	Next

	For Local y:Int = 0 Until mapsize-2
	For Local x:Int = 0 Until mapsize-2
		If pm.GetPixel(x,y).r < .5 And pm.GetPixel(x,y).r > .30
		Local h:Float=.31
		pm.SetPixel(x,y,New Color(h,h,h))		
		End If

	Next
	Next
'
	'blur some
 	For Local i:=0 Until (mapsize*mapsize)*3
		blur(Rnd(1,mapsize-1),Rnd(1,mapsize-1))
	Next

	Return pm
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
