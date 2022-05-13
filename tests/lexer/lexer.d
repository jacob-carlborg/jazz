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
