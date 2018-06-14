all = [] of Array(String)

if ARGV.size < 1 || ARGV.includes?("-h") || ARGV.includes?("--help")
  puts  "syntax: #{PROGRAM_NAME} <jstack_filename> <criteria>
    criteria options: 
      \"size > X\"
      \"exclude ThisString\"
      ex: jstack_parser jstack_filename \"size > 3\" \"exclude DontWant\"
"
  exit 1
end

criteria = ARGV[1..-1]

stack = File.read(ARGV[0])

current_trace = [] of String
stack.each_line{|l|
  l = l.gsub("\t", "   ")
  if l.starts_with?("\"")
    all << current_trace.clone
    current_trace.clear # !
  end
  current_trace << l
}

all = all[1..-1] # ignore first which is the header "trace"

criteria.each{|criterion|

if criterion =~ /size > (\d+)/
  min_size = $1.to_i
  puts "specifying min size #{min_size}"
  all = all.select{|stack| stack.size > min_size}
end

if criterion =~ /exclude (\S+)/ # \S is non whitespace
  exclude_this = $1
  puts "excluding #{exclude_this}"
  all = all.reject{|stack| stack.join.includes?(exclude_this) }
end 

}

all.each{|trace|
  puts trace.join("\n")
  puts "\n" # follow normal jstack semantics a bit :)
}

