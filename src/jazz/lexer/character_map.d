module jazz.lexer.character_map;

pure nothrow @nogc @safe:
package:

bool isOctal(char c) => (characterMap[c] & CharacterKind.octal) != 0;
bool isHex(char c) => (characterMap[c] & CharacterKind.hex) != 0;
bool isIdchar(char c) => (characterMap[c] & CharacterKind.idchar) != 0;
bool isZeroSecond(char c) => (characterMap[c] & CharacterKind.zeroSecond) != 0;
bool isDigitSecond(char c) => (characterMap[c] & CharacterKind.digitSecond) != 0;
bool isSingleChar(char c) => (characterMap[c] & CharacterKind.singleChar) != 0;

private:

enum CharacterKind
{
    octal = 0x1,
    hex = 0x2,
    idchar = 0x4,
    zeroSecond = 0x8,
    digitSecond = 0x10,
    singleChar = 0x20
}

static immutable characterMap = ()
{
    ubyte[256] table;

    foreach (const i, ref c; table)
    {
        if ('0' <= i && i <= '7')
            c |= CharacterKind.octal;

        if (i.isHexDigit)
            c |= CharacterKind.hex;

        if (i.isAlphaNumeric || i == '_')
            c |= CharacterKind.idchar;

        switch (i)
        {
            case 'x': case 'X':
            case 'b': case 'B':
                c |= CharacterKind.zeroSecond;
                break;

            case '0': .. case '9':
            case 'e': case 'E':
            case 'f': case 'F':
            case 'l': case 'L':
            case 'p': case 'P':
            case 'u': case 'U':
            case 'i':
            case '.':
            case '_':
                c |= CharacterKind.zeroSecond | CharacterKind.digitSecond;
                break;

            default:
                break;
        }

        switch (i)
        {
            case '\\':
            case '\n':
            case '\r':
            case 0:
            case 0x1A:
            case '\'':
                break;
            default:
                if (!(i & 0x80))
                    c |= CharacterKind.singleChar;
                break;
        }
    }

    return table;
}();

bool isHexDigit(int c) =>
    (c >= '0' && c <= '9') ||
    (c >= 'a' && c <= 'f') ||
    (c >= 'A' && c <= 'F');

bool isAlphaNumeric(int c) =>
    (c >= '0' && c <= '9') ||
    (c >= 'a' && c <= 'z') ||
    (c >= 'A' && c <= 'Z');
