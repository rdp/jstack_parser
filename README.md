This is an amazing parser to help you look through large jstacks and find the "threads you want".
Why? Because it's tricky to split these up and run greps on multi-line things like this in bash.
Imagine being able to pinpoint down to exactly the threads you care about in a jstack output...

Want to exclude some traces that are irrelevant?

$ jstack_parser stack_trace_filename "size > 15" 
# exclude traces that are too small, and probably not doing anything

$ jstack_parser stack_trace_filename "exclude ClassName" 
# exclude traces from a particular class, or use a methodname, package, etc.

How to use: git clone it, install 'crystal language' compiler, run

$ crystal build jstack_parser.cr

then run it from there.  Enjoy!  Feature requests welcome, file as issues.

============ to deploy to an "old OS linux box" with no crystal compiler available: ===============
Cross compile!

crystal build jstack_parser.cr  --cross-compile --target "x86_64-unknown-linux-gnu" # on new box with crystal
build libcrystal.a on target box:

git clone https://github.com/crystal-lang/crystal
cd crystal
make src/ext/libcrystal.a

centos target: first install some dependencies (warning, binary won't be distributable, if you want that, buidl these dependencies from scratch with --enable-static --disable-shared configure options):
sudo yum install make -y
sudo yum install llvm-devel
sudo yum install pcre-devel
yum install libevent2-devel

# sudo yum install gc-devel # not enough, not new enough
sudo yum install automake
sudo yum install libtool
install libgc via these instructions: https://github.com/crystal-lang/crystal/wiki/All-required-libraries

then your equivalent of this linking line:

cc 'jstack_parser.o' -o 'jstack_parser'  -rdynamic  -lpcre -lgc -lpthread ./crystal/src/ext/libcrystal.a -levent -lrt -ldl -L/usr/lib -L/usr/local/lib -L ./bdwgc/.libs

=== all static redistributable ===

Unfortunately with "yum install xxx" it creates a non distributable executable because it depends on some shared time load time libraries.  
So if you need to avoid that, instead of
yum install "xx" 
build them locally all static, like this:

sudo yum install automake
sudo yum install libtool
download pcre (not pcre2) 
./configure --enable-static --disable-shared --enable-utf8 && make

download libevent2 
https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
./configure --enable-static --disable-shared && make

and link like this:

cc 'jstack_parser.o' -o 'jstack_parser'  -rdynamic  -lpcre -lgc -lpthread ./crystal/src/ext/libcrystal.a -levent -lrt -ldl -L/usr/lib -L/usr/local/lib -L ./bdwgc/.libs -L ./pcre-8.42/.libs -L ./libevent-2.1.8-stable/.libs

==========TODO ==========

thread state
