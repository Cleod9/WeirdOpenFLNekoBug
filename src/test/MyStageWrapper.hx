package test;

class MyStageWrapper 
{
	public var stage:Dynamic;
	
	public function new(value:Dynamic = null) 
	{
		stage = new MyStage(value);
	}
	public function addChild(value:MySpriteWrapper):Void
	{
		// Workaround 1
		//var ins = value.get_instance();
		//stage.addChild(ins);
		
		// Workaround 2
		//stage.addChild(value.instance);
		
		// Broken
		stage.addChild(value.get_instance());
	}
	
}