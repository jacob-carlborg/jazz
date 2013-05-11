/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Apr 8, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.CommentScanner;

import mambo.core._;

import jazz.lexer.Entity;
import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning comments.
package struct CommentScanner
{
	///
	mixin ScannerTrait;

	bool isComment (dchar current)
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
		assert(isComment(current), "The current token is not the start of an identifier");
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

 		advance();

		return Token(kind, getLexeme(pos), pos);
	}

private:

	TokenKind scanSingleLine ()
	{
		while (!skipNewline() && !isEof(peek))
		    advance();

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

private @property isEof (dchar c)
{
    switch (c)
    {
        case Entity.null_, Entity.substitute:
            return true;

        default:
            return false;
    }
}