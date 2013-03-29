/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.IdentifierScanner;

import std.utf : codeLength;

static import tango.text.Unicode;

import jazz.lexer.Token;
import jazz.lexer.TokenKind;

import jazz.lexer.scanners.Scanner;
import jazz.lexer.scanners.ScannerTrait;

/// This struct contains functionality for scanning identifiers.
package struct IdentifierScanner
{
	///
	mixin ScannerTrait;

	Token scan ()
	in
	{
		assert(current.isLetterOrDigit, "The current token is not the start of an identifier");
	}
	body
	{
		auto pos = bufferPosition;

		while (current.isLetterOrDigit)
			advance(current.codeLength!(char));

		auto lexeme = getLexeme(pos);
		auto kind = isKeyword(lexeme) ? TokenKind.keyword : TokenKind.identifier;

		return Token(kind, lexeme, pos);
	}
}

private:

@property bool isLetterOrDigit (dchar c)
{
	return tango.text.Unicode.isLetterOrDigit(c) || c == '_';
}

bool isKeyword (string lexeme)
{
	switch (lexeme)
	{
		case "abstract": return true;
		case "alias": return true;
		case "align": return true;
		case "asm": return true;
		case "assert": return true;
		case "auto": return true;

		case "body": return true;
		case "bool": return true;
		case "break": return true;
		case "byte": return true;

		case "case": return true;
		case "cast": return true;
		case "catch": return true;
		case "cdouble": return true;
		case "cent": return true;
		case "cfloat": return true;
		case "char": return true;
		case "class": return true;
		case "const": return true;
		case "continue": return true;
		case "creal": return true;

		case "dchar": return true;
		case "debug": return true;
		case "default": return true;
		case "delegate": return true;
		case "delete": return true;
		case "deprecated": return true;
		case "do": return true;
		case "double": return true;

		case "else": return true;
		case "enum": return true;
		case "export": return true;
		case "extern": return true;

		case "false": return true;
		case "final": return true;
		case "finally": return true;
		case "float": return true;
		case "for": return true;
		case "foreach": return true;
		case "foreach_reverse": return true;
		case "function": return true;

		case "goto": return true;

		case "idouble": return true;
		case "if": return true;
		case "ifloat": return true;
		case "immutable": return true;
		case "import": return true;
		case "in": return true;
		case "inout": return true;
		case "int": return true;
		case "interface": return true;
		case "invariant": return true;
		case "ireal": return true;
		case "is": return true;

		case "lazy": return true;
		case "long": return true;

		case "macro": return true;
		case "mixin": return true;
		case "module": return true;

		case "new": return true;
		case "nothrow": return true;
		case "null": return true;

		case "out": return true;
		case "override": return true;

		case "package": return true;
		case "pragma": return true;
		case "private": return true;
		case "protected": return true;
		case "public": return true;
		case "pure": return true;
		case "real": return true;
		case "ref": return true;
		case "return": return true;

		case "scope": return true;
		case "shared": return true;
		case "short": return true;
		case "static": return true;
		case "struct": return true;
		case "super": return true;
		case "switch": return true;
		case "synchronized": return true;

		case "template": return true;
		case "this": return true;
		case "throw": return true;
		case "true": return true;
		case "try": return true;
		case "typedef": return true;
		case "typeid": return true;
		case "typeof": return true;

		case "ubyte": return true;
		case "ucent": return true;
		case "uint": return true;
		case "ulong": return true;
		case "union": return true;
		case "unittest": return true;
		case "ushort": return true;

		case "version": return true;
		case "void": return true;
		case "volatile": return true;

		case "wchar": return true;
		case "while": return true;
		case "with": return true;

		case "__FILE__": return true;
		case "__LINE__": return true;
		case "__gshared": return true;
		case "__traits": return true;
		case "__vector": return true;
		case "__parameters": return true;

 		default: return false;
	}
}