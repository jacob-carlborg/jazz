module tests.lexer.lexer;

import fluent.asserts;

import jazz.lexer.lexer;
import jazz.lexer.token;

import tests.support;

@("Lexer")
unittest
{
    enum code = "#!foo\nbar".dcode;
    auto token = code.lexFirstToken;
    auto location = token.location;

    expect(token.kind).to.equal(tokenKind!"#!");
    expect(token.lexeme(code)).to.equal("#!foo");
}

@("range interface")
unittest
{
    enum code = "\t\0\0\0\0";
    auto lexer = Lexer(code);
    lexer.popFront;

    Token[] tokens;

    foreach (Token token; lexer)
        tokens ~= token;

    expect(tokens.length).to.equal(1);
    expect(tokens[0].kind).to.equal(tokenKind!"\t");
}

@(`lex \0`)
unittest
{
    enum code = "\0".dcode;
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@("subsequent calls to `popFront` results in end of file")
unittest
{
    enum code = "\0".dcode;
    auto lexer = Lexer(code);

    foreach (_; 0 .. 9)
        lexer.popFront;

    auto token = lexer.front;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@(`lex \u001A - substitute`)
unittest
{
    enum code = "\u001A".dcode;
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@(`lex \t`)
unittest
{
    enum code = "\t\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\t");
}

@(`lex multiple consecutive \t`)
unittest
{
    enum code = "\t\t\t\t\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\t");
    expect(token.lexeme(code)).to.equal("\t\t\t\t");
}

@(`lex " " - space`)
unittest
{
    enum code = " \0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!" ");
}

@(`lex multiple consecutive " "`)
unittest
{
    enum code = "         \0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!" ");
    expect(token.lexeme(code)).to.equal("         ");
}

@(`lex \v`)
unittest
{
    enum code = "\v\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\v");
}

@(`lex multiple consecutive \v`)
unittest
{
    enum code = "\v\v\v\v\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\v");
    expect(token.lexeme(code)).to.equal("\v\v\v\v");
}

@(`lex \f`)
unittest
{
    enum code = "\f\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\f");
}

@(`lex multiple consecutive \f`)
unittest
{
    enum code = "\f\f\f\f\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\f");
    expect(token.lexeme(code)).to.equal("\f\f\f\f");
}

@(`lex \r`)
unittest
{
    enum code = "\r\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\r");
}

@(`lex multiple consecutive \r`)
unittest
{
    enum code = "\r\r\r\r\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\r");
    expect(token.lexeme(code)).to.equal("\r\r\r\r");
}

@(`lex \r\n`)
unittest
{
    enum code = "\r\n\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\r\n");
    expect(token.lexeme(code)).to.equal("\r\n");
}

@(`lex multiple consecutive \r\n`)
unittest
{
    enum code = "\r\n\r\n\r\n\r\n\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\r\n");
    expect(token.lexeme(code)).to.equal("\r\n\r\n\r\n\r\n");
}

@(`lex \r\n followed by \r`)
unittest
{
    enum code = "\r\n\r\0\0\0\0";
    auto lexer = Lexer(code);
    lexer.popFront;

    Token.Kind[] result;

    import std.stdio;

    foreach (token; lexer)
        result ~= token.kind;

    expect(result).to.equal([tokenKind!"\r\n", tokenKind!"\r"]);
}

@(`lex \r\r followed by \n`)
unittest
{
    enum code = "\r\r\n\0\0\0\0";
    auto lexer = Lexer(code);
    lexer.popFront;

    Token.Kind[] result;

    foreach (token; lexer)
        result ~= token.kind;

    expect(result).to.equal([tokenKind!"\r", tokenKind!"\n"]);
}

@(`lex \n`)
unittest
{
    enum code = "\n\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\n");
}

@(`lex multiple consecutive \n`)
unittest
{
    enum code = "\n\n\n\n\0\0\0\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\n");
    expect(token.lexeme(code)).to.equal("\n\n\n\n");
}

private:

Token lexFirstToken(string sourceCode)
{
    auto lexer = Lexer(sourceCode);
    lexer.popFront();

    return lexer.front;
}
