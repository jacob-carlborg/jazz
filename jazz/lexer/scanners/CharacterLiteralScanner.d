/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 20, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.CharacterLiteralScanner;

import mambo.core._;

import jazz.lexer.Entity;
import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning character literals.
package struct CharacterLiteralScanner
{
	///
	mixin ScannerTrait;

	bool isCharacterLiteral (dchar current)
	{
		return current == '\'';
	}

	Token scan ()
	in
	{
		assert(isCharacterLiteral(current), "The current token is not the start of a character literal");
	}
	body
	{
		bool escapedQute;
		auto pos = bufferPosition;

		while (true)
		{
			if (isEof(peek))
				return Token.invalid;

			escapedQute = false;
			advance();
			skipNewline();

			if (current == '\'' && !escapedQute)
				break;

			if (current == '\\' && peekMatches('\''))
			{
				advance();
				escapedQute = true;
			}
		}

		advance();

		return Token(TokenKind.characterLiteral, getLexeme(pos), pos);
	}
}