/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.commands.tests.command;import uim.commands;@safe:bool testCommand(ICommand commandToTest) {    assert(commandToTest !is null, "In testCommand: commandToTest is null");    return true;}