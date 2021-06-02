module mcud.container.array;

struct Array(T, size_t size)
{
	T[size] m_elements;
	private List!T m_list;

	this()
	{
		m_list = List!T(m_elements.ptr, m_elements.length);
	}

	alias m_list this;
}