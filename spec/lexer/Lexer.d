/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 05, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 *
 */
module spec.lexer.Lexer;

import mambo.core._;

import dspec.Dsl;

import jazz.lexer._;

unittest
{

describe! "Lexer" in {
	describe! "scanIdentifier" in {
		describe! "valid string literal" in {
			it! "should return a token with the type TokenKind.stringLiteral" in {
				auto code = `"asd"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.kind == TokenKind.stringLiteral);
			};

			it! "should return a token with the correct lexeme" in {
				auto stringLiteral = "asd";
				auto code = `"` ~ stringLiteral ~ `"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == stringLiteral);
			};
		};
	};
};

}