rule("cppfront")
    set_extensions(".cpp2")
    on_load(function (target)
        local rule = target:rule("c++.build"):clone()
        rule:add("deps", "cppfront", {order = true})
        target:rule_add(rule)
    end)
    on_build_file(function (target, sourcefile, opt)
        print("build cppfront file")
        local objectfile = target:objectfile(sourcefile:gsub("cpp2", "cpp"))
        assert(not os.isfile(objectfile), "invalid rule order!")
    end)

target("test")
    set_kind("binary")
    add_rules("cppfront")
    add_files("src/*.cpp")
    add_files("src/*.cpp2")
    before_build_file(function (target, sourcefile, opt)
        local objectfile = target:objectfile(sourcefile)
        os.tryrm(objectfile)
    end)
