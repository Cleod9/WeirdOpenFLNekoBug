package test;

class MySprite 
{
	public var sprite:Dynamic;
	
	public function new(value:Dynamic = null) 
	{
		sprite = value;
	}
	
	public function get_sprite():Dynamic
	{
		return sprite;
	}
}