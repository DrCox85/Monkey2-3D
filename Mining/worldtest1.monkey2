#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
 
Using std..
Using mojo..
Using mojo3d..

Class chunk
	Field model:Model
	Field x:Int,y:Int,z:Int
	Field deleteme:Bool
	Method New(x:Int,y:Int,z:Int,model:Model)
		Self.x = x
		Self.y = y
		Self.z = z		
		Self.model=model
	End Method
End Class
 
Class MyWindow Extends Window
	
	Field chunklist:List<chunk>
	
	Field _scene:Scene
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _model:Model
	
	Field _rectCanvas:Canvas
	Field _rectImage:Image	

 	Field chunkwidth:Int=16
 	Field chunkheight:Int=16
 	Field chunkdepth:Int=16

	Field worldwidth:Int=600
	Field worldheight:Int=80
	Field worlddepth:Int=600
	Field worldmap:Int[,,]

	

	Method New()

		Local t:Time=Time.Now()
		Local ts:String=t.ToString()
		Local a:Int = Int(ts.Slice(16))+Microsecs()
		
		SeedRnd(a)
		
		worldmap = New Int[worldwidth,worldheight,worlddepth]
		generateworld()
		chunklist = New List<chunk>
		'get scene
		'
		_scene=Scene.GetCurrent()
 
		'create camera
		'
		_camera=New Camera
		_camera.Near=.1
		_camera.Far=1000
		_camera.Move( 50,50,35 )
		_camera.PointAt(New Vec3f(0,50,0))
		
		
		'create light
		'
		_light=New Light
		_light.Move(110,110,120)
		_light.PointAt(New Vec3f(0,0,0))
'		_light.RotateX( 90 )	'aim directional light downwards - 90 degrees.
	 	
	 	'Local x:Int=0
	 	'Local y:Int=0
	 	'Local z:Int=0
		'Local model:=createmodel(x*chunkwidth,y*chunkheight,z*chunkdepth)	 	
		updateworld()	 		
	End Method
	
	Method createmodel:Model(worldx:Int,worldy:Int,worldz:Int)
		Local model:Model
		
		'Here we create our chunk array
		'Local chunk:Int[,,] = New Int[chunkwidth,chunkheight,chunkdepth]

	
		'Here we create our chunk mesh
		
		Local chunkmesh:= New Mesh()
		For Local z:Int=0 Until chunkdepth
		For Local y:Int=0 Until chunkheight
		For Local x:Int=0 Until chunkwidth
			Local z2:Int=z+worldz
			Local y2:Int=y+worldy
			Local x2:Int=x+worldx
			If z2<0 Or y2<0 Or x2<0 Or z2>=worlddepth Or y2>=worldheight Or x2>=worldwidth Then Continue
			If worldmap[x2,y2,z2] <> 0 Then 
				Local sides:Bool[] = New Bool[6]
				If z2-1>=0 And worldmap[x2,y2,z2-1] <> 0 Then sides[0] = False Else sides[0] = True
				If x2-1>=0 And worldmap[x2-1,y2,z2] <> 0 Then sides[1] = False Else sides[1] = True
				If z2+1<chunkdepth And worldmap[x2,y2,z2+1] <> 0 Then sides[2] = False Else sides[2] = True
				If x2+1<chunkwidth And worldmap[x2+1,y2,z2] <> 0 Then sides[3] = False Else sides[3] = True
				If y2+1<chunkheight And worldmap[x2,y2+1,z2] <> 0 Then sides[4] = False Else sides[4] = True
				If y2-1>=0 And worldmap[x2,y2-1,z2] <> 0 Then sides[5] = False Else sides[5] = True				
				Local mesh2:=createcube(x2*2,y2*2,z2*2,sides)								
				chunkmesh.AddMesh(mesh2)
			endif
		Next
		Next
		Next 
		' Here we create our model containing the chunk
		chunkmesh.UpdateNormals()
		model=New Model
		model.Mesh=chunkmesh
		Local col:Color
		Local r:Float=Rnd()
		If r>.8
		col = Color.Yellow.Blend(Color.White,Rnd())
		Elseif r<.5
		col = Color.Grey.Blend(Color.White,Rnd())
		Else
		col = Color.Brown.Blend(Color.White,Rnd())
		End If	
		
		model.Material=New PbrMaterial( col )'Color.Green )
		
		Return model
		'_model.Material.CullMode=CullMode.None
 		'_model.Move(2,0,0)
