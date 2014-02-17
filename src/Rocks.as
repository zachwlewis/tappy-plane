package
{
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Graphiclist;
import net.flashpunk.graphics.Image;
import net.flashpunk.masks.Hitbox;
import net.flashpunk.masks.Masklist;

public class Rocks extends Entity
{
	private var _topImage:Image;
	private var _bottomImage:Image;
	private var _topHitbox:Hitbox;
	private var _bottomHitbox:Hitbox;
	private static const _maxOffset:Number = 200;

	public function Rocks(x:Number = 0, gap:Number = 400)
	{
		_topImage = new Image(Assets.SKY_ROCK);
		_bottomImage = new Image(Assets.GROUND_ROCK);

		_topHitbox = new Hitbox(6, 1, _topImage.scaledWidth * 0.5 - 3, 0);
		_bottomHitbox = new Hitbox(6, 1, _bottomImage.scaledWidth * 0.5 - 3, 0);

		type = "rocks";

		layer = 5;

		super(x, 0, new Graphiclist(_topImage, _bottomImage) , new Masklist(_topHitbox, _bottomHitbox));
	}

	public function init(x:Number = 0, gap:Number = 400):void
	{
		// Determine the position of the gap.
		var gapTop:Number = FP.rand(FP.screen.height - 2 * _maxOffset - gap) + _maxOffset;

		// Size and position the rocks.
		_topImage.scaledHeight = gapTop;
		_bottomImage.scaledHeight = FP.screen.height - gap - gapTop
		_bottomImage.y = FP.screen.height - _bottomImage.scaledHeight;

		// Size and position the hitboxes.
		_topHitbox.height = uint(_topImage.scaledHeight);
		_bottomHitbox.height = uint(_bottomImage.scaledHeight);
		_bottomHitbox.y = _bottomImage.y;

		this.x = x;
	}

	override public function update():void
	{
		if (FP.camera.x > x + 100)
		{
			world.recycle(this);
		}
	}
}
}
