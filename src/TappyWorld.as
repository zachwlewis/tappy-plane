package
{
import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.World;
import net.flashpunk.graphics.Backdrop;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Spritemap;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

public class TappyWorld extends World
{
	private var _player:Entity;
	private var _playerGraphic:Spritemap;
	private var _background:Backdrop;
	private var _foreground:Backdrop;
	private var _speed:Number = 200;
	private var _flap:Number = 500;
	private var _velocity:Number = 0;
	private var _gravity:Number = 1000;
	private var _terminalVelocity:Number = 2000;
	private var _playerAngle:Number;
	private var _distance:Number = 640;
	private var _dead:Boolean = false;

	public function TappyWorld()
	{
		super();
	}

	override public function begin():void
	{
		_playerGraphic = new Spritemap(Assets.RED_PLANE, 88, 73);

		_player = new Entity(0, FP.screen.height * 0.5, _playerGraphic);
		_playerGraphic.add("fly", [0,1,2,1], 20, true);
		_playerGraphic.play("fly");
		_playerGraphic.centerOrigin();
		_player.layer = -5;
		_player.setHitbox(70, 70);
		_player.centerOrigin();
		add(_player);

		// Add background.
		_background = new Backdrop(Assets.BACKGROUND, true, false);
		_background.scrollX = 0.5;
		addGraphic(_background, 10);

		// Add foreground.
		_foreground = new Backdrop(Assets.GROUND_GRASS, true, false);
		_foreground.y = FP.screen.height - _foreground.height;
		addGraphic(_foreground, 0);

		super.begin();
	}

	override public function update():void
	{
		// Handle player input.
		if (Input.pressed(Key.SPACE))
		{
			if (!_dead)
			{
				// If the player is flapping, set velocity.
				_velocity = -_flap;
			}
			else if (_player.y > FP.screen.height + 40)
			{
				// The player is dead and off-screen.
				FP.world = new TappyWorld();
			}
		}
		else
		{
			// Otherwise, add gravity.
			_velocity += _gravity * FP.elapsed;
		}

		// Clamp the velocity to a set terminal velocity.
		_velocity = Math.min(_velocity, _terminalVelocity);

		// Update speeds.
		_player.y += _velocity * FP.elapsed;
		_player.x += _speed * FP.elapsed;

		// Set graphic angle based on speed.
		_playerAngle = _speed == 0 ? 0 : Math.atan2(_velocity,_speed);
		_playerGraphic.angle = _playerAngle/FP.RAD;

		// Only update camera and collision if the player is not dead.
		if (!_dead)
		{
			// Update camera to follow player.
			camera.x = _player.x - 150;

			// Check for collision with rocks.
			if (_player.collide("rocks", _player.x, _player.y) || _player.y > FP.screen.height - 40 || _player.y < 40)
			{
				_dead = true;
				_speed = -50;
				_velocity = -_flap;

				// Stop flying.
				_playerGraphic.rate = 0;
			}

			if (camera.x + 640 >= _distance)
			{
				_distance += 320 + FP.rand(320);
				var _rocks:Rocks = Rocks(create(Rocks,true));
				_rocks.init(_distance);
			}
		}

		super.update();
	}
}
}
