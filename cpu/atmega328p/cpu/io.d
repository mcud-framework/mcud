module cpu.io;

import mcud.core.attributes;

/**
An ATmega IO device
*/
template IO(ubyte address)
{
	private enum accessor = cast(ubyte*) (0x4000_0000 + address);

	@forceinline
	ubyte get()
	{
		return *accessor;
	}

	@forceinline
	void set(ubyte value)
	{
		*accessor = value;
	}

	static if (address <= 0x1F)
	{
		@forceinline
		bool getBit(ubyte bit)
		{
			return (*accessor >> bit) & 1;
		}

		@forceinline
		void setBit(ubyte bit)
		{
			*accessor |= (1 << bit);
		}

		@forceinline
		void clearBit(ubyte bit)
		{
			*accessor &= ~(1 << bit);
		}
	}
}