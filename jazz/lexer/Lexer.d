/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Lexer;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

class Lexer
{
	private
	{
		Token currentToken;
	}

	Token scan ()
	{
		return Token(TokenKind.invalid);
	}
}