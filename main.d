module main;

import mambo.core._;

import jazz.lexer.Lexer;

void main ()
{
	auto lexer = new Lexer;
	auto token = lexer.scan();
	println(token);
}