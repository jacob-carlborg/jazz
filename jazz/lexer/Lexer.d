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

struct ByTokenRange
{
	private Lexer lexer;
	private Token token;

	Token front ()
	{
		return token;
	}

	void popFront ()
	{
		token = lexer.scan();
	}

	bool empty ()
	{
		return token.kind == TokenKind.eof;
	}
}

final class Lexer
{
	private
	{
		Token currentToken;
		Scanner scanner;
		CharacterLiteralScanner characterLiteralScanner;
		CommentScanner commentScanner;
		IdentifierScanner identifierScanner;
		OperatorScanner operatorScanner;
		StringLiteralScanner stringLiteralScanner;
	}

	this (string code)
	{
		scanner = new Scanner(code);
		characterLiteralScanner = CharacterLiteralScanner(scanner);
		commentScanner = CommentScanner(scanner);
		identifierScanner = IdentifierScanner(scanner);
		operatorScanner = OperatorScanner(scanner);
		stringLiteralScanner = StringLiteralScanner(scanner);
	}

	ByTokenRange scanByToken ()
	{
		auto range = ByTokenRange(this);
		range.popFront();

		return range;
	}

	Token scan ()
	{
		currentToken = nextToken();

		switch (currentToken.kind)
		{
			case TokenKind.characterLiteral: return scanCharacterLiteral();
			case TokenKind.identifier: return scanIdentifier();
			case TokenKind.stringLiteral: return scanStringLiteral();

			default:
				if (commentScanner.isComment(current))
					return scanComment();

				if (operatorScanner.isOperator(current))
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
				    case '`':
					case '"':
						return newToken(TokenKind.stringLiteral);

					case '\'':
						return newToken(TokenKind.characterLiteral);

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

	Token scanCharacterLiteral ()
	{
		return characterLiteralScanner.scan();
	}

	Token scanComment ()
	{
		return commentScanner.scan();
	}

	Token scanIdentifier ()
	{
		return identifierScanner.scan();
	}

	Token scanOperator ()
	{
		return operatorScanner.scan();
	}

	Token scanStringLiteral ()
	{
		return stringLiteralScanner.scan();
	}
}

private @property bool isLetter (dchar c)
{
	import tango.text.Unicode;
	return c == '_' || tango.text.Unicode.isLetter(c);
}