'		_model.Mesh=chunkmesh
'		_model.Materials = _model.Materials.Resize(chunkmesh.NumMaterials)	
'
'	 	Local sm:= New PbrMaterial()
'		
'		_rectImage=New Image( 256, 256 )
'	 
'		_rectCanvas=New Canvas( _rectImage )
'	
'		sm.ColorTexture = _rectImage.Texture
'	 	sm.ColorTexture.Flags = TextureFlags.FilterMipmap	
'		'sm.CullMode=CullMode.None
'	 
' 
'		_model.Materials[chunkmesh.NumMaterials - 1] = sm
'				
	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		'RenderTexture()
		'_model.RotateY( 1 )
		'_model.RotateZ( -1 )
		'_model.RotateX( 1 )
		'controls()
		Fly(_camera)
		updateworld()
		'_scene.Update()
		_scene.Render( canvas,_camera )
 		 		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		canvas.DrawText( "mx"+_camera.Position.x/chunkwidth+", my="+_camera.Position.y/chunkheight+", FPS="+_camera.Position.z/chunkdepth,0,30 )
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method

Method updateworld()	 	
		Local x2:Int=(_camera.Position.x/2) / chunkwidth
		Local z2:Int=(_camera.Position.z/2) / chunkdepth
		Local y2:Int=(_camera.Position.y/2) / chunkheight
		'Print x2+","+y2+","+z2
		Local mlx:Stack<Int> = New Stack<Int>
		Local mly:Stack<Int> = New Stack<Int>
		Local mlz:Stack<Int> = New Stack<Int>
		For Local z3:Int=z2-2 To z2+2
		For Local y3:Int=y2-2 To y2+2
		For Local x3:Int=x2-2 To x2+2
			If x3<0 Or y3<0 Or z3<0 Then Continue
			Local makeit:Bool=True
			For Local i:=Eachin chunklist
				If i.x = x3 And i.y = y3 And i.z = z3 Then makeit = False
			Next
			If makeit = True
				mlz.Push(z3)
				mly.Push(y3)
				mlx.Push(x3)
			End If
		Next
		Next
		Next
		'For Local i:int=0 Until 6
		'chunklist.Add(New chunk(5,5,5,createmodel(i*chunkwidth,i*chunkheight,i*chunkdepth))						)
		'Next
		For Local i:Int=0 Until mlx.Length
			Local x:Int=mlx.Get(i)			
			Local y:Int=mly.Get(i)
			Local z:Int=mlz.Get(i)'			
			'Local model:=createmodel(x*chunkwidth,y*chunkheight,z*chunkdepth)
			chunklist.Add(New chunk(x,y,z,createmodel(x*chunkwidth,y*chunkheight,z*chunkdepth))						)
		Next

		' If distance between chunks and camera is to large then remove them		
		For Local i:=Eachin chunklist
			If distance(i.x,i.z,_camera.Position.x/2/chunkwidth,_camera.Position.z/2/chunkdepth) > 5
				i.model.Destroy()
				i.deleteme = True
			End If
		Next
		For Local i:=Eachin chunklist
			If i.deleteme = True Then chunklist.Remove(i)
		Next
End Method


	'sides (0-front,1=left,2=back,3=right,4=top,5=bottom)
	'x,y,z is location in the chunk
	Method createcube:Mesh(x:Float=0,y:Float=0,z:Float=0,sides:Bool[])
		
		'create cube mesh
		'
		Local vertices:=New Vertex3f[8]
		vertices[0].position=New Vec3f( -1+x, 1+y,-1+z )'left front top
		vertices[1].position=New Vec3f(  1+x, 1+y,-1+z )'right front top
		vertices[2].position=New Vec3f(  1+x,-1+y,-1+z )'right front bottom
		vertices[3].position=New Vec3f( -1+x,-1+y,-1+z )'left front bottom
		vertices[4].position=New Vec3f( -1+x, 1+y, 1+z )'left back top
		vertices[5].position=New Vec3f( -1+x,-1+y, 1+z )'left back bottom
 		vertices[6].position=New Vec3f(  1+x, 1+y, 1+z )'right back top
 		vertices[7].position=New Vec3f(  1+x,-1+y, 1+z )'right back bottom


