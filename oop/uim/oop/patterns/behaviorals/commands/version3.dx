/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.commands.version3;

import uim.oop;
@safe:
 /* 
public interface IXCommand {
	public void execute();
	public void undo();
}


public class DNoXCommand : IXCommand {
	void execute() {
	}

	void undo() {
	}
}


public class DLightOnXCommand : IXCommand {
private:
	Light light;

public:
	this(Light light) {
		this.light = light; }

	void execute() {
		light.on(); }

	void undo() {
		light.off(); }
}

public class DLightOffCommand : IXCommand {
private:
	Light light;
	
public:
	this(Light light) {
		this.light = light; }
	
	void execute() {
		light.off(); }

	void undo() {
		light.on(); }
}

class DLight {
	private string location;

	this(string location) {
		this.location = location; }

	
	void on() {
		writefln("Light in %s is on", location); }

	void off() {
		writefln("Light in %s is off", location); }
}

public class DTVOnCommand : IXCommand {
private:
	TV tv;
	
public:
	this(TV tv) {
		this.tv = tv; }
	
	void execute() {
		tv.on(); }
	
	void undo() {
		tv.off(); }
}


public class DTVOffCommand : IXCommand {
private:
	TV tv;
	
public:
	this(TV tv) {
		this.tv = tv; }

	void execute() {
		tv.off(); }
	
	void undo() {
		tv.on(); }
}


class DTV {
	private string location;
	
	this(string location) {
		this.location = location; }
	
	
	void on() {
		writefln("TV in %s is on", location); }
	
	void off() {
		writefln("TV in %s is off", location); }
}


enum FanSpeed : int { OFF, LOW, MEDIUM, HIGH, ULTRAHIGH };

public class DCeilingFan {
private:
	string location;
	int speed;

public:
	this(string location) {
		this.location = location;
		speed = FanSpeed.OFF; }

	void off() {
		speed = FanSpeed.OFF; }

	void low() {
		speed = FanSpeed.LOW; }

	
	void medium() {
		speed = FanSpeed.MEDIUM; }

	void high() {
		speed = FanSpeed.HIGH; }
	
	void ultra() {
		speed = FanSpeed.ULTRAHIGH; }
	
	int getSpeed() {
		return speed; }

	string getLocation() {
		return location; }
}

class DCeilingFanHighCommand : DXCommand {
private:
	CeilingFan ceilingFan;
	int previousSpeed;

public:
	this(ICeilingFan ceilingFan) {
		this.ceilingFan = ceilingFan; }

	void execute() {
		previousSpeed = ceilingFan.getSpeed();
		ceilingFan.high();
		writefln("Ceiling fan in %s is high", ceilingFan.getLocation()); }

	void undo() {
		switch(previousSpeed) {
			case FanSpeed.OFF:
				ceilingFan.off();
				writefln("Ceiling fan in %s is off", ceilingFan.getLocation());
				break;
			case FanSpeed.LOW:
				ceilingFan.low();
				writefln("Ceiling fan in %s is low", ceilingFan.getLocation());
				break;
			case FanSpeed.MEDIUM:
				ceilingFan.medium();
				writefln("Ceiling fan in %s is medium", ceilingFan.getLocation());
				break;
			case FanSpeed.HIGH:
				ceilingFan.high();
				writefln("Ceiling fan in %s is high", ceilingFan.getLocation());
				break;
			case FanSpeed.ULTRAHIGH:
				ceilingFan.ultra();
				writefln("Ceiling fan in %s is danger for you", ceilingFan.getLocation());
				break;
          default:
            break;
		}
	}
}

class DCeilingFanLowCommand : IXCommand {
private:
	CeilingFan ceilingFan;
	int previousSpeed;
	
public:
	this(ICeilingFan ceilingFan) {
		this.ceilingFan = ceilingFan; }
	
	void execute() {
		previousSpeed = ceilingFan.getSpeed();
		ceilingFan.low();
		writefln("Ceiling fan in %s is low", ceilingFan.getLocation()); }

	void undo()	{
		switch(previousSpeed) {
			case FanSpeed.OFF:
				ceilingFan.off();
				writefln("Ceiling fan in %s is off", ceilingFan.getLocation());
				break;
			case FanSpeed.LOW:
				ceilingFan.low();
				writefln("Ceiling fan in %s is low", ceilingFan.getLocation());
				break;
			case FanSpeed.MEDIUM:
				ceilingFan.medium();
				writefln("Ceiling fan in %s is medium", ceilingFan.getLocation());
				break;
			case FanSpeed.HIGH:
				ceilingFan.high();
				writefln("Ceiling fan in %s is high", ceilingFan.getLocation());
				break;
			case FanSpeed.ULTRAHIGH:
				ceilingFan.ultra();
				writefln("Ceiling fan in %s is danger for you", ceilingFan.getLocation());
				break;
            default:
                break;
		}
	}
}


public class MacroCommand : IXCommand {
	private Command[] commands;

public:
	this(ICommand[] commands) {
		_commands = commands; }

	void execute() {
		for (size_t i = 0; i < commands.length; i++) {
			commands[i].execute(); }}

	void undo() {
		for (size_t i = 0; i < commands.length; i++) {
			commands[i].undo(); }}
}

public class DRemoteControlWithUndo {
private:
	IXCommand[] onCommands, offCommands;
	IXCommand undoCommand;

public:
	this() {
		onCommands = new DCommand[7];
		offCommands = new DCommand[7];

		Command noCommand = new DNoCommand();

		for (size_t i = 0; i < 7; i++) {
			onCommands[i] = noCommand;
			offCommands[i] = noCommand; }
		undoCommand = noCommand; }

	void setCommand(int slot, Command onCommand, Command offCommand) {
		onCommands[slot] = onCommand;
		offCommands[slot] = offCommand; }

	void onButtonPressed(int slot) {
		onCommands[slot].execute();
		undoCommand = onCommands[slot]; }
	
	void offButtonPressed(int slot) {
		offCommands[slot].execute();
		undoCommand = offCommands[slot]; }

	void undoButtonPressed() {
		undoCommand.undo(); }
}

Command[] toCommand(T:Command)(T[] commands) {
	return commands.dup;
}
   version(test_uim_oop) { unittest {
    writeln("--- Command test ---");
    RemoteControlWithUndo remoteControl = new DRemoteControlWithUndo();

    Light light1 = new DLight("Living Room");
    Light light2 = new DLight("Bath Room");
    Light light3 = new DLight("Watercloset");

    CeilingFan ceilingFan = new DCeilingFan("Living Room");

    TV tv1 = new DTV("Living Room");
    TV tv2 = new DTV("Bath Room");

    LightOnCommand lightOn1 = new DLightOnCommand(light1);
    LightOnCommand lightOn2 = new DLightOnCommand(light2);
    LightOnCommand lightOn3 = new DLightOnCommand(light3);

    LightOffCommand lightOff1 = new DLightOffCommand(light1);
    LightOffCommand lightOff2 = new DLightOffCommand(light2);
    LightOffCommand lightOff3 = new DLightOffCommand(light3);

    CeilingFanHighCommand ceilingFanHigh = new DCeilingFanHighCommand(ceilingFan);
    CeilingFanLowCommand ceilingFanLow = new DCeilingFanLowCommand(ceilingFan);

    TVOnCommand tvOn1 = new DTVOnCommand(tv1);
    TVOffCommand tvOff1 = new DTVOffCommand(tv1);

    TVOnCommand tvOn2 = new DTVOnCommand(tv2);
    TVOffCommand tvOff2 = new DTVOffCommand(tv2);

    Command[] commands1 = [lightOn1, lightOn2, lightOn3, tvOn1, tvOn2].map!(a => cast(Command)a).array;
    Command[] commands2 = [lightOff1, lightOff2, lightOff3, tvOff1, tvOff2].map!(a => cast(Command)a).array;
    MacroCommand allOn = new DMacroCommand(commands1);
    MacroCommand allOff = new DMacroCommand(commands2);

    remoteControl.setCommand(0, lightOn1, lightOff1);
    remoteControl.setCommand(1, lightOn2, lightOff2);
    remoteControl.setCommand(2, lightOn3, lightOff3);
    remoteControl.setCommand(3, ceilingFanHigh, ceilingFanLow);
    remoteControl.setCommand(4, tvOn1, tvOff1);
    remoteControl.setCommand(5, tvOn2, tvOff2);
    remoteControl.setCommand(6, allOn, allOff);

    writeln("Fan:");
    remoteControl.onButtonPressed(3);
    writeln("Light:");
    remoteControl.onButtonPressed(1);  
    writeln("Undo:");
    remoteControl.undoButtonPressed();  
    writeln("All On:");
    remoteControl.onButtonPressed(6);   
    writeln("All Off:");
    remoteControl.offButtonPressed(6);  
    writeln("Undo:");
    remoteControl.undoButtonPressed();  
    writeln("TV:");
    remoteControl.offButtonPressed(4);  
    }}
	*/