/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.helpers.command;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

class CommandHelper {
    private string _command;
    private string _description;
    private string _help;
    private string _syntax;
    private string _example;
    private string _output;
    private string _outputType;

    this(string command, string description, string help, string syntax, string example, string output, string outputType) {
        _command = command;
        _description = description;
        _help = help;
        _syntax = syntax;
        _example = example;
        _output = output;
        _outputType = outputType;
    }

    string command() {
        return _command;
    }

    string description() {
        return _description;
    }

    string help() {
        return _help;
    }

    string syntax() {
        return _syntax;
    }

    string example() {
        return _example;
    }

    string output() {
        return _output;
    }

    string outputType() {
        return _outputType;
    }
}