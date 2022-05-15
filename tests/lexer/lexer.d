module tests.lexer.lexer;

import fluent.asserts;

import jazz.lexer.lexer;
import jazz.lexer.token;

@("Lexer")
unittest
{
    enum code = "#!foo\nbar\0";
    auto token = code.lexFirstToken;
    auto location = token.location;

    expect(token.kind).to.equal(tokenKind!"#!");
    expect(token.lexeme(code)).to.equal("#!foo");
}

@(`lex \0`)
unittest
{
    enum code = "\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@("subsequent calls to `popFront` results in end of file")
unittest
{
    enum code = "\0";
    auto lexer = Lexer(code);

    foreach (_; 0 .. 9)
        lexer.popFront;

    auto token = lexer.front;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@(`lex \u001A - substitute`)
unittest
{
    enum code = "\u001A\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"endOfFile");
}

@(`lex \t`)
unittest
{
    enum code = "\t\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\t");
}

@(`lex multiple consecutive \t`)
unittest
{
    enum code = "\t\t\t\t\0";
    auto token = code.lexFirstToken;

    expect(token.kind).to.equal(tokenKind!"\t");
    expect(token.lexeme(code)).to.equal("\t\t\t\t");
}

private:

Token lexFirstToken(string sourceCode)
{
    auto lexer = Lexer(sourceCode);
    lexer.popFront();

    return lexer.front;
}
