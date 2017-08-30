all = [] of Array(String)
raise "syntax: jstack_filename" unless ARGV.size > 0
stack = File.read(ARGV[0])
current = [] of String
stack.each_line{|l|
  if l.starts_with?("\"")
    all << current.clone
    current.clear # !
  end
  current << l
}
all = all[1..-1] # ignore first which is the header
puts all[1..6].pretty_inspect

