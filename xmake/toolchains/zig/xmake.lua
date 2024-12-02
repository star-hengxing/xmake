--!A cross-platform build utility based on Lua
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Copyright (C) 2015-present, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        xmake.lua
--

-- define toolchain
toolchain("zig")
    set_homepage("https://ziglang.org/")
    set_description("Zig Programming Language Compiler")

    on_check(function (toolchain)
        import("lib.detect.find_tool")
        local paths = {}
        for _, package in ipairs(toolchain:packages()) do
            local envs = package:envs()
            if envs then
                table.join2(paths, envs.PATH)
            end
        end
        local zig = get_config("zc")
        local zig_version
        if not zig then
            zig = find_tool("zig", {force = true, version = true, paths = paths})
            if zig and zig.program then
                zig_version = zig.version
                zig = zig.program
            end
        end
        if zig then
            toolchain:config_set("zig", zig)
            toolchain:config_set("zig_version", zig_version)
            toolchain:configs_save()
            return true
        end
    end)

    on_load(function (toolchain)
        import("core.base.semver")

        -- @see https://github.com/xmake-io/xmake/issues/5610
        function _generate_zigcc_wrapper(zig)
            local tools = {}
            for _, tool in ipairs { "cc", "c++", "ar", "ranlib", "objcopy" } do
                local wrapper_path = path.join(os.tmpdir(), "zigcc", tool)
                if not os.is_host("windows") then
                    io.writefile(wrapper_path, ("#!/bin/bash\nexec \"%s\" %s \"$@\""):format(zig, tool))
                    os.runv("chmod", {"+x", wrapper_path})
                else
                    io.writefile(wrapper_path .. ".cmd", ("@echo off\n\"%s\" %s %%*"):format(zig, tool))
                end
                tools[tool] = wrapper_path
            end
            return tools
        end

        -- set toolset
        -- we patch target to `zig cc` to fix has_flags. see https://github.com/xmake-io/xmake/issues/955#issuecomment-766929692
        local zig = toolchain:config("zig") or "zig"
        local zig_version = toolchain:config("zig_version")
        if toolchain:config("zigcc") ~= false then
            -- we can use `set_toolchains("zig", {zigcc = false})` to disable zigcc
            -- @see https://github.com/xmake-io/xmake/issues/3251
            local zig_wrapper = _generate_zigcc_wrapper(zig)
            toolchain:set("toolset", "cc",      zig_wrapper["cc"])
            toolchain:set("toolset", "cxx",     zig_wrapper["c++"])
            toolchain:set("toolset", "ld",      zig_wrapper["c++"])
            toolchain:set("toolset", "sh",      zig_wrapper["c++"])
            toolchain:set("toolset", "ar",      zig_wrapper["ar"])
            toolchain:set("toolset", "ranlib",  zig_wrapper["ranlib"])
            toolchain:set("toolset", "objcopy", zig_wrapper["objcopy"])
            toolchain:set("toolset", "as",      zig_wrapper["cc"])
        end
        toolchain:set("toolset", "zc",   zig)
        toolchain:set("toolset", "zcar", zig)
        toolchain:set("toolset", "zcld", zig)
        toolchain:set("toolset", "zcsh", zig)

        -- init arch
        if toolchain:is_arch("arm64", "arm64-v8a") then
            arch = "aarch64"
        elseif toolchain:is_arch("arm", "armv7") then
            arch = "arm"
        elseif toolchain:is_arch("i386", "x86") then
            if zig_version and semver.compare(zig_version, "0.11") >= 0 then
                arch = "x86"
            else
                arch = "i386"
            end
        elseif toolchain:is_arch("riscv64") then
            arch = "riscv64"
        elseif toolchain:is_arch("loong64") then
            arch = "loong64"
        elseif toolchain:is_arch("mips.*") then
            arch = toolchain:arch()
        elseif toolchain:is_arch("ppc64") then
            arch = "powerpc64"
        elseif toolchain:is_arch("ppc") then
            arch = "powerpc"
        elseif toolchain:is_arch("s390x") then
            arch = "s390x"
        else
            arch = "x86_64"
        end

        -- init target
        local target
        if toolchain:is_plat("cross") then
            -- xmake f -p cross --toolchain=zig --cross=mips64el-linux-gnuabi64
            target = toolchain:cross()
        elseif toolchain:is_plat("macosx") then
            --@see https://github.com/ziglang/zig/issues/14226
            target = arch .. "-macos-none"
        elseif toolchain:is_plat("linux") then
            if arch == "arm" then
                target = "arm-linux-gnueabi"
            elseif arch == "mips64" or arch == "mips64el" then
                target = arch .. "-linux-gnuabi64"
            else
                target = arch .. "-linux-gnu"
            end
        elseif toolchain:is_plat("windows") then
            target = arch .. "-windows-msvc"
        elseif toolchain:is_plat("mingw") then
            target = arch .. "-windows-gnu"
        end
        if target then
            toolchain:add("zig_cc.asflags", "-target", target)
            toolchain:add("zig_cc.cxflags", "-target", target)
            toolchain:add("zig_cc.shflags", "-target", target)
            toolchain:add("zig_cc.ldflags", "-target", target)
            toolchain:add("zig_cxx.cxflags", "-target", target)
            toolchain:add("zig_cxx.shflags", "-target", target)
            toolchain:add("zig_cxx.ldflags", "-target", target)
            toolchain:add("zcflags", "-target", target)
            toolchain:add("zcldflags", "-target", target)
            toolchain:add("zcshflags", "-target", target)
        end

        -- @see https://github.com/ziglang/zig/issues/5825
        if toolchain:is_plat("windows") then
            toolchain:add("zcldflags", "--subsystem console")
            toolchain:add("zcldflags", "-lkernel32", "-lntdll")
        end
    end)
