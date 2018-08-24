package test;

class MySpriteWrapper 
{
	public var instance:MySprite;

	public function new(value:Dynamic = null) 
	{
		instance = new MySprite(value);
	}
	public function get_instance():Dynamic
	{
		return instance;
	}
	
}