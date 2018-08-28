class Main 
{

	public static function main() 
	{
		// Create the outer wrapper
		var master1:ObjOuterWrapper = new ObjOuterWrapper(new WrappedObject());
		var master2:ObjOuterWrapper = new ObjOuterWrapper(new WrappedObject());
		
		// Pass another object that the outer wrapper will forward to the inner wrapper
		master1.a(master2.get_inner_wrapper());
		
		// If it makes it this far it works
		trace("Worked!");
	}

}
