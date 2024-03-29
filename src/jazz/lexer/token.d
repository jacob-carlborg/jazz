module jazz.lexer.token;

import std.algorithm;

import jazz.lexer.location;

pure nothrow @nogc @safe:

/**
 * A token in the source code.
 *
 * This is produced by the lexer and it's the minimal unit the parser works with.
 */
immutable struct Token
{
    /// The kind of token.
    Kind kind;

    /// The location of the token in the source code.
    Location location;

    /// Represents the kind of token.
    struct Kind
    {

        private ubyte value;

    const pure nothrow @nogc @safe:

        this(ubyte value)
        {
            this.value = value;
        }

        string toString()
        {
            switch (value)
            {
                case tokenKind!"\t".value: return `\t`;
                case tokenKind!"\v".value: return `\v`;
                case tokenKind!"\f".value: return `\f`;
                case tokenKind!"\r".value: return `\r`;
                case tokenKind!"\r\n".value: return `\r\n`;
                case tokenKind!"\n".value: return `\n`;
                case tokenKind!" ".value: return `" "`;
                default: return tokens.all[value];
            }
        }

        private static struct tokens
        {
            enum basicTypes = [
                "void",
                "byte",
                "ubyte",
                "short",
                "ushort",
                "int",
                "uint",
                "long",
                "ulong",
                "cent",
                "ucent",
                "float",
                "double",
                "real",
                "ifloat",
                "idouble",
                "ireal",
                "cfloat",
                "cdouble",
                "creal",
                "char",
                "wchar",
                "dchar",
                "bool",
                "__vector",
            ];

            enum aggregates = [
                "struct",
                "class",
                "interface",
                "union",
                "enum",
                "import",
                "alias",
                "override",
                "delegate",
                "function",
                "mixin",
                "align",
                "extern",
                "private",
                "protected",
                "public",
                "export",
                "static",
                "final",
                "const",
                "abstract",
                "debug",
                "deprecated",
                "in",
                "out",
                "inout",
                "lazy",
                "auto",
                "package",
                "immutable",
            ];

            enum statements = [
                "if",
                "else",
                "while",
                "for",
                "do",
                "switch",
                "case",
                "default",
                "break",
                "continue",
                "with",
                "synchronized",
                "return",
                "goto",
                "try",
                "catch",
                "finally",
                "asm",
                "foreach",
                "foreach_reverse",
                "scope",
            ];

            enum cExtendedKeywords = [
                "__import",
                "__cdecl",
                "__declspec",
                "__stdcall",
                "__attribute__",
            ];

            enum cOtherKeywords = [
                "inline",
                "register",
                "restrict",
                "signed",
                "sizeof",
                "typedef",
                "unsigned",
                "volatile",
                "_Alignas",
                "_Alignof",
                "_Atomic",
                "_Bool",
                "_Complex",
                "_Generic",
                "_Imaginary",
                "_Noreturn",
                "_Static_assert",
                "_Thread_local",
            ];

            enum cKeywords = cExtendedKeywords ~ cOtherKeywords;

            enum otherKeywords = [
                "cast",
                "null",
                "assert",
                "true",
                "false",
                "throw",
                "new",
                "delete",
                "version",
                "module",
                "template",
                "typeof",
                "pragma",
                "typeid",
                "this",
                "super",
                "invariant",
                "unittest",
                "ref",
                "macro",
                "__parameters",
                "__traits",
                "nothrow",
                "__gshared",
                "__LINE__",
                "__FILE__",
                "__FILE_FULL_PATH__",
                "__MODULE__",
                "__FUNCTION__",
                "__PRETTY_FUNCTION__",
                "shared",
            ];

            enum keywords =
                basicTypes ~
                aggregates ~
                statements ~
                cKeywords ~
                otherKeywords;

            enum operators = [
                "<",
                ">",
                "<=",
                ">=",
                "==",
                "!=",
                "is",
                "!is",
                "<<",
                ">>",
                "<<=",
                ">>=",
                ">>>",
                ">>>=",
                "~=",
                "+",
                "-",
                "+=",
                "-=",
                "*",
                "/",
                "%",
                "*=",
                "/=",
                "%=",
                "&",
                "|",
                "^",
                "&=",
                "|=",
                "^=",
                "=",
                "!",
                "~",
                "++",
                "--",
                ".",
                ",",
                "?",
                "&&",
                "||",
                "^^",
                "^^=",
            ];

            enum cFixed = [
                "=>",
                "#",
                "->",
                "::",
            ];

            enum otherFixed = [
                "(",
                ")",
                "[",
                "]",
                "{",
                "}",
                ":",
                ";",
                "...",
                "$",
                "@",
                "#!",
                "string",
                "onScopeExit",
                "onScopeFailure",
                "onScopeSuccess",

                " ",
                "\t",
                "\v",
                "\f",
                "\r",
                "\r\n",
                "\n",
                "lineSeparator", // \u2028,
                "paragraphSeparator", // \u2029
                "endOfFile",
            ];

            enum fixed = keywords ~ operators ~ cFixed ~ otherFixed;

            enum comments = [
                "//",
                "///",
                "/*",
                "/**",
                "/+",
                "/++"
            ];

            enum numericLiterals = [
                "intLiteral",
                "uintLiteral",
                "longLiteral",
                "ulongLiteral",
                "centLiteral",
                "ucentLiteral",
                "floatLiteral",
                "doubleLiteral",
                "realLiteral",
                "ifloatLiteral",
                "idoubleLiteral",
                "irealLiteral",
            ];

            enum characterLiterals = [
                "charLiteral",
                "wcharLiteral",
                "dcharLiteral",
            ];


            enum cCharacterLiterals = [
                "wchar_tLiteral"
            ];

            enum otherVariable = [
                "variable",
                "slice",
                "identifier",
                "error",
                "argumentTypes",
            ];

            enum variable =
                comments ~
                numericLiterals ~
                characterLiterals ~
                cCharacterLiterals ~
                otherVariable;

            static immutable all = "invalid" ~ fixed ~ variable;
        }

        static assert(tokens.all.length < value.max);
    }
}

/**
 * Creates a Token.Kind based on the given token symbol.
 *
 * Params:
 *  tokenText = the textual representation of the token
 */
template tokenKind(string tokenText)
{
    enum value = Token.Kind.tokens.all.countUntil(tokenText);
    static assert(value >= 0, "Invalid token: " ~ tokenText);
    enum tokenKind = Token.Kind(cast(ubyte) value);
}

///
unittest
{
    auto kind = tokenKind!"+";
}

/**
 * Returns the lexeme of the given token.
 *
 * The lexeme is actual text in the source code that makes up the token.
 *
 * Params:
 *  self = the token to get the lexeme of
 *  sourceCode = the source code the token originates from
 */
string lexeme(Token self, string sourceCode)
{
    return sourceCode[self.location.start .. self.location.end];
}

///
unittest
{
    Token token = {
        kind: tokenKind!"+",
        location: {
            start: 1,
            end: 2
        }
    };

    assert(token.lexeme("a+") == "+");
}
