/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.OperatorScanner;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning identifiers.
package struct OperatorScanner
{
	///
	mixin ScannerTrait;

	static bool isStartOfOperator (dchar c)
	{
		switch (c)
		{
			case '/': return true;
			case '.': return true;
			case '&': return true;
			case '|': return true;
			case '-': return true;
			case '+': return true;
			case '<': return true;
			case '>': return true;
			case '!': return true;
			case '=': return true;
			case '%': return true;
			case '^': return true;
			case '~': return true;
			default: return false;
		}
	}

	Token scan ()
	in
	{
		assert(OperatorScanner.isStartOfOperator(current), "Current position is not the start of an operator");
	}
	body
	{
		return Token.invalid;
	}
}