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
		_model=New Model
		_model.Mesh=mesh
		_model.Material=New PbrMaterial( Color.Red )
		_model.Material.CullMode=CullMode.None
 
	End
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		
		_model.RotateY( .1 )
		
		_scene.Render( canvas,_camera )
 
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
	End
	
End
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
