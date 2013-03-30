/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.Scanner;

import std.utf : codeLength;

import tango.text.Unicode;

import mambo.core._;

import jazz.lexer.Token;
import jazz.lexer.Entity;

/**
 * This struct contains functionality for advancing the buffer. It contains methods for
 * getting the next character, handling line and column count, handling newlines and similar
 * functions.
 */
struct Scanner
{
	immutable string buffer;
	dchar current = ' ';
	uint bufferPosition = uint.max;

	size_t column;
	size_t line;

	invariant ()
	{
		if (bufferPosition < bufferPosition.max)
			assert(bufferPosition < buffer.length, "Buffer position is out of bounds");
	}

	this (string code)
	{
		buffer = code;
		buffer ~= Entity.null_;
	}

	void skipWhitespace ()
	{
		while (true)
		{
			skipNewline();

			if (!isWhitespace(current))
				break;

			advance();
		}
	}

	void skipNewline ()
	{
		switch (current)
		{
			case Entity.lineFeed:
			case Entity.lineSeparator:
			case Entity.paragraphSeparator:
				newline();
			return;

			case Entity.carriageReturn:
				if (peekMatches(Entity.lineFeed))
					advance();

				newline();
			break;

			default:
				// do nothing
			break;
		}
	}

	void newline ()
	{
		line++;
		column = 1;
	}

	void advance (size_t positions = 1)
	{
		bufferPosition += positions;
		current = buffer[bufferPosition];
		column++;
	}

	dchar peek (size_t positions = 1)
	{
		return buffer[bufferPosition + positions];
	}

	bool peekMatches (dchar c, size_t positions = 1)
	{
		return peek(positions) == c;
	}

	bool peekMatches (string str, size_t positions = 1)
	in
	{
		assert(str.any, "String cannot be empty");
	}
	body
	{
		foreach (i, char c ; str)
			if (!peekMatches(c, i + positions))
				return false;

		return true;
	}

	string getLexeme (size_t start, size_t end = size_t.max)
	in
	{
		assert(start < buffer.length, "Buffer start position it out of bounds");
	}
	body
	{
		if (end == size_t.max)
			end = bufferPosition;

		assert(end < buffer.length, "Buffer end position it out of bounds");

		return buffer[start .. bufferPosition];
	}
}