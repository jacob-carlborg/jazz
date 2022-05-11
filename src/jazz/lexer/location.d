module jazz.lexer.location;

/// Represents a location in the source code.
immutable struct Location
{
    /**
     * Offset in bytes from the start of the source code to the start of the
     * location.
     */
    uint start;

    /**
     * Offset in bytes from the start of the source code to the end of the
     * location.
     */
    uint end;
}
