module tests.lexer.lexer;

import std.conv : text;

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

    assert(token.kind == tokenKind!"#!", token.kind.text);
    assert(code[location.start .. location.end] == "#!foo", code[location.start .. location.end]);
}
