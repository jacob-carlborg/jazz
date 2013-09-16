module main;

import mambo.core._;

import jazz.lexer._;

bool stop (TokenKind kind)
{
	return kind == TokenKind.invalid || kind == TokenKind.eof;
}

void main ()
{
	string code = "module foöbar;";
	code = import(__FILE__);
	//code = "`asd`";

	auto lexer = new Lexer(code);
	auto range = lexer.scanByToken();
	range.map!(e => e.kind).println;

	// foreach (token ; range)
	// 	println(token);

	// do {
	// 	token = lexer.scan();
	// 	println(token);
	// } while (!stop(token.kind));
}