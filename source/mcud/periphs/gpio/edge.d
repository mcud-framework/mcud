// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.periphs.gpio.edge;

import mcud.core;
import mcud.meta.device;

/**
Configures an edge detector.
*/
struct EdgeDetectorConfig
{
	bool _detectRising = false;
	bool _detectFalling = false;
	Device _pin = Device.empty;

	/**
	Lets the edge detector detect rising edges.
	*/
	EdgeDetectorConfig detectRising()
	{
		_detectRising = true;
		return this;
	}

	/**
	Lets the edge detector detect falling edges.
	*/
	EdgeDetectorConfig detectFalling()
	{
		_detectFalling = true;
		return this;
	}

	/**
	Sets the pin to detect.
	*/
	EdgeDetectorConfig pin(Pin)(Pin pin)
	{
		_pin = Device.of!Pin;
		return this;
	}
}


/**
Detects edges.
*/
struct EdgeDetector(EdgeDetectorConfig config)
{
	static assert(config._detectFalling || config._detectRising, "No flank selected to detect");
	static assert(config._pin != Device.empty, "No device selected");

static:
	private shared bool state = false;
	private alias _pin = getDevice!(Device(config._pin));

	/**
	Fired if a falling edge is detected.
	*/
	struct Falling {}

	/**
	Fired if a rising edge is detected.
	*/
	struct Rising {}

	@task
	void detect()
	{
		stopTask!detect();
		_pin.isOn();
	}

	void start()
	{
		_pin.start();
		startTask!detect();
	}

	void stop()
	{
		_pin.stop();
		stopTask!detect();
	}

	@event!(_pin.InputHigh)
	void ifHigh()
	{
		startTask!detect();
		static if (!is(config._detectRising == void[]))
		{
			if (state == false)
				fire!Rising;
		}
		state = true;
	}

	@event!(_pin.InputLow)
	void ifLow()
	{
		startTask!detect();
		static if (!is(config._detectFalling == void[]))
		{
			if (state == true)
				fire!Falling;
		}
		state = false;
	}
}