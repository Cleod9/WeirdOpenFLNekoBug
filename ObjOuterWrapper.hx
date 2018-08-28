class ObjOuterWrapper 
{
	// Workaround 3
	// public var inner_wrapper:ObjInnerWrapper;

	public var inner_wrapper:Dynamic;
	
	public function new(value:Dynamic = null) 
	{
		inner_wrapper = new ObjInnerWrapper(value);
	}
	public function a(value:Dynamic):Void
	{
		// Workaround 1
		//var ins = value.get_instance();
		//inner_wrapper.a(ins);
		
		// Workaround 2
		//inner_wrapper.a(value.instance);
		
		// Broken
		inner_wrapper.a(value.get_instance());
	}
	public function get_inner_wrapper():Dynamic
	{
		return inner_wrapper;
	}
	
}