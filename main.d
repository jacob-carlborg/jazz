module main;

import mambo.core._;

import jazz.lexer.Lexer;

void main ()
{
	string code = "module main;";

	auto lexer = new Lexer(code);
	auto token = lexer.scan();
	println(token);
}