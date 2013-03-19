/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Token;

import mambo.core._;

import jazz.lexer.TokenKind;

///
struct Token
{
	/// Returns an invalid token.
	enum Token invalid = Token(TokenKind.invalid);

	/// The kind of token.
	TokenKind kind;

	/// The textual representation of this token in the original source.
	string lexeme;

	/// The index of where this token begins in the original source.
	uint index;

	this (TokenKind kind, string lexeme = null, uint index = 0)
	{
		this.kind = kind;
		this.lexeme = lexeme;
		this.index = index;
	}

	bool isValid ()
	{
		return kind != TokenKind.invalid && lexeme !is null;
	}
}