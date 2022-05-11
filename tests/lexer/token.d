module tests.lexer.token;

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
