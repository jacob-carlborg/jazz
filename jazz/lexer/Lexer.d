/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Lexer;

import tango.text.Unicode;

import mambo.core._;

import jazz.lexer._;
import jazz.lexer.scanners._;

class Lexer
{
	private Token currentToken;
	private Scanner scanner;

	this (string code)
	{
		scanner = Scanner(code);
	}

	Token scan ()
	{
		currentToken = nextToken();

		switch (currentToken.kind)
		{
			case TokenKind.identifier: return scanIdentifier();
			case TokenKind.stringLiteral: return scanStringLiteral();
			default: return currentToken;
		}

		return currentToken;
	}

	string code ()
	{
		return scanner.buffer;
	}

	/// Returns the current line of code being lexed.
	@property size_t line ()
	{
		return scanner.line;
	}

	/// Returns the current column of code being lexed.
	@property size_t column ()
	{
		return scanner.column;
	}

private:

	@property dchar current ()
	{
		return scanner.current;
	}

	Token nextToken ()
	{
		scanner.skipWhitespace();

		if (current.isLetter)
			return newToken(TokenKind.identifier);

		else
		{
			switch (current)
			{
				case '"':
					return newToken(TokenKind.stringLiteral);

				case Entity.null_, Entity.substitute:
					return newToken(TokenKind.eof);

				default: return Token.invalid;
			}
		}
	}

	Token newToken (TokenKind kind, string lexeme = null)
	{
		return Token(kind, lexeme, scanner.bufferPosition);
	}

	Token scanIdentifier ()
	{
		return IdentifierScanner(scanner).scan();
	}

	Token scanStringLiteral ()
	in
	{
		assert(currentToken.kind == TokenKind.stringLiteral);
	}
	body
	{
		return StringLiteralScanner(scanner).scan();
	}
}