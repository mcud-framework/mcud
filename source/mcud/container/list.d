module mcud.container.list;

import mcud.core.result;

/**
Contains elements.
*/
struct List(T)
{
	private T* m_elements;
	private size_t m_size;

	this()
	{
		m_elements = null;
		m_size = 0;
	}

	this(ref List!T other)
	{
		m_elements = other.m_elements;
		m_size = other.m_size;
	}

	size_t size()
	{
		return m_size;
	}

	Result!T get(size_t index)
	{
		if (index < size)
			return ok(m_elements[index]);
		else
			return no!T;
	}

	Result!T opIndex(size_t index)
	{
		return get(index);
	}

	Result!void set(size_t index, T element)
	{
		if (index < size)
		{
			m_elements[index] = element;
			return ok();
		}
		else
		{
			return no!T();
		}
	}

	Result!void opIndexAssign(T value, size_t index)
	{
		return set(index, value);
	}

	int opApply(scope int delegate(ref T) dg)
	{
		int result = 0;
		foreach (ref item; array)
		{
			result = dg(item);
			if (result)
				break;
		}
		return result;
	}
}