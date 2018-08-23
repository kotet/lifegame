enum string CLEAR = "\033[2J";
enum BLOCK = "█";
enum UPPER = "▀";
enum LOWER = "▄";

void main(string[] args)
{
	import std.stdio;
	import core.thread : Thread;
	import std.datetime : dur;
	import std.random : choice;
	import std.getopt : getopt, defaultGetoptPrinter;
	import std.range : zip, join;
	import std.algorithm : map;
	import std.typecons : Tuple;
	import std.conv : to;

	size_t width = 20;
	size_t height = 20;
	string data_filename = "";
	size_t delay = 100;

	auto helpInformation = getopt(args, "width", &width, "height", &height,
			"data", &data_filename, "delay", &delay);
	if (helpInformation.helpWanted)
	{
		defaultGetoptPrinter("Conway's lifegame.", helpInformation.options);
		return;
	}

	ubyte[][] table = new ubyte[][](height + 2, width + 2);
	ubyte[][] next = new ubyte[][](height + 2, width + 2);

	// グライダー
	table[1][2] = 1;
	table[2][3] = 1;
	table[3][1] = 1;
	table[3][2] = 1;
	table[3][3] = 1;

	// foreach (ref row; table[1 .. $ - 1])
	// 	foreach (ref cell; row[1 .. $ - 1])
	// 	{
	// 		cell = choice(cast(ubyte[])[0, 1]);
	// 	}

	write(CLEAR ~ CLEAR);

	while (true)
	{
		table[0][] = table[$ - 2][];
		table[$ - 1][] = table[1][];
		foreach (ref r; table)
		{
			r[0] = r[$ - 2];
			r[$ - 1] = r[1];
		}
		table[0][0] = table[$ - 2][$ - 2];
		table[$ - 1][$ - 1] = table[1][1];

		foreach (x; 1 .. width + 1)
			foreach (y; 1 .. height + 1)
			{
				auto cnt = table[y - 1][x - 1] + table[y - 1][x]
					+ table[y - 1][x + 1] + table[y][x - 1] + table[y][x + 1]
					+ table[y + 1][x - 1] + table[y + 1][x] + table[y + 1][x + 1];

				if (table[y][x] == 0)
				{
					if (cnt == 3)
						next[y][x] = 1;
					else
						next[y][x] = 0;
				}
				else if (2 <= cnt && cnt <= 3)
				{
					next[y][x] = 1;
				}
				else
				{
					next[y][x] = 0;
				}
			}

		string result = "\033[" ~ ((height + 3) / 2).to!string ~ "A";
		foreach (y; 0 .. (height + 1) / 2)
		{
			foreach (x; 1 .. width + 1)
				if (table[y * 2 + 1][x] == 1)
				{
					if (table[y * 2 + 2][x] == 1)
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
					if (table[y * 2 + 2][x] == 1)
					{
						result ~= LOWER;
					}
					else
					{
						result ~= "_";
					}
				}
			result ~= "\n";
		}
		result.writeln;
		stdout.flush();

		foreach (i, ref r; table)
			r[] = next[i][];
		Thread.sleep(dur!"msecs"(delay));
	}
}
