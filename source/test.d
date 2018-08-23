unittest
{
    import std.stdio : write, writeln;
    import std.random : choice;
    import reference;

    enum N = 500;

    "Normal test...".write();
    foreach (n; 8 .. N)
    {
        auto lgreference = LifeGameReference(n, n);

        foreach (x; 0 .. n)
            foreach (y; 0 .. n)
            {
                lgreference.set(x, y, choice([true, false]));
            }

        lgreference.next();

        auto reference_result = lgreference.dump;
    }

    "done.".writeln;

    import std.datetime.stopwatch : AutoStart, StopWatch;

    enum G = 1000;

    "Speed test...".writeln();

    auto sw = StopWatch(AutoStart.no);

    bool[][] reference_result;

    {
        "Reference:".writeln;
        auto lg = LifeGameReference(N, N);
        foreach (x; 0 .. N)
            foreach (y; 0 .. N)
            {
                lg.set(x, y, choice([true, false]));
            }

        sw.start();
        foreach (i; 0 .. G)
            lg.next();
        sw.stop();
        writeln("\t", sw.peek());
        reference_result = lg.dump;
    }
    "done.".writeln();
}
