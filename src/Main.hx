import openfl.display.Sprite;
import openfl.text.TextField;
import test.MySpriteWrapper;
import test.MyStageWrapper;

class Main extends Sprite 
{

	public function new() 
	{
		super();
		
		var text:TextField = new TextField();
		text.textColor = 0xffffff;
		text.text = "Worked!";
		
		var fakeSprite:MySpriteWrapper = new MySpriteWrapper(text);
		var fakeStage:MyStageWrapper = new MyStageWrapper(stage);
		fakeStage.addChild(fakeSprite);
	}

}
