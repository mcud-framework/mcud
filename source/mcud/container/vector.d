module mcud.container.vector;

import mcud.core.result;

struct Vector(T)
{
	private T* m_contents;
	private size_t m_length;
	private size_t m_capacity;

	this(T* ptr, size_t capacity)
	{
		m_ptr = ptr;
		m_length = 0;
		m_capacity = capacity;
	}

	Result!void pushBack(ref T t)
	{
		if (m_length < m_capacity)
		{
			m_ptr[m_length] = t;
			m_length++;
			return ok();
		}
		else
		{
			return fail(Errors.full);
		}
	}
}