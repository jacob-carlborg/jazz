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

		describe! "string containing escaped quotation mark" in {
			it! "should return a token with the type TokenKind.stringLiteral" in {
				auto code = `"foo\"bar"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.kind == TokenKind.stringLiteral);
			};

			it! "should return a token with the correct lexeme" in {
				auto stringLiteral = `foo\"bar`;
				auto code = `"` ~ stringLiteral ~ `"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == stringLiteral);
			};
		};

		describe! "string containing newline" in {
			it! "should return a token with the type TokenKind.stringLiteral" in {
				auto code = `"foo
				bar"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.kind == TokenKind.stringLiteral);
			};

			it! "should return a token with the correct lexeme" in {
				auto stringLiteral = "foo\nbar";
				auto code = `"` ~ stringLiteral ~ `"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == stringLiteral);
			};

			it! "should increment the line count" in {
				auto code = `"foo` ~ '\n' ~ `bar"`;
				auto lexer = new Lexer(code);

				auto currentLine = lexer.line;
				lexer.scan;
				assert(lexer.line == currentLine + 1);
			};
		};
	};

	describe! "valid identifier" in {
		it! "should return a token with the type TokenKind.identifier" in {
			auto code = `foo`;
			auto lexer = new Lexer(code);

			assert(lexer.scan.kind == TokenKind.identifier);
		};

		it! "should return a token with the correct lexeme" in {
			auto code = "foo";
			auto lexer = new Lexer(code);

			assert(lexer.scan.lexeme == code);
		};

		describe! "identifier stating with '_'" in {
			it! "should return a token with the type TokenKind.identifier" in {
				auto code = `_`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.kind == TokenKind.identifier);
			};

			it! "should return a token with '_' as the lexeme" in {
				auto code = "_";
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == code);
			};
		};
	};

	describe! "scan newline" in {
		it! "should increment the line count" in {
			auto code = "\n";
			auto lexer = new Lexer(code);
			auto currentLine = lexer.line;
			lexer.scan;

			assert(lexer.line == currentLine + 1);
		};

		it! "should increment the column count" in {
			auto code = "\n";
			auto lexer = new Lexer(code);
			auto currentColumn = lexer.column;
			lexer.scan;

			assert(lexer.line == currentColumn + 1);
		};
	};

	describe! "scan brackets" in {
		describe! "should have correct token kind" in {
			it! "(" in { assertTokenKind("(", TokenKind.openParenthesis); };
			it! ")" in { assertTokenKind(")", TokenKind.closeParenthesis); };
			it! "[" in { assertTokenKind("[", TokenKind.openBracket); };
			it! "]" in { assertTokenKind("]", TokenKind.closeBracket); };
			it! "{" in { assertTokenKind("{", TokenKind.openBrace); };
			it! "}" in { assertTokenKind("}", TokenKind.closeBrace); };
		};

		describe! "should have correct lexeme" in {
			it! "(" in { assertLexeme("(", "("); };
			it! ")" in { assertLexeme(")", ")"); };
			it! "[" in { assertLexeme("[", "["); };
			it! "]" in { assertLexeme("]", "]"); };
			it! "{" in { assertLexeme("{", "{"); };
			it! "}" in { assertLexeme("}", "}"); };
		};
	};
};

}

private:

void assertTokenKind (string code, TokenKind kind, string file = __FILE__, size_t line = __LINE__)
{
	customAssert(newLexer(code).scan.kind == kind, "", file, line);
}

void assertLexeme (string code, string lexeme, string file = __FILE__, size_t line = __LINE__)
{
	customAssert(newLexer(code).scan.lexeme == lexeme, "", file, line);
}

Lexer newLexer (string code)
{
	return new Lexer(code);
}

void customAssert (bool conditoin, string message = "", string file = __FILE__, size_t line = __LINE__)
{
	import core.exception;

	if (!conditoin)
		throw new AssertError(message, file, line);
}