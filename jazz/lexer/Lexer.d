/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Lexer;

import std.utf : codeLength;

import tango.text.Unicode;

import mambo.core._;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

class Lexer
{
	private
	{
		immutable string buffer;
		dchar peek;

		uint bufferPosition;
		uint peekPosition;

		size_t column;
		size_t line;
	}

	this (string code)
	{
		buffer = code;
		buffer ~= '\u0000';
	}

	Token scan ()
	{
		auto token = nextToken();

		switch (token.kind)
		{
			case TokenKind.identifier: return scanIdentifier();
			default: return Token.invalid;
		}
	}

	string code ()
	{
		return buffer;
	}

private:

	Token nextToken ()
	{
		skipWhitespace();

		if (peek.isLetter)
			return newToken(TokenKind.identifier);

		else
			return Token.invalid;
	}

	Token newToken (TokenKind kind, string lexeme = null)
	{
		return Token(kind, lexeme, bufferPosition);
	}

	Token scanIdentifier ()
	{
		auto pos = bufferPosition;

		do
		{
			readCharacter();
		} while (peek.isLetterOrDigit || peek == '_');


		auto lexeme = buffer[pos .. bufferPosition];
		auto kind = isKeyword(lexeme) ? TokenKind.keyword : TokenKind.identifier;

		return Token(kind, lexeme, pos);
	}

	void skipWhitespace ()
	{
		while (true)
		{
			readCharacter();
			skipNewline();

			if (!isWhitespace(peek))
				break;
		}
	}

	void skipNewline ()
	{
		switch (peek)
		{
			case '\u000A':
			case '\u2028':
			case '\u2029':
				line++;
				column = 1;
			return;

			case '\u000D':
				readCharacter();

				if (!readCharacter('\u000A'))
					bufferPosition--;

				line++;
				column = 1;
			break;

			default:
				// do nothing
			break;
		}
	}

	void readCharacter ()
	{
		bufferPosition = peekPosition;
		peek = buffer[peekPosition];
		peekPosition += peek.codeLength!(char);

		column++;
	}

	bool readCharacter (dchar c)
	{
		readCharacter();
		return peek == c;
	}

	bool isKeyword (string lexeme)
	{
		switch (lexeme)
		{
			case "abstract": return true;
			case "alias": return true;
			case "align": return true;
			case "asm": return true;
			case "assert": return true;
			case "auto": return true;

			case "body": return true;
			case "bool": return true;
			case "break": return true;
			case "byte": return true;

			case "case": return true;
			case "cast": return true;
			case "catch": return true;
			case "cdouble": return true;
			case "cent": return true;
			case "cfloat": return true;
			case "char": return true;
			case "class": return true;
			case "const": return true;
			case "continue": return true;
			case "creal": return true;

			case "dchar": return true;
			case "debug": return true;
			case "default": return true;
			case "delegate": return true;
			case "delete": return true;
			case "deprecated": return true;
			case "do": return true;
			case "double": return true;

			case "else": return true;
			case "enum": return true;
			case "export": return true;
			case "extern": return true;

			case "false": return true;
			case "final": return true;
			case "finally": return true;
			case "float": return true;
			case "for": return true;
			case "foreach": return true;
			case "foreach_reverse": return true;
			case "function": return true;

			case "goto": return true;

			case "idouble": return true;
			case "if": return true;
			case "ifloat": return true;
			case "immutable": return true;
			case "import": return true;
			case "in": return true;
			case "inout": return true;
			case "int": return true;
			case "interface": return true;
			case "invariant": return true;
			case "ireal": return true;
			case "is": return true;

			case "lazy": return true;
			case "long": return true;

			case "macro": return true;
			case "mixin": return true;
			case "module": return true;

			case "new": return true;
			case "nothrow": return true;
			case "null": return true;

			case "out": return true;
			case "override": return true;

			case "package": return true;
			case "pragma": return true;
			case "private": return true;
			case "protected": return true;
			case "public": return true;
			case "pure": return true;
			case "real": return true;
			case "ref": return true;
			case "return": return true;

			case "scope": return true;
			case "shared": return true;
			case "short": return true;
			case "static": return true;
			case "struct": return true;
			case "super": return true;
			case "switch": return true;
			case "synchronized": return true;

			case "template": return true;
			case "this": return true;
			case "throw": return true;
			case "true": return true;
			case "try": return true;
			case "typedef": return true;
			case "typeid": return true;
			case "typeof": return true;

			case "ubyte": return true;
			case "ucent": return true;
			case "uint": return true;
			case "ulong": return true;
			case "union": return true;
			case "unittest": return true;
			case "ushort": return true;

			case "version": return true;
			case "void": return true;
			case "volatile": return true;

			case "wchar": return true;
			case "while": return true;
			case "with": return true;

			case "__FILE__": return true;
			case "__LINE__": return true;
			case "__gshared": return true;
			case "__traits": return true;
			case "__vector": return true;
			case "__parameters": return true;

	 		default: return false;
		}
	}
}