'  Texture coordinates represent coordinates within the image, where 
'	0,0=top left, 1,0=top right, 1,1=bottom right, 0,1=bottom left
		vertices[0].texCoord0 = New Vec2f(0,0)
		vertices[1].texCoord0 = New Vec2f(1,0)
		vertices[2].texCoord0 = New Vec2f(1,1)
		vertices[3].texCoord0 = New Vec2f(0,1)
		
		vertices[4].texCoord0 = New Vec2f(1,0)
		vertices[5].texCoord0 = New Vec2f(0,1)
		vertices[6].texCoord0 = New Vec2f(0,0)
		vertices[7].texCoord0 = New Vec2f(0,1)		 		

 		Local inds:Int=0
 		For Local i:Int=0 Until 6
	 		If sides[i] = True Then inds+=6
	 	Next
 		
		Local indices:=New UInt[inds]
		
		Local cnt:Int=0
		'front
		If sides[0] = True
		indices[cnt]=0;cnt+=1
		indices[cnt]=1;cnt+=1
		indices[cnt]=2;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=2;cnt+=1
		indices[cnt]=3;cnt+=1
		End if
		If sides[1] = True
		' left side
		indices[cnt]=4;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=5;cnt+=1
		End If
		If sides[2] = True
		'back side
		indices[cnt]=6;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=5;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=5;cnt+=1
		indices[cnt]=7;cnt+=1
		End If
		If sides[3] = True
		'right side
		indices[cnt]=1;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=1;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=2;cnt+=1
		End If
		If sides[4] = True
		'top side
		indices[cnt]=0;cnt+=1
		indices[cnt]=4;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=0;cnt+=1
		indices[cnt]=6;cnt+=1
		indices[cnt]=1;cnt+=1
		End If
		If sides[5] = true
		'bottom side
		indices[cnt]=7;cnt+=1
		indices[cnt]=5;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=7;cnt+=1
		indices[cnt]=3;cnt+=1
		indices[cnt]=2;cnt+=1
		End If
				
		Return New Mesh( vertices,indices )		
		
	End Method
	
	Method controls()
		If Keyboard.KeyDown(Key.W) Then _camera.Move(0,0,.5)
		If Keyboard.KeyDown(Key.S) Then _camera.Move(0,0,-.5)
		If Keyboard.KeyDown(Key.A) Then _camera.Move(-.5,0,0)
		If Keyboard.KeyDown(Key.D) Then _camera.Move(.5,0,0)
		If Keyboard.KeyDown(Key.Up) Then _camera.Rotate(1,0,0)
		If Keyboard.KeyDown(Key.Down) Then _camera.Rotate(-1,0,0)
		If Keyboard.KeyDown(Key.Left) Then _camera.Rotate(0,1,0)
		If Keyboard.KeyDown(Key.Right) Then _camera.Rotate(0,-1,0)
	End Method
	
	Method RenderTexture()
		If Not _rectCanvas Then
			_rectCanvas=New Canvas( _rectImage )
 
		Endif
		
		'This should be orange with white text on
		'But since I'm drawing something in the top left corner -
		'I'm just getting that top left pixel on the entire rectangle
		
		_rectCanvas.Clear( Color.Blue )
		_rectCanvas.Color = Color.White
		_rectCanvas.DrawText( "Hello World", Rnd(8,12), 8 )
		_rectCanvas.Color = Color.Orange
		_rectCanvas.DrawRect( 50, 50 , 200 ,90) 'White in the top left
		
		
		
		_rectCanvas.Flush()
		
	End	Method
	
	Method generateworld()
		For Local z:Int=0 Until worlddepth
		For Local x:Int=0 Until worldwidth
		For Local y:Int=0 Until 15
			worldmap[x,y,z] = 1
		Next
		Next
		Next

	'	For Local i:Int=0 Until 50000
	'		worldmap[Rnd(worldwidth),Rnd(worldheight),Rnd(worlddepth)] = 1
	'	Next
		
		'mountains
		
		 For Local xii:Int=0 Until (worldwidth+worlddepth)
			Local under:Bool=False
			If Rnd()<.5 Then under=True
			Local x:Float=Rnd(worldwidth)
			Local y:Float=15
			Local z:Float=Rnd(worlddepth)
			Local dx:Float=Rnd(-1,1)
			Local dy:Float=Rnd(-1,1)
			Local dz:Float=Rnd(-1,1)
			Local lenny:Int=Rnd(150,300)
			For Local i:Int=0 Until lenny
				x+=dx
				y+=dy
				z+=dz
				If Rnd() < .2 Then dx = Rnd(-1,1)
				If Rnd() < .2 Then dy = Rnd(-1,.5)
				If Rnd() < .2 Then dz = Rnd(-1,1)
				If x<0 Or y<0 Or z<0 Or x>worldwidth Or y>worldheight Or z>worlddepth Then Continue
				
				If under=False And x>=10 And y+4>=10 And z>=10 And x<worldwidth-10 And y+4<worldheight-10 And z<worlddepth-10
					'If worldmap[x+(dx*10),y+4,z+(dz*10)] = 0 Then dy=-1
					If y>worldheight/3 Then dy=-1
				End If
				
				Local bg:Int=-3
				If y<16 Then bg=Rnd(-10,-5)		
				If under=True Then bg=Rnd(-3,-1)
				
				For Local y1:Int=bg/2 To Abs(bg/2)
				For Local x1:Int=Rnd(bg,-1) To Rnd(1,Abs(bg))
				For Local z1:Int=Rnd(bg,-1) To Rnd(1,Abs(bg))
					Local x2:Int=x+x1
					Local y2:Int=y+y1
					Local z2:Int=z+z1
					If x2<=0 Or y2<0 Or z2<0 Or x2>=worldwidth Or y2>=worldheight Or z2>=worlddepth Then Continue
					'If Rnd() < .9 Then
					If under=False Then
						worldmap[x2,y2,z2] = 1
					Else
						If worldmap[x2,y2,z2] = 1 Then worldmap[x2,y2,z2] = 0
					End if
					'End If
				Next
				Next
				Next
			Next
		Next		
		
		
		
		
		
	End Method
	
	Function Fly( entity:Entity)
		
		Const rspeed:=2.0
	
		If Keyboard.KeyDown( Key.Up )
			entity.RotateX( rspeed )
		Else If Keyboard.KeyDown( Key.Down )
			entity.RotateX( -rspeed )
		Endif
		
		If Keyboard.KeyDown( Key.A )
			entity.RotateZ( rspeed )
		Else If Keyboard.KeyDown( Key.D )
			entity.RotateZ( -rspeed )
		Endif
		
		If Keyboard.KeyDown( Key.Left )
			entity.RotateY( rspeed,True )
		Else If Keyboard.KeyDown( Key.Right )
			entity.RotateY( -rspeed,True )
		Endif
	
		If Mouse.ButtonDown( MouseButton.Left )
			'If Mouse.X<view.Width/3
				entity.RotateY( rspeed,True )
			'Else If Mouse.X>view.Width/3*2
				entity.RotateY( -rspeed,True )
			'Else
			'	entity.Move( New Vec3f( 0,0,.1 ) )
			'Endif
		Endif
		
		If Keyboard.KeyDown( Key.W )
			entity.MoveZ( .4 )
		Else If Keyboard.KeyDown( Key.S )
			entity.MoveZ( -.4 )
		Endif
			
	End Function
		
	
	
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)   
    	Return Abs(x2-x1)+Abs(y2-y1)   
    End Function 	
	
End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()	
End
