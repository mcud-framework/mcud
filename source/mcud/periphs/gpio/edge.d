module mcud.periphs.gpio.edge;

import mcud.core.attributes;
import mcud.core.event;

/**
Configures an edge detector.
*/
struct EdgeDetectorConfigT(RiseEvent, FallEvent, GPIO)
{
	alias _pin = GPIO;
	alias Rise = RiseEvent;
	alias Fall = FallEvent;
	/// Whether or not to detects rising edges.
	RiseEvent _riseEvent;
	/// Whether or not to detect falling edges.
	FallEvent _fallEvent;

	/**
	Lets the edge detector detect rising edges.
	*/
	EdgeDetectorConfigT!(Event, FallEvent, GPIO) detectRising(Event)(Event event)
	{
		EdgeDetectorConfigT!(Event, FallEvent, GPIO) config;
		config._riseEvent = event;
		config._fallEvent = _fallEvent;
		return config;
	}

	/**
	Lets the edge detector detect falling edges.
	*/
	EdgeDetectorConfigT!(RiseEvent, Event, GPIO) detectFalling(Event)(Event event)
	{
		EdgeDetectorConfigT!(RiseEvent, Event, GPIO) config;
		config._riseEvent = _riseEvent;
		config._fallEvent = event;
		return config;
	}

	/**
	Sets the pin to detect.
	*/
	EdgeDetectorConfigT!(RiseEvent, FallEvent, Pin) pin(Pin)(Pin pin)
	{
		EdgeDetectorConfigT!(RiseEvent, FallEvent, Pin) config;
		config._riseEvent = _riseEvent;
		config._fallEvent = _fallEvent;
		return config;
	}
}
alias EdgeDetectorConfig = EdgeDetectorConfigT!(void[], void[], void[]);

/**
Detects edges.
*/
template EdgeDetector(alias config)
{
	static assert(!is(config._pin == void[]), "No pin configured to detect");
	//static assert(config._detectFalling || config._detectRising, "No flank selected to detect");
	//static assert(config._onDetect !is null, "No function set to execute on detection");

static:
	private shared bool state = false;

	@task
	void detect()
	{
		const newState = config._pin.isOn();
		scope(exit) state = newState;
		static if (!is(config._detectRising == void[]))
		{
			if (state == false && newState == true)
				fire!(config.Rise)(config._riseEvent);
		}
		static if (!is(config._detectFalling == void[]))
		{
			if (state == true && newState == false)
				fire!(config.Fall)(config._fallEvent);
		}
	}
}