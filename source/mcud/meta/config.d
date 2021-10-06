module mcud.meta.config;

import std.format;
import std.meta;

mixin template Config(Fields...)
{
	static foreach (field; Fields)
	{
		static if (field._type == "field")
			mixin(format!("%s f_%s;")(field._value.stringof, field._name));
		else static if (field._type == "peripheral")
			mixin(format!("alias f_%s = %s;")(field._name, field._value.stringof));
		else
			static assert(0, "Illegal field type");
	}

	auto set(string member, T)(T value)
	{
		template isField(field)
		{
			enum isField = field._name == member;
		}
		static assert(anySatisfy!(isField, Fields), format!"Field '%s' not found"(member));

		static foreach (field; Fields)
		{
			static if (field._name == member)
			{
				static if (field._type == "field")
				{
					__traits(getMember, this, "f_"~member) = value;
					return this;
				}
				else static if (field._type == "peripheral")
				{
					type!(member, T) config;
					static foreach (fieldB; Fields)
					{
						static if (fieldB._type == "field")
							mixin(format!("config.f_%s = f_%s;")(fieldB._name, fieldB._name));
					}
					return config;
				}
				else
					static assert(0, "Illegal field type");
			}
		}
	}

	template type(string member, T)
	{
		template MapPeripheral(field)
		{
			static if (field._name == member)
				alias MapPeripheral = peripheral!(member, T);
			else
				alias MapPeripheral = field;
		}
		alias type = staticMap!(MapPeripheral, Fields);
	}
}

template field(Type, string name)
{
	struct field
	{
		enum _type = "field";
		enum _name = name;
		alias _value = Type;
	}
}

template peripheral(string name, Value = void[])
{
	//alias peripheral = AliasSeq!("peripheral", name, void[]);
	struct peripheral
	{
		enum _type = "peripheral";
		enum _name = name;
		alias _value = Value;
	}
}

unittest
{
	struct TestConfigT(C...)
	{
		mixin Config!C;
		alias _value = f_value;
		alias _periph = f_periph;

		TestConfigT!C withValue(uint value)
		{
			return set!"value"(value);
		}

		TestConfigT!(type!("periph", Periph)) withPeriph(Periph)(Periph periph)
		{
			return set!"periph"(periph);
		}
	}
	alias TestConfig = TestConfigT!(
		field!(uint, "value"),
		peripheral!("periph")
	);

	int test = 0;
	const config = TestConfig()
		.withValue(5)
		.withPeriph(test.init);
	
	import std.stdio;
	writeln(config);
	assert(config._value == 5, "Value is wrong");
	assert(is(config._periph == int), "Periph type is wrong");
}