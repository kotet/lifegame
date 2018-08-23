enum string CLEAR = "\033[2J";
enum BLOCK = "█";
enum UPPER = "▀";
enum LOWER = "▄";

void main(string[] args)
{
	import std.stdio;
	import core.thread : Thread;
	import std.datetime : dur;
	import std.getopt : getopt, defaultGetoptPrinter;
	import std.conv : to;
	import reference;

	size_t width = 20;
	size_t height = 20;
	size_t delay = 16;

	auto helpInformation = getopt(args, "width", &width, "height", &height, "delay", &delay);
	if (helpInformation.helpWanted)
	{
		defaultGetoptPrinter("Conway's lifegame.", helpInformation.options);
		return;
	}

	auto lg = LifeGameReference(width, height);

	// グライダー
	lg.set(0, 1, true);
	lg.set(1, 2, true);
	lg.set(2, 0, true);
	lg.set(2, 1, true);
	lg.set(2, 2, true);

	write(CLEAR);

	while (true)
	{
		auto table = lg.dump();
		if (table.length % 2 == 1)
		{
			table ~= new bool[](table[0].length);
		}

		lg.next();

		string result = "\033[" ~ ((height + 3) / 2).to!string ~ "A";
		foreach (y; 0 .. (height + 1) / 2)
		{
			foreach (x; 0 .. width)
				if (table[y * 2][x] == 1)
				{
					if (table[y * 2 + 1][x] == 1)
					{
						result ~= BLOCK;
					}
					else
					{
						result ~= UPPER;
					}
				}
				else
				{
					if (table[y * 2 + 1][x] == 1)
					{
						result ~= LOWER;
					}
					else
					{
						result ~= ".";
					}
				}
			result ~= "\n";
		}
		result.writeln;
		stdout.flush();

		Thread.sleep(dur!"msecs"(delay));
	}
}
