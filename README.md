# jstack_parser

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

TODO include AName, thread state?
