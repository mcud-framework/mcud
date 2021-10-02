// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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