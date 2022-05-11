module jazz.lexer.token;

import std.algorithm;

struct Token
{
    template kind(string tokenSymbol)
    {
        enum value = Kind.tokens.countUntil(tokenSymbol) + 1;
        enum kind = Kind(value);
    }

    struct Kind
    {
        private ubyte value;

        private this(ubyte value)
        {
            this.value = value;
        }

        private static enum operators = [
            "+",
            "-"
        ];

        private static enum tokens = operators;

        static assert(operators.length < value.max);
    }
}
