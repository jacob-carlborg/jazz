module tests.lexer.token;

import jazz.lexer.token;

@("Token.Kind equality")
unittest
{
    static assert(Token.kind!"+" == Token.kind!"+");
}

@("Token.Kind inequality")
unittest
{
    static assert(Token.kind!"+" != Token.kind!"-");
}
