require 'benchmark'

def find_route(loc, dest)
  visited = [loc]
  return visited if loc == dest
  no_visit = []
  until loc == dest do
    moves = show_moves(loc)
    no_visit << loc
    moves -= no_visit
    return loc if moves.length == 0
    loc = lightest(moves, dest)
    if is_a_cycle?(loc, visited)
      result = backtrack(loc, no_visit, visited)
      loc, no_visit = result[0], result[1]
    end
    visited << loc
  end
  visited.uniq!
  find_shortcuts(visited)
end

def find_shortcuts(visited)
  candidates = []
  visited.each do |s|
    show_moves(s).each do |c|
      if !visited.include?(c)
        show_moves(c).each do |f|
          if visited.include?(f) && s != f
            start = s
            finish = f
            shortcut = c
            candidates << [start, shortcut, finish]
          end
        end
      end
    end
  end
  if !candidates.empty?
    fastest = find_fastest(candidates, visited)
    take_shortcut(fastest, visited)
  else
    visited
  end
end

def find_fastest(candidates, visited)
  candidates.max_by do |c|
    start, finish = visited.index(c[0]), visited.index(c[2])
    visited[start..finish].length
  end
end

def take_shortcut(shortcut, visited)
  start = visited.index(shortcut[0]) + 1
  detour = [shortcut[1]]
  finish = visited.index(shortcut[2]) - 1
  visited[start..finish] = detour
  visited
end

def backtrack(loc, no_visit, visited)
  i = 0
  visited.each_with_index do |m, vi|
    i = vi
    break if m == loc
  end
  visited[i+1..-1].each { |m| no_visit << m }
  loc = visited[i]
  [loc, no_visit]
end

def lightest(moves, dest)
  all = []
  moves.each do |m|
    all << [m, (m.inject(:+) - dest.inject(:+)).abs]
  end

  best = all.min_by { |m| m[1] }
  best[0]
end

def is_a_cycle?(loc, visited)
  visited.include?(loc)
end

def show_moves(loc)
  r, c = loc[0], loc[1]
  moves = [[(r + 2),(c + 1)],
           [(r - 2),(c + 1)],
           [(r + 2),(c - 1)],
           [(r - 2),(c - 1)],
           [(r + 1),(c + 2)],
           [(r - 1),(c + 2)],
           [(r + 1),(c - 2)],
           [(r - 1),(c - 2)]]

    moves.select! { |x| x[0] <= 7 && x[0] >= 0 && x[1] <= 7 && x[1] >= 0 }
    moves
end

public
def print_message
  num_of_moves = self.length - 1
  puts "\n"
  puts "Congratulations, you made it in #{num_of_moves} moves."
  puts "Here is your route:"
  puts "\n"
  self.each { |m| puts m.inspect }
end

def benchmark(method_tested, arg, runs)
  value = Benchmark.measure { runs.times { method_tested.call(arg) } }
  print avg_run_time = value / runs
end

# The last 3 methods test find_route for every possible board route

def test_all
  coords = all_combos
  coords.each do |c|
    find_route(c[0], c[1])
  end
end

def all_combos
  coords = []
  (0..7).to_a.each do |f|
    (0..7).to_a.each do |l|
      coords << [f, l]
    end
  end
  ary = []
  coords.each do |c|
    ary << pair(c, coords)
  end
  con = []
  ary.each { |s| s.each { |e| con << e } }
  con
end

def pair(loc, dests)
  con = []
  dests.each do |dest|
    con << [loc, dest]
  end
  con
end

loc = [7, 7]
dest = [0, 0]

=begin
method_tested = Proc.new do |i|
  find_route(i[0], i[1])
end
benchmark(method_tested, [loc, dest], 100)
=end

find_route(loc, dest).print_message