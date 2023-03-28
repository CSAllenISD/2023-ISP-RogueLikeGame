[gd_resource type="TileSet" load_steps=4 format=2]

[ext_resource path="res://assets/grass.png" type="Texture" id=1]
[ext_resource path="res://assets/stone.png" type="Texture" id=2]

[sub_resource type="ConvexPolygonShape2D" id=1]

custom_solver_bias = 0.0
points = PoolVector2Array( -16, -16, 16, -16, 16, 16, -16, 16 )

[resource]

0/name = "Grass"
0/texture = ExtResource( 1 )
0/tex_offset = Vector2( 0, 0 )
0/modulate = Color( 1, 1, 1, 1 )
0/region = Rect2( 0, 0, 35, 34 )
0/is_autotile = false
0/occluder_offset = Vector2( 17.5, 17 )
0/navigation_offset = Vector2( 17.5, 17 )
0/shapes = [  ]
1/name = "Stone"
1/texture = ExtResource( 2 )
1/tex_offset = Vector2( 0, 0 )
1/modulate = Color( 1, 1, 1, 1 )
1/region = Rect2( 0, 0, 32, 32 )
1/is_autotile = false
1/occluder_offset = Vector2( 16, 16 )
1/navigation_offset = Vector2( 16, 16 )
1/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"shape": SubResource( 1 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 16, 16 )
} ]
