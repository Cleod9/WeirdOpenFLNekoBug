class ObjInnerWrapper 
{
	// Workaround 3
	// public var instance:WrappedObject;
	
	public var instance:Dynamic;
	
	public function new(value:Dynamic = null) 
	{
		instance = value;
	}
	public function a(value:Dynamic):Void
	{
		trace("ObjInnerWrapper reported as: " + Type.getClassName(Type.getClass(this))); // Somehow prints ObjOuterWrapper ?????
		
		instance.a(value);
	}
	public function get_instance():Dynamic
	{
		return instance;
	}
}