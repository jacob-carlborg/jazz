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
			switch (current)
			{
				case '/':
					kind = isNextOperator('=') ? slashEqual : slash;
				break;

				case '.':
					if (isNextOperator('.'))
					{
						kind = doubleDot;

						if (isNextOperator('.'))
							kind = tripleDot;
					}

					else
						kind = dot;
				break;

				case '&':
					if (isNextOperator('&')) kind = doubleAmpersand;
					else if (isNextOperator('=')) kind = ampersandEqual;
					else kind = ampersand;
				break;

				case '|':
					if (isNextOperator('|')) kind = doublePipe;
					else if (isNextOperator('=')) kind = pipeEqual;
					else kind = pipe;
				break;

				case '-':
					if (isNextOperator('-')) kind = doubleMinus;
					else if (isNextOperator('=')) kind = minusEqual;
					else kind = minus;
				break;

				case '+':
					if (isNextOperator('+')) kind = doublePlus;
					else if (isNextOperator('=')) kind = plusEqual;
					else kind = plus;
				break;

				case '<':
					if (isNextOperator('<')) kind = doubleLess;
					else if (isNextOperator('=')) kind = lessEqual;
					else kind = less;
				break;

				case '>':
					if (isNextOperator('>'))
					{
						if (isNextOperator('>'))
						{
							if (isNextOperator('=')) kind = tripleGreaterEqual;
							else kind = tripleGreater;
						}

						else
						{
							if (isNextOperator('=')) kind = doubleGreaterEqual;
							else kind = doubleGreater;
						}
					}

					else if (isNextOperator('=')) kind = greaterEqual;
					else kind = greater;
				break;

				case '!':
					kind = isNextOperator('=') ? bangEqual : bang;
				break;

				case '=':
					kind = isNextOperator('=') ? doubleEqual : equal;
				break;

				case '%':
					kind = isNextOperator('=') ? percentEuqal : percent;
				break;

				case '^':
					if (isNextOperator('^'))
						kind = isNextOperator('=') ? doubleCaretEqual : doubleCaret;

					else if (isNextOperator('=')) kind = caretEqual;
					else kind = caret;
				break;

				case '~':
					kind = isNextOperator('=') ? tildeEqual : tilde;
				break;

				default:
					kind = invalid;
			}

		advance();

		return Token(kind, getLexeme(pos),pos);
	}

private:

	bool isNextOperator (dchar c)
	{
		auto match = peekMatches(c);

		if (match)
			advance();

		return match;
	}
}