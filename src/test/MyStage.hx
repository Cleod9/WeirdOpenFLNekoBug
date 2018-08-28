package test;

class MyStage 
{
	public var instance:Dynamic;
	
	public function new(value:Dynamic = null) 
	{
		instance = value;
	}
	public function addChild(child:MySprite):Void
	{
		trace(Type.getClassName(Type.getClass(this))); // Somehow prints test.MyStageWrapper ?????
		
		// Workaround 1
		//var spr = child.get_sprite();
		//instance.addChild(spr);
		
		// Workaround 2
		//instance.addChild(child.sprite);
		
		// Broken
		instance.addChild(child.get_sprite());
	}
	public function get_instance():Dynamic
	{
		return instance;
	}
	
}