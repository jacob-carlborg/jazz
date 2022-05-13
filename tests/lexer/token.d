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

@("Token.Kind.toString")
unittest
{
    expect(tokenKind!"+".toString).to.equal("+");
}

@(`Token.Kind.toString \t`)
unittest
{
    expect(tokenKind!"\t".toString).to.equal(`\t`);
}

@(`Token.Kind.toString \n`)
unittest
{
    expect(tokenKind!"\n".toString).to.equal(`\n`);
}

@(`Token.Kind.toString \r`)
unittest
{
    expect(tokenKind!"\r".toString).to.equal(`\r`);
}

@(`Token.Kind.toString " "`)
unittest
{
    expect(tokenKind!" ".toString).to.equal(`" "`);
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
