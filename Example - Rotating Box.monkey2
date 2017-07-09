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

	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		' Get the current scene
		myscene=Scene.GetCurrent()
		
		'create camera
		'
		mycamera = New Camera
		mycamera.Near = 1 '??
		mycamera.Far = 256 'how far should we render
		mycamera.Move(0,0,0) 'move the camera to position x,y,z


		'create light
		'
		mylight = New Light
		mylight.RotateX(Pi/2)	'aim directional light 'down' - Pi/2=90 degrees.

		'
		' Create cube
		'
		' This is the mesh with which we create the model.
		Local mymesh := Mesh.CreateBox( New Boxf( -2,-2,-2,2,2,2 ),1,1,1 )
		' Here we create the material that we put on the box.
		Local material:=New PbrMaterial( New Color( 1,0,0) )
		mybox = New Model( mymesh,material )
		mybox.Move(0,0,20)				


	End Method
	
	' This method is the main loop.
	Method OnRender( canvas:Canvas ) Override
	
		RequestRender()
		
		mybox.Rotate(.05,.05,.05) 'rotate the box (x,y,z)
		
		myscene.Render( canvas,mycamera ) 'render the 3d scene
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		
	End Method

End Class

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End Function
