/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.OperatorScanner;

import mambo.core._;

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
		auto pos = bufferPosition;
		TokenKind kind;

		with (TokenKind)
		{
			if (isNextOperator("/=")) kind = slashEqual;
			else if (isNextOperator("/")) kind = slash;
			else if (isNextOperator("...")) kind = tripleDot;
			else if (isNextOperator("..")) kind = doubleDot;
			else if (isNextOperator(".")) kind = dot;
			else if (isNextOperator("&&")) kind = doubleAmpersand;
			else if (isNextOperator("&=")) kind = ampersandEqual;
			else if (isNextOperator("&")) kind = ampersand;
			else if (isNextOperator("||")) kind = doublePipe;
			else if (isNextOperator("|=")) kind = pipeEqual;
			else if (isNextOperator("|")) kind = pipe;
			else if (isNextOperator("--")) kind = doubleMinus;
			else if (isNextOperator("-=")) kind = minusEqual;
			else if (isNextOperator("-")) kind = minus;
			else if (isNextOperator("++")) kind = doublePlus;
			else if (isNextOperator("+=")) kind = plusEqual;
			else if (isNextOperator("+")) kind = plus;
			else if (isNextOperator(">>>=")) kind = tripleGreaterEqual;
			else if (isNextOperator(">>>")) kind = tripleGreater;
			else if (isNextOperator(">>=")) kind = doubleGreaterEqual;
			else if (isNextOperator(">>")) kind = doubleGreater;
			else if (isNextOperator(">=")) kind = greaterEqual;
			else if (isNextOperator(">")) kind = greater;
			else if (isNextOperator("<<")) kind = doubleLess;
			else if (isNextOperator("<=")) kind = lessEqual;
			else if (isNextOperator("<")) kind = less;
			else if (isNextOperator("!=")) kind = bangEqual;
			else if (isNextOperator("!")) kind = bang;
			else if (isNextOperator("==")) kind = doubleEqual;
			else if (isNextOperator("=>")) kind = equalGreater;
			else if (isNextOperator("=")) kind = equal;
			else if (isNextOperator("%=")) kind = percentEuqal;
			else if (isNextOperator("%")) kind = percent;
			else if (isNextOperator("^^=")) kind = doubleCaretEqual;
			else if (isNextOperator("^^")) kind = doubleCaret;
			else if (isNextOperator("^=")) kind = caretEqual;
			else if (isNextOperator("^")) kind = caret;
			else if (isNextOperator("~=")) kind = tildeEqual;
			else if (isNextOperator("~")) kind = tilde;
		}

		return Token(kind, getLexeme(pos), pos);
	}

private:

	bool isNextOperator (string str)
	{
		auto match = peekMatches(str, 0);

		if (match)
			advance(str.length);

		return match;
	}
}