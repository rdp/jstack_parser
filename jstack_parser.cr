all = [] of Array(String)

if ARGV.size != 2 || ARGV.includes?("-h") || ARGV.includes?("--help")
  puts  "syntax: #{PROGRAM_NAME} <jstack_filename> <criteria> (only one supported for now)
    criteria options: 
      \"size > X\"
      \"exclude ThisString\""
  exit 1
end

criteria = ARGV[1]

stack = File.read(ARGV[0])
current = [] of String
stack.each_line{|l|
  l = l.gsub("\t", "   ")
  if l.starts_with?("\"")
    all << current.clone
    current.clear # !
  end
  current << l.strip
}
all = all[1..-1] # ignore first which is the header

if criteria =~ /size > (\d+)/
  min_size = $1.to_i
  puts "specifying min size #{min_size}"
  all = all.select{|stack| stack.size > min_size}
end

if criteria =~ /exclude (\S+)/ # \S is non whitespace
  exclude_this = $1
  puts "excluding #{exclude_this}"
  all = all.reject{|stack| stack.join.includes?(exclude_this) }
end 

all.each{|trace|
  puts trace.join("\n")
  puts "\n" # follow normal jstack semantics a bit :)
}

