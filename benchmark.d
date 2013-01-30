/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 30, 2013
 * License: $(LINK2 http:///www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module benchmark;

import tango.io.device.File;
import tango.time.StopWatch;

import mambo.core._;

import jazz.lexer._;

void main ()
{
	string code = cast(string) File.get("/Users/doob/.dvm/compilers/dmd-2.061/src/phobos/std/datetime.d");
	auto lexer = new Lexer(code);

	Token token;
	size_t numberOfTokens;
	StopWatch timer;

	timer.start;

	do {
		token = lexer.scan();
		numberOfTokens++;
	} while (token.kind != TokenKind.eof);

	auto elapsed = timer.stop;

	println("elapsed: ", elapsed);
	println("number of tokens: ", numberOfTokens);
	println("tokens/sec: ", numberOfTokens * elapsed);
}