// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.container.queue;

import mcud.test;
import mcud.core.result;

/**
A queue can store a predefined items, and allows one to prepend or append data,
and to take data from either the head or tail.
*/
struct Queue(T, size_t capacity)
{
	private T[capacity + 1] m_contents;
	private size_t m_read = 0;
	private size_t m_write = 0;

	/**
	Gets whether the queue is empty or not.
	Returns: `true` if the queue is empty, `false` if it is contains at least
	one element.
	*/
	bool isEmpty()
	{
		return m_read == m_write;
	}

	/**
	Gets whether the queue is full or not.
	Returns: `true` if the queue is full, `false` if it still has space
	available.
	*/
	bool isFull()
	{
		if (m_write == capacity && m_read == 0)
			return true;
		if (m_write + 1 == m_read)
			return true;
		return false;
	}

	/**
	Gets the number of available entries.
	Returns: The number of available entries.
	*/
	size_t available()
	{
		if (m_write < m_read)
			return m_read - m_write - 1;
		else
			return (capacity - m_write) + (m_read);
	}

	/**
	Gets the number of used entries.
	Returns: The number of used entries.
	*/
	size_t used()
	{
		if (m_write >= m_read)
			return m_write - m_read;
		else
			return (capacity - m_read) + (m_write) + 1;
	}

	/**
	Pushes a value into the queue.
	Params:
		value = The value to push.
	Returns: An error if the queue is full.
	*/
	Result!void push(T value)
	{
		if (isFull())
			return fail!void(Err.full);
		m_contents[m_write] = value;
		if (m_write == capacity)
			m_write = 0;
		else
			m_write++;
		return ok!void();
	}

	/**
	Gets a value from the queue.
	Returns: The value, or an error if the queue is empty.
	*/
	Result!T pop()
	{
		if (isEmpty)
			return fail!T(Err.empty);
		T value = m_contents[m_read];
		if (m_read == capacity)
			m_read = 0;
		else
			m_read++;
		return ok(value);
	}
}

@("Queue.isEmpty returns true for an empty queue")
unittest
{
	Queue!(int, 16) queue;
	expect(queue.isEmpty()).toEqual(true);
}

@("Queue.isEmpty returns false for a non-empty queue")
unittest
{
	Queue!(int, 16) queue;
	queue.push(4);
	expect(queue.isEmpty()).toEqual(false);
}

@("Queue.available returns available entries")
unittest
{
	Queue!(int, 16) queue;
	expect(queue.available()).toEqual(16);
	foreach (i; 0 .. 4)
		queue.push(i);
	expect(queue.available()).toEqual(12);
	queue.pop();
	queue.pop();
	expect(queue.available()).toEqual(14);
	foreach (i; 0 .. 14)
		queue.push(i);
	expect(queue.available()).toEqual(0);
}

@("Queue.used returns used entries")
unittest
{
	Queue!(int, 16) queue;
	expect(queue.used()).toEqual(0);
	foreach (i; 0 .. 4)
		queue.push(i);
	expect(queue.used()).toEqual(4);
	queue.pop();
	queue.pop();
	expect(queue.used()).toEqual(2);
	foreach (i; 0 .. 14)
		queue.push(i);
	expect(queue.used()).toEqual(16);
}

@("Queue.isFull returns false for an empty queue")
unittest
{
	Queue!(int, 16) queue;
	expect(queue.isFull()).toEqual(false);
}

@("Queue.isFull returns false for a non-empty queue")
unittest
{
	Queue!(int, 16) queue;
	queue.push(4);
	expect(queue.isFull()).toEqual(false);
}

@("Queue.isFull returns true for a full queue")
unittest
{
	Queue!(int, 16) queue;
	foreach (i; 0 .. 16)
		queue.push(i);
	expect(queue.isFull()).toEqual(true);
}

@("Queue.push succeeds for non-full queue")
unittest
{
	Queue!(int, 16) queue;
	foreach (i; 0 .. 16)
	{
		expect(queue.push(i)).toEqual(ok!void());
	}
}

@("Queue.push fails for full queue")
unittest
{
	Queue!(int, 16) queue;
	foreach (i; 0 .. 16)
		expect(queue.push(i)).toEqual(ok!void());
	expect(queue.push(16)).toEqual(fail!void(Err.full));
}

@("Queue.pop returns error on empty queue")
unittest
{
	Queue!(int, 16) queue;
	expect(queue.pop()).toEqual(fail!int(Err.empty));
}

@("Queue.pop returns value when queue is not empty")
unittest
{
	Queue!(int, 16) queue;
	queue.push(4);
	expect(queue.pop()).toEqual(ok(4));
}