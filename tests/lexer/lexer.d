module tests.lexer.lexer;

import fluent.asserts;

import jazz.lexer.lexer;
import jazz.lexer.token;

@("Lexer")
unittest
{
    enum code = "#!foo\nbar\0";
    auto lexer = Lexer(code);

    lexer.popFront();

    auto token = lexer.front;
    auto location = token.location;

    expect(token.kind).to.equal(tokenKind!"#!");
    expect(token.lexeme(code)).to.equal("#!foo");
}
