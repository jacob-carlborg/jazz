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
			auto code = `"asd"`;
			auto lexer = new Lexer(code);

			assert(lexer.scan.lexeme == code);
		};

		describe! "string containing escaped quotation mark" in {
			it! "should return a token with the type TokenKind.stringLiteral" in {
				auto code = `"foo\"bar"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.kind == TokenKind.stringLiteral);
			};

			it! "should return a token with the correct lexeme" in {
				auto code = `"foo\"bar"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == code);
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
				auto code = `"` ~ "foo\nbar" ~ `"`;
				auto lexer = new Lexer(code);

				assert(lexer.scan.lexeme == code);
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

	describe! "scan operators" in {
		describe! "should have correct token kind" in {
			it! "/" in { assertTokenKind("/", TokenKind.slash); };
			it! "/=" in { assertTokenKind("/=", TokenKind.slashEqual); };
			it! "." in { assertTokenKind(".", TokenKind.dot); };
			it! ".." in { assertTokenKind("..", TokenKind.doubleDot); };
			it! "..." in { assertTokenKind("...", TokenKind.tripleDot); };
			it! "&" in { assertTokenKind("&", TokenKind.ampersand); };
			it! "&=" in { assertTokenKind("&=", TokenKind.ampersandEqual); };
			it! "&&" in { assertTokenKind("&&", TokenKind.doubleAmpersand); };
			it! "|" in { assertTokenKind("|", TokenKind.pipe); };
			it! "|=" in { assertTokenKind("|=", TokenKind.pipeEqual); };
			it! "||" in { assertTokenKind("||", TokenKind.doublePipe); };
			it! "-" in { assertTokenKind("-", TokenKind.minus); };
			it! "-=" in { assertTokenKind("-=", TokenKind.minusEqual); };
			it! "+" in { assertTokenKind("+", TokenKind.plus); };
			it! "+=" in { assertTokenKind("+=", TokenKind.plusEqual); };
			it! "++" in { assertTokenKind("++", TokenKind.doublePlus); };
			it! "<" in { assertTokenKind("<", TokenKind.less); };
			it! "<=" in { assertTokenKind("<=", TokenKind.lessEqual); };
			it! "<<" in { assertTokenKind("<<", TokenKind.doubleLess); };
			it! ">" in { assertTokenKind(">", TokenKind.greater); };
			it! ">=" in { assertTokenKind(">=", TokenKind.greaterEqual); };
			it! ">>=" in { assertTokenKind(">>=", TokenKind.doubleGreaterEqual); };
			it! ">>>=" in { assertTokenKind(">>>=", TokenKind.tripleGreaterEqual); };
			it! ">>" in { assertTokenKind(">>", TokenKind.doubleGreater); };
			it! ">>>" in { assertTokenKind(">>>", TokenKind.tripleGreater); };
			it! "!" in { assertTokenKind("!", TokenKind.bang); };
			it! "!=" in { assertTokenKind("!=", TokenKind.bangEqual); };
			it! "=" in { assertTokenKind("=", TokenKind.equal); };
			it! "=>" in { assertTokenKind("=>", TokenKind.equalGreater); };
			it! "==" in { assertTokenKind("==", TokenKind.doubleEqual); };
			it! "%" in { assertTokenKind("%", TokenKind.percent); };
			it! "%=" in { assertTokenKind("%=", TokenKind.percentEuqal); };
			it! "^" in { assertTokenKind("^", TokenKind.caret); };
			it! "^=" in { assertTokenKind("^=", TokenKind.caretEqual); };
			it! "^^" in { assertTokenKind("^^", TokenKind.doubleCaret); };
			it! "^^=" in { assertTokenKind("^^=", TokenKind.doubleCaretEqual); };
			it! "~" in { assertTokenKind("~", TokenKind.tilde); };
			it! "~=" in { assertTokenKind("~=", TokenKind.tildeEqual); };
		};

		describe! "should have correct lexeme" in {
			it! "/" in { assertLexeme("/", "/"); };
			it! "/=" in { assertLexeme("/=", "/="); };
			it! "." in { assertLexeme(".", "."); };
			it! ".." in { assertLexeme("..", ".."); };
			it! "..." in { assertLexeme("...", "..."); };
			it! "&" in { assertLexeme("&", "&"); };
			it! "&=" in { assertLexeme("&=", "&="); };
			it! "&&" in { assertLexeme("&&", "&&"); };
			it! "|" in { assertLexeme("|", "|"); };
			it! "|=" in { assertLexeme("|=", "|="); };
			it! "||" in { assertLexeme("||", "||"); };
			it! "-" in { assertLexeme("-", "-"); };
			it! "-=" in { assertLexeme("-=", "-="); };
			it! "+" in { assertLexeme("+", "+"); };
			it! "+=" in { assertLexeme("+=", "+="); };
			it! "++" in { assertLexeme("++", "++"); };
			it! "<" in { assertLexeme("<", "<"); };
			it! "<=" in { assertLexeme("<=", "<="); };
			it! "<<" in { assertLexeme("<<", "<<"); };
			it! ">" in { assertLexeme(">", ">"); };
			it! ">=" in { assertLexeme(">=", ">="); };
			it! ">>=" in { assertLexeme(">>=", ">>="); };
			it! ">>>=" in { assertLexeme(">>>=", ">>>="); };
			it! ">>" in { assertLexeme(">>", ">>"); };
			it! ">>>" in { assertLexeme(">>>", ">>>"); };
			it! "!" in { assertLexeme("!", "!"); };
			it! "!=" in { assertLexeme("!=", "!="); };
			it! "=" in { assertLexeme("=", "="); };
			it! "=>" in { assertLexeme("=>", "=>"); };
			it! "==" in { assertLexeme("==", "=="); };
			it! "%" in { assertLexeme("%", "%"); };
			it! "%=" in { assertLexeme("%=", "%="); };
			it! "^" in { assertLexeme("^", "^"); };
			it! "^=" in { assertLexeme("^=", "^="); };
			it! "^^" in { assertLexeme("^^", "^^"); };
			it! "^^=" in { assertLexeme("^^=", "^^="); };
			it! "~" in { assertLexeme("~", "~"); };
			it! "~=" in { assertLexeme("~=", "~="); };
		};
	};

	describe! "scan miscellaneous" in {
		describe! "should have correct token kind" in {
			it! "?" in { assertTokenKind("?", TokenKind.question); };
			it! "," in { assertTokenKind(",", TokenKind.comma); };
			it! ";" in { assertTokenKind(";", TokenKind.semicolon); };
			it! ":" in { assertTokenKind(":", TokenKind.colon); };
			it! "$" in { assertTokenKind("$", TokenKind.dollar); };
			it! "@" in { assertTokenKind("@", TokenKind.at); };
			it! "#" in { assertTokenKind("#", TokenKind.hash); };
		};
	};

	describe! "scan comments" in {
		describe! "single line comment" in {
			it! "should return a token with the type TokenKind.singleLine" in {
				assertTokenKind("//foo", TokenKind.singleLine);
			};
	
			it! "should return a token with the '//foo' as the lexeme" in {
				assertLexeme("//foo", "//foo");
			};

			it! "should not span multiple lines" in {
				auto code = "//foo\nbar";
				auto lexer = new Lexer(code);
				lexer.scan();
				assert(lexer.scan.kind == TokenKind.identifier);
			};
		};

		describe! "multi line comment" in {
			it! "should return a token with the type TokenKind.multiLine" in {
				assertTokenKind("/*foo*/", TokenKind.multiLine);
			};

			it! "should return a token with the '/*foo*/' as the lexeme" in {
				assertLexeme("/*foo*/", "/*foo*/");
			};

			it! "should handle comments spanning multiple lines" in {
				assertLexeme("/*foo\n\nbar*/", "/*foo\n\nbar*/");
			};

			describe! "invalid comment" in {
				it! "should return an invalid token for unclosed comment" in {
					assertTokenKind("/*foo", TokenKind.invalid);
				};
			};
		};

		describe! "nested comment" in {
			it! "should return a token with the type TokenKind.nested" in {
				assertTokenKind("/+foo+/", TokenKind.nested);
			};

			it! "should return a token with the '/+foo+/' as the lexeme" in {
				assertLexeme("/+foo+/", "/+foo+/");
			};

			it! "should handle comments spanning multiple lines" in {
				assertLexeme("/+foo\n\nbar+/", "/+foo\n\nbar+/");
			};

			it! "should handle nested comments" in {
				assertLexeme("/+foo\n/+asd+/\nbar+/", "/+foo\n/+asd+/\nbar+/");
			};

			describe! "invalid comment" in {
				it! "should return an invalid token for unclosed comment" in {
					assertTokenKind("/+foo", TokenKind.invalid);
				};

				it! "should return an invalid token for unbalanced comment" in {
					assertTokenKind("/+foo/+bar+/", TokenKind.invalid);
				};
			};
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