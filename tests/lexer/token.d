module tests.lexer.token;

import fluent.asserts;

import jazz.lexer.token;

@("Token.Kind equality")
unittest
{
    static assert(tokenKind!"+" == tokenKind!"+");
}

@("Token.Kind inequality")
unittest
{
    static assert(tokenKind!"+" != tokenKind!"-");
}

@("Token.lexeme")
unittest
{
    Token token = {
        kind: tokenKind!"+",
        location: {
            start: 1,
            end: 2
        }
    };

    expect(token.lexeme("a+")).to.equal("+");
}
