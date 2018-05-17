

This is an amazing parser to help you look through large jstacks and find the "threads you want".
Why? Because it's tricky to split these up and run greps on multi-line things like this in bash.

Want to exclude some traces that are irrelevant?

$ jstack_parser stack_trace_filename "size > 15" 
# exclude traces that are too small, and probably not doing anything

$ jstack_parser stack_trace_filename "exclude ClassName" 
# exclude traces from a particular class, or use a methodname, package, etc.

How to use: git clone it, install 'crystal language' compiler, run
$ crystal build jstack_parser.cr

then run it from there.  Enjoy!  Feature requests file as issues.

to deploy to an "old OS linux box" with no crystal compiler available:

crystal build jstack_parser.cr  --cross-compile --target "x86_64-unknown-linux-gnu"
build libcrystal.a there:

git clone https://github.com/crystal-lang/crystal
cd crystal

centos cross compile: first install some dependencies:
sudo yum install make -y
sudo yum install llvm-devel
sudo yum install pcre-devel
yum install libevent2-devel

# sudo yum install gc-devel # not enough, not new enough
sudo yum install automake
sudo yum install libtool
install libgc via: https://github.com/crystal-lang/crystal/wiki/All-required-libraries

then your equivalent of
cc 'jstack_parser.o' -o 'jstack_parser'  -rdynamic  -lpcre -lgc -lpthread ./crystal/src/ext/libcrystal.a -levent -lrt -ldl -L/usr/lib -L/usr/local/lib -L ./bdwgc/.libs

TODO include AName, thread state?
