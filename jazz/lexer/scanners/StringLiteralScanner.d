/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.StringLiteralScanner;

import std.utf : codeLength;

static import tango.text.Unicode;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning identifiers.
package struct StringLiteralScanner
{
	///
	mixin ScannerTrait;

	Token scan ()
	{
		bool escapedQute;
		auto pos = bufferPosition;

		while (true)
		{
			if (isEof(peek))
				return Token(TokenKind.invalid, getLexeme(pos), pos);

			escapedQute = false;
			advance();
			skipNewline();

			if (current == '\"' && !escapedQute)
				break;

			if (current == '\\' && peekMatches('\"'))
			{
				advance();
				escapedQute = true;
			}
		}

		advance();

		return Token(TokenKind.stringLiteral, getLexeme(pos), pos);
	}
}