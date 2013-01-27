/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Lexer;

import tango.text.Unicode;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

class Lexer
{
	private
	{
		immutable string buffer;
		dchar peek;

		size_t bufferPosition;
		size_t column;
		size_t line;
	}

	this (string code)
	{
		buffer = code;
	}

	Token scan ()
	{
		skipWhitespace();

		auto token = Token.invalid;

		return token;
	}

	string code ()
	{
		return buffer;
	}

private:

	void skipWhitespace ()
	{
		while (true)
		{
			readCharacter();

			if (isNewline(peek))
			{
				line++;
				column = 1;
			}

			else if (!isWhitespace(peek))
				break;
		}
	}

	bool isNewline (dchar c)
	{
		return c == '\n';
	}

	void readCharacter ()
	{
		peek = buffer[bufferPosition++];
		column++;
	}

	bool readCharacter (dchar c)
	{
		readCharacter();
		return peek == c;
	}
}