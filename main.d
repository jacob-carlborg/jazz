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


	auto lexer = new Lexer(code);
	Token token;

	do {
		token = lexer.scan();
		println(token);
	} while (!stop(token.kind));
}