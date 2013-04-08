/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Apr 8, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.CommentScanner;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning comments.
package struct CommentScanner
{
	///
	mixin ScannerTrait;

	static bool isComment (dchar current, dchar peek)
	{
		if (current != '/')
			return false;

		switch (peek)
		{
			case '/':
			case '*':
			case '+':
				return true;

			default:
				return false;
		}
	}

	Token scan ()
	in
	{
		assert(CommentScanner.isComment(current, peek), "The current token is not the start of an identifier");
	}
	body
	{
		TokenKind kind;
		auto pos = bufferPosition;

		advance();

		switch (current)
		{
			case '/': kind = scanSingleLine(); break;
			case '*': kind = scanMultiLine(); break;
			case '+': kind = scanNested(); break;

			default: assert(0, "should never happen");
		}

		return Token(kind, getLexeme(pos), pos);
	}

private:

	TokenKind scanSingleLine ()
	{
		auto currenLine = line;

		do
		{
			advance();
		} while (currenLine == line);

		return TokenKind.singleLine;
	}

	TokenKind scanMultiLine ()
	{
		return TokenKind.multiLine;
	}

	TokenKind scanNested ()
	{
		return TokenKind.nested;
	}
}