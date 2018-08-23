module reference;

struct LifeGameReference
{
private:
    size_t width;
    size_t height;
    ubyte[][] table;
    ubyte[][] _next;
public:
    this(size_t _width, size_t _height)
    {
        width = _width;
        height = _height;
        table = new ubyte[][](height + 2, width + 2);
        _next = new ubyte[][](height + 2, width + 2);
    }

    bool[][] dump()
    {
        import std.algorithm : map;
        import std.range : array;

        return table[1 .. $ - 1].map!(r => r[1 .. $ - 1])
            .map!(c => c.map!(x => x == 1).array)
            .array;
    }

    void set(size_t x, size_t y, bool value)
    {
        table[y + 1][x + 1] = value ? 1 : 0;
    }

    void next()
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
                        _next[y][x] = 1;
                    else
                        _next[y][x] = 0;
                }
                else if (2 <= cnt && cnt <= 3)
                {
                    _next[y][x] = 1;
                }
                else
                {
                    _next[y][x] = 0;
                }
            }
        foreach (i, ref r; table)
            r[] = _next[i][];
    }
}
