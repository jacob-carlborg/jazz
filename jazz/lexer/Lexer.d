/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Lexer;

import mambo.core._;

import jazz.lexer._;
import jazz.lexer.scanners._;

class Lexer
{
	private
	{
		Token currentToken;
		Scanner scanner;
		CommentScanner commentScanner;
		CharacterLiteralScanner characterLiteralScanner;
	}

	this (string code)
	{
		scanner = new Scanner(code);
		commentScanner = CommentScanner(scanner);
		characterLiteralScanner = CharacterLiteralScanner(scanner);
	}

	Token scan ()
	{
		currentToken = nextToken();

		switch (currentToken.kind)
		{
			case TokenKind.identifier: return scanIdentifier();
			case TokenKind.stringLiteral: return scanStringLiteral();

			default:
				if (commentScanner.isComment(current))
					return scanComment();

				if (characterLiteralScanner.isCharacterLiteral(current))
					return scanCharacterLiteral();

				if (OperatorScanner.isStartOfOperator(current))
					return scanOperator();

				if (currentToken.lexeme is null)
					currentToken.lexeme = getCurrentLexeme();

				return currentToken;
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

	@property dchar peek ()
	{
		return scanner.peek;
	}

	Token nextToken ()
	{
		scanner.skipWhitespace();

		if (current.isLetter)
			return newToken(TokenKind.identifier);

		else
		{
			with (TokenKind)
				switch (current)
				{
					case '"':
						return newToken(TokenKind.stringLiteral);

					case Entity.null_, Entity.substitute:
						return newToken(TokenKind.eof);

					// brackets
					case '(': return handleSingleToken(openParenthesis);
					case ')': return handleSingleToken(closeParenthesis);
					case '[': return handleSingleToken(openBracket);
					case ']': return handleSingleToken(closeBracket);
					case '{': return handleSingleToken(openBrace);
					case '}': return handleSingleToken(closeBrace);

					// miscellaneous
					case '?': return handleSingleToken(question);
					case ',': return handleSingleToken(comma);
					case ';': return handleSingleToken(semicolon);
					case ':': return handleSingleToken(colon);
					case '$': return handleSingleToken(dollar);
					case '@': return handleSingleToken(at);
					case '#': return handleSingleToken(hash);

					default: return Token.invalid;
				}
		}
	}

	Token newToken (TokenKind kind, string lexeme = null)
	{
		return Token(kind, lexeme, scanner.bufferPosition);
	}

	Token handleSingleToken (TokenKind kind)
	{
		auto token = newToken(kind, getCurrentLexeme);
		scanner.advance();

		return token;
	}

	string getCurrentLexeme ()
	{
		import std.utf;

		auto pos = scanner.bufferPosition;
		return scanner.buffer[pos .. pos + current.codeLength!(char)];
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

	Token scanOperator ()
	{
		return OperatorScanner(scanner).scan();
	}

	Token scanComment ()
	{
		return commentScanner.scan();
	}

	Token scanCharacterLiteral ()
	{
		return characterLiteralScanner.scan();
	}
}

private @property bool isLetter (dchar c)
{
	import tango.text.Unicode;
	return c == '_' || tango.text.Unicode.isLetter(c);
}