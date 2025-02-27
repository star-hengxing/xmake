# prefix
include $(PRO_DIR)/prefix.mak

# module name
NAMES 					= xmake

# module type
xmake_TYPE 				= LIB

# config
xmake_CONFIG 			= y

# core files
xmake_C_FILES 			+= \
						xmake \
						engine \
						os/argv \
						os/args \
						os/find \
						os/link \
						os/isdir \
						os/rmdir \
						os/mkdir \
						os/cpdir \
						os/chdir \
						os/mtime \
						os/sleep \
						os/mclock \
						os/curdir \
						os/tmpdir \
						os/isfile \
						os/islink \
						os/touch \
						os/rmfile \
						os/cpfile \
						os/rename \
						os/exists \
						os/setenv \
						os/getenv \
						os/getenvs \
						os/cpuinfo \
						os/meminfo \
						os/readlink \
						os/emptydir \
						os/syserror \
						os/strerror \
						os/filesize \
						os/getwinsize \
						os/uid \
						os/gid \
						os/getpid \
						os/getown \
						io/stdfile \
						io/file_size \
						io/file_close \
						io/file_flush \
						io/file_isatty \
						io/file_open \
						io/file_read \
						io/file_readable \
						io/file_seek \
						io/file_write \
						io/file_rawfd \
						io/filelock_open \
						io/filelock_lock \
						io/filelock_unlock \
						io/filelock_trylock \
						io/filelock_close \
						io/poller \
						io/poller_wait \
						io/poller_insert \
						io/poller_remove \
						io/poller_modify \
						io/poller_spank \
						io/poller_support \
						io/socket_open \
						io/socket_ctrl \
						io/socket_rawfd \
						io/socket_wait \
						io/socket_bind \
						io/socket_listen \
						io/socket_accept \
						io/socket_connect \
						io/socket_send \
						io/socket_sendto \
						io/socket_sendfile \
						io/socket_recv \
						io/socket_recvfrom \
						io/socket_close \
						io/socket_peeraddr \
						io/pipe_open \
						io/pipe_openpair \
						io/pipe_close \
						io/pipe_read \
						io/pipe_write \
						io/pipe_wait \
						io/pipe_connect \
						path/relative \
						path/absolute \
						path/translate \
						path/directory \
						path/is_absolute \
						hash/uuid4 \
						hash/sha \
						hash/md5 \
						hash/xxhash \
						base64/encode \
						base64/decode \
						string/trim \
						string/split \
						string/lastof \
						string/convert \
						string/endswith \
						string/startswith \
						process/open \
						process/openv \
						process/wait \
						process/kill \
						process/close \
						fwatcher/open \
						fwatcher/add \
						fwatcher/remove \
						fwatcher/wait \
						fwatcher/close \
						sandbox/interactive \
						semver/parse \
						semver/compare \
						semver/satisfies \
						semver/select \
						semver/semver \
						curses/curses \
						readline/readline \
						readline/history_list \
						readline/add_history \
						readline/clear_history \
						libc/malloc \
						libc/free \
						libc/memset \
						libc/memcpy \
						libc/memmov \
						libc/dataptr \
						libc/byteof \
						libc/setbyte \
						libc/strndup \
						tty/term_mode \
						lz4/compress \
						lz4/decompress \
						lz4/block_compress \
						lz4/block_decompress \
						lz4/compress_file \
						lz4/compress_stream_open \
						lz4/compress_stream_read \
						lz4/compress_stream_write \
						lz4/compress_stream_close \
						lz4/decompress_file \
						lz4/decompress_stream_open \
						lz4/decompress_stream_read \
						lz4/decompress_stream_write \
						lz4/decompress_stream_close \
						bloom_filter/bloom_filter_open \
						bloom_filter/bloom_filter_close \
						bloom_filter/bloom_filter_clear \
						bloom_filter/bloom_filter_data \
						bloom_filter/bloom_filter_size \
						bloom_filter/bloom_filter_get \
						bloom_filter/bloom_filter_set \
						bloom_filter/bloom_filter_data_set

iswin =
ifeq ($(PLAT),windows)
	iswin = yes
endif
ifeq ($(PLAT),msys)
	iswin = yes
endif
ifeq ($(PLAT),mingw)
	iswin = yes
endif
ifeq ($(PLAT),cygwin)
	iswin = yes
endif

ifdef iswin
xmake_C_FILES 			+= \
						winos/ansi \
						winos/logical_drives \
						winos/registry_keys \
						winos/registry_values \
						winos/registry_query \
						winos/short_path
endif

# flags
xmake_CXFLAGS 			+= -D__tb_prefix__=\"xmake\"
xmake_CXFLAGS 			+= $(if $(findstring readline,$(base_LIBNAMES)),-DXM_CONFIG_API_HAVE_READLINE,)
xmake_CXFLAGS 	   	    += $(if $(findstring curses,$(base_LIBNAMES)),-DXM_CONFIG_API_HAVE_CURSES,)

# includes
xmake_INC_DIRS 		    += \
						../tbox/tbox/src \
						../tbox/inc/$(PLAT) \
                        ../sv/sv/include \
						../lz4/lz4/lib \
						../xxhash
ifeq ($(RUNTIME),luajit)
xmake_INC_DIRS 			+= ../luajit/luajit/src
xmake_CXFLAGS 			+= -DUSE_LUAJIT
endif
ifeq ($(RUNTIME),lua)
xmake_INC_DIRS 			+= ../lua/lua
xmake_CXFLAGS 			+= -DLUA_COMPAT_5_1 -DLUA_COMPAT_5_2 -DLUA_COMPAT_5_3
endif
xmake_CXFLAGS 			+= -DXM_CONFIG_VERSION_BRANCH="\"$(BRANCH)\""
xmake_CXFLAGS 			+= -DXM_CONFIG_VERSION_COMMIT="\"$(COMMIT)\""

# suffix
include $(PRO_DIR)/suffix.mak

