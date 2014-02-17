package {
import net.flashpunk.Engine;
import net.flashpunk.FP;

[SWF(width="320", height="568")]
public class TappyPlane extends Engine {

    public function TappyPlane() {
	    super(640, 1136);
    }

	override public function init():void
	{
		// Downscaling from iPhone 5 resolution to fit on most screens.
		FP.screen.scale = .5;

		// Create a new TappyWorld to start!
		FP.world = new TappyWorld();
		super.init();
	}
}
}
