package mobile.flixel;

import flixel.graphics.frames.FlxTileFrames;
import mobile.flixel.input.FlxMobileInputManager;
import mobile.flixel.FlxButton;
import flixel.math.FlxPoint;
import mobile.backend.VirtualPadDatas;

/**
 * A gamepad.
 * It's easy to customize the layout.
 *
 * @original author Ka Wing Chin & Mihai Alexandru
 * @modification's author: Karim Akra & Lily (mcagabe19)
 */
class FlxVirtualPadNew extends FlxMobileInputManager
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]);
	public var buttonUp:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.UP, FlxMobileInputID.noteUP]);
	public var buttonRight:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]);
	public var buttonDown:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]);
	public var buttonLeft2:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.LEFT2, FlxMobileInputID.noteLEFT]);
	public var buttonUp2:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.UP2, FlxMobileInputID.noteUP]);
	public var buttonRight2:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.RIGHT2, FlxMobileInputID.noteRIGHT]);
	public var buttonDown2:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.DOWN2, FlxMobileInputID.noteDOWN]);
	public var buttonA:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.A]);
	public var buttonB:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.B]);
	public var buttonC:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.C]);
	public var buttonD:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.D]);
	public var buttonE:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.E]);
	public var buttonF:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.F]);
	public var buttonG:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.G]);
	public var buttonS:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.S]);
	public var buttonV:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.V]);
	public var buttonX:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.X]);
	public var buttonY:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.Y]);
	public var buttonZ:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.Z]);
	public var buttonP:FlxButton = new FlxButton(0, 0, [FlxMobileInputID.P]);
	public var buttonExtra:FlxButton = new FlxButton(0, 0);
	public var buttonExtra2:FlxButton = new FlxButton(0, 0);

	var storedButtonsIDs:Map<String, Array<FlxMobileInputID>> = new Map<String, Array<FlxMobileInputID>>();

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:String, Action:String, ?Extra:ExtraActions = NONE)
	{
		super();

		for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), FlxButton))
				storedButtonsIDs.set(button, Reflect.getProperty(Reflect.field(this, button), 'IDs'));
		}
        if(DPad != "NONE"){
            for(buttonData in VirtualPadDatas.dpadModes.get(DPad).buttons){
                Reflect.setField(this, buttonData.button, createButton(buttonData.x, buttonData.y, buttonData.width, buttonData.height, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));
                add(Reflect.field(this, buttonData.button));
            }
        }

        if(Action != "NONE"){
            for(buttonData in VirtualPadDatas.actionModes.get(Action).buttons){
                Reflect.setField(this, buttonData.button, createButton(buttonData.x, buttonData.y, buttonData.width, buttonData.height, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));
                add(Reflect.field(this, buttonData.button));
            }
        }

		switch (Extra)
		{
			case SINGLE:
				add(buttonExtra = createButton(0, FlxG.height - 135, 132, 127, 's', 0xFF0066FF));
				setExtrasPos();
			case DOUBLE:
				add(buttonExtra = createButton(0, FlxG.height - 135, 132, 127, 's', 0xFF0066FF));
				add(buttonExtra2 = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'g', 0xA6FF00));
				setExtrasPos();
			case NONE: // nothing
		}

		for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), FlxButton))
				Reflect.setProperty(Reflect.getProperty(this, button), 'IDs', storedButtonsIDs.get(button));
		}
		scrollFactor.set();
		updateTrackedButtons();
	}

	public function setExtrasDefaultPos()
	{
		var int:Int = 0;

		if (FlxG.save.data.extraData == null)
			FlxG.save.data.extraData = new Array();

		for (button in Reflect.fields(this))
		{
			if (button.toLowerCase().contains('extra') && Std.isOfType(Reflect.field(this, button), FlxButton))
			{
				var daButton = Reflect.field(this, button);
				if (FlxG.save.data.extraData[int] == null)
					FlxG.save.data.extraData.push(FlxPoint.get(daButton.x, daButton.y));
				else
					FlxG.save.data.extraData[int] = FlxPoint.get(daButton.x, daButton.y);
				++int;
			}
		}
		FlxG.save.flush();
	}

	public function setExtrasPos()
	{
		var int:Int = 0;
		if (FlxG.save.data.extraData == null)
			return;

		for (button in Reflect.fields(this))
		{
			if (button.toLowerCase().contains('extra') && Std.isOfType(Reflect.field(this, button), FlxButton))
			{
				var daButton = Reflect.field(this, button);
				daButton.x = FlxG.save.data.extraData[int].x;
				daButton.y = FlxG.save.data.extraData[int].y;
				int++;
			}
		}
	}

	private function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?Color:Int = 0xFFFFFF):FlxButton
	{
		var button = new FlxButton(X, Y);
		button.frames = FlxTileFrames.fromFrame(Paths.getSparrowAtlas('virtualpad').getByName(Graphic), FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.moves = false;
		button.scrollFactor.set();
		button.color = Color;
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.tag = Graphic.toUpperCase();
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}

	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);
		buttonLeft2 = FlxDestroyUtil.destroy(buttonLeft2);
		buttonUp2 = FlxDestroyUtil.destroy(buttonUp2);
		buttonDown2 = FlxDestroyUtil.destroy(buttonDown2);
		buttonRight2 = FlxDestroyUtil.destroy(buttonRight2);
		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
		buttonD = FlxDestroyUtil.destroy(buttonD);
		buttonE = FlxDestroyUtil.destroy(buttonE);
		buttonF = FlxDestroyUtil.destroy(buttonF);
		buttonG = FlxDestroyUtil.destroy(buttonG);
		buttonS = FlxDestroyUtil.destroy(buttonS);
		buttonV = FlxDestroyUtil.destroy(buttonV);
		buttonX = FlxDestroyUtil.destroy(buttonX);
		buttonY = FlxDestroyUtil.destroy(buttonY);
		buttonZ = FlxDestroyUtil.destroy(buttonZ);
		buttonP = FlxDestroyUtil.destroy(buttonP);
		buttonExtra = FlxDestroyUtil.destroy(buttonExtra);
		buttonExtra2 = FlxDestroyUtil.destroy(buttonExtra2);
	}
}