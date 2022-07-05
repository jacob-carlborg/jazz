module jazz.lexer.lexer;

import std.stdio;

import jazz.lexer.location;
import jazz.lexer.token;

debug extern (C) private int printf(in char*, ...) nothrow @nogc;

pure nothrow @nogc:

struct Lexer
{
    private
    {
        // The source code to lex.
        ConstString sourceCode;

        // The current index into `sourceCode`.
        uint index;

        MutableToken token;
    }

pure nothrow @nogc @safe:

    this(ConstString sourceCode)
    in
    {
        const end = sourceCode.trusted[sourceCode.length -1];
        assert(end == Entity.null_ || end == Entity.substitute,
            `source code needs to end with \0`);
    }
    do
    {
        this.sourceCode = sourceCode;
        token.kind = tokenKind!"invalid";
    }

    void popFront()
    {
        token.location.start = index;

        if (lexShebangLine())
            return;

        mainLoop: while (true)
        {
            switch (current)
            {
                case '\0':
                case Entity.substitute:
                    recordToken(tokenKind!"endOfFile");
                    // Intentionally not advancing `index`, such that subsequent
                    // calls keep returning tokenKind!"endOfFile".
                    return;

                case ' ': return lexSpaces();

                static foreach (token; ['\t', '\v', '\f', '\n'])
                {
                    case token:
                        index++;
                        if (current != token)
                        {
                            recordToken(tokenKind!([token]));
                            return;
                        }
                        continue mainLoop;
                }

                case '\r':
                {
                    if (peek != '\r' && peek != '\n')
                    {
                        index++;
                        return recordToken(tokenKind!"\r");
                    }

                    while (true)
                    {
                        switch (current)
                        {
                            case '\r':
                            {
                                index++;

                                switch (current)
                                {
                                    case '\n': continue;
                                    case '\r':
                                        if (peek != '\r')
                                        {
                                            index++;
                                            return recordToken(tokenKind!"\r");
                                        }

                                        continue;

                                    default: return recordToken(tokenKind!"\r");
                                }
                            }

                            case '\n':
                                index++;
                                if (peek == '\n' || current == '\n')
                                    continue;

                                return recordToken(tokenKind!"\r\n");

                            default: assert(false);
                        }
                    }
                }

                default:
                    debug printf("Missing case for: %c\n", current);
                    assert(false);
            }
        }
    }

    Token front() const
    {
        Token result = {
            kind: token.kind,
            location: {
                start: token.location.start,
                end: token.location.end
            }
        };

        return result;
    }

    bool empty() const => token.kind == tokenKind!"endOfFile";

private:

    bool lexShebangLine()
    {
        if (peek(0, 2) != "#!")
            return false;

        index += 2;

        while (true)
        {
            switch (next)
            {
                case Entity.null_:
                case Entity.substitute:
                    index--;
                    goto case;
                case Entity.lineFeed:
                    index--;
                    break;
                default:
                    continue;
            }

            recordToken(tokenKind!"#!");
            return true;
        }

        assert(false);
    }

    void lexSpaces() @trusted
    in(current == ' ')
    {
        // Skip 4 spaces at a time after aligning 'p' to a 4-byte boundary.
        while ((cast(size_t) sourceCode.ptr + index) % uint.sizeof)
        {
            if (current != ' ')
                return recordToken(tokenKind!" ");

            index++;
        }

        while (*(cast(uint*) sourceCode.ptr + index) == 0x20202020) // ' ' == 0x20
            index += 4;

        // Skip over any remaining space on the line.
        while (current == ' ')
            index++;

        recordToken(tokenKind!" ");
    }

    void recordToken(Token.Kind kind)
    {
        token.location.end = index;
        token.kind = kind;
    }

    auto current() const => sourceCode.trusted[index];
    auto next() => sourceCode.trusted[index++];

    auto peek(size_t codeUnits = 1) const
    in(codeUnits <= 4)
    {
        return sourceCode.trusted[index + codeUnits];
    }

    auto peek(size_t start, size_t end) const
    in(end > start && end <= 4)
    {
        return sourceCode.trusted[start .. end];
    }
}

private:

alias ConstString = const(char)[];

enum Entity : dchar
{
    null_ = '\u0000',

    substitute = '\u001A',

    carriageReturn = '\u000D',
    lineFeed = '\u000A',
    lineSeparator = '\u2028',
    paragraphSeparator = '\u2029'
}

// Mutable version of jazz.lexer.location.Location
struct MutableLocation
{
    uint start;
    uint end;
}

static assert(MutableLocation.sizeof == Location.sizeof);

// Mutable version of jazz.lexer.token.Token
struct MutableToken
{
    Token.Kind kind;
    MutableLocation location;
}

static assert(MutableToken.sizeof == Token.sizeof);

struct TrustedString
{
    private const(char)* value;

pure nothrow @nogc:

    private this(const(char)* value)
    {
        this.value = value;
    }

const:

    ConstString opSlice(size_t start, size_t end) @trusted
    {
        return value[start .. end];
    }

    char opIndex(size_t index) @trusted
    {
        return value[index];
    }
}

TrustedString trusted(ConstString value) @trusted
{
    return TrustedString(value.ptr);
}
