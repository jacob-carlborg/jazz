module SyntaxHighlighter;

import mambo.core._;

import jazz.lexer._;

bool stop (TokenKind kind)
{
	return kind == TokenKind.invalid || kind == TokenKind.eof;
}

void main ()
{
	string code = "module foöbar;";
	code = import("main.d");

	auto lexer = new Lexer(code);
	Token token;

	auto temp = `<!DOCTYPE html>
<html>
	<head>
		<title>{{title}}</title>
		<link href="http://railscasts.com/assets/application-f33052609391fcb2333fb8c560544e00.css" media="screen" rel="stylesheet" type="text/css" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	</head>
	<body>
		<div class="code_block">
			<div class="code_header">
				{{code_header}}
			</div>
			<div class="CodeRay">
				<div class="code">
<pre>
foobar
</pre>
				</div>
			</div>
		</div>
	</body>
</html>`;

	code = "";
	enum defaultIndentation = 4;
	int indentation = 0;
	size_t prevLine = 1;
	Token prevToken;

	do {
		token = lexer.scan();

		if (lexer.line > prevLine)
		{
			code ~= "\n".repeat(lexer.line - prevLine);
			prevLine = lexer.line;

			if (token.kind == TokenKind.closeBrace)
				indentation -= defaultIndentation;

			code ~= " ".repeat(indentation);
		}

		with (TokenKind)
			switch (token.kind)
			{
				case openBrace:
					code ~= token.lexeme;
					indentation += defaultIndentation;
				break;

				case closeBrace:
					code ~= token.lexeme;
				break;

				case stringLiteral:
					code ~= `<span class="s"><span class="dl">"</span><span class="k">` ~ token.lexeme[1 .. $ - 1] ~ `</span><span class="dl">"</span></span>`;
				break;

				case identifier:
				case keyword:
					if (prevToken.kind == keyword || prevToken.kind == identifier)
						code ~= " ";

					code ~= token.kind == keyword ? highlighted(token.lexeme, "r") : token.lexeme;
				break;

				default:
					if (token.kind >= slash && token.kind <= tildeEqual && token.kind != dot)
						code ~= ' ' ~ token.lexeme ~ ' ';

					else
						code ~= token.lexeme;
			}

		prevToken = token;
	} while (!stop(token.kind));

	println(temp.replace("foobar", code));
}

string highlighted (string lexeme, string htmlClass)
{
	return `<span class="` ~ htmlClass ~ `">` ~ lexeme ~ `</span>`;
}