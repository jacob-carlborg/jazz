/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Mar 19, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.scanners.ScannerTrait;

mixin template ScannerTrait ()
{
	import std.utf : codeLength;

	private Scanner* scanner;
	alias scanner this;

	this (/*const*/ ref Scanner scanner)
	{
		this.scanner = &scanner;
	}
}