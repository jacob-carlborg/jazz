module main;

import mambo.core._;

import jazz.lexer.Lexer;
import jazz.lexer.TokenKind;

void main ()
{
	string code = "module main;";

	auto lexer = new Lexer(code);
	auto token = lexer.scan();

	while (token.kind != TokenKind.invalid)
	{
		println(token);
		token = lexer.scan();
	}
}