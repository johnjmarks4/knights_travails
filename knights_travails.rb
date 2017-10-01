require 'benchmark'

def find_route(loc, dest)
  visited = [loc]
  no_visit = []
  until loc == dest do
    moves = show_moves(loc)
    moves.each { |m| moves.delete(m) if no_visit.include?(m) }
    loc = lightest(moves, dest)
    if is_a_cycle?(loc, visited)
      result = backtrack(loc, no_visit, visited)
      loc, no_visit = result[0], result[1]
    end
    visited << loc
  end
  find_shortcuts(visited.uniq!)
end

def find_shortcuts(visited)
  candidates = []
  visited.each do |v|
    show_moves(v).each do |m|
      if !visited.include?(m)
        show_moves(m).each do |s|
          if visited.include?(s)
            start = v
            finish = s
            shortcut = m
            candidates << [start, shortcut, finish]
          end
        end
      end
    end
  end
  fastest = find_fastest(candidates, visited)
  take_shortcut(fastest, visited)
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
  i = -2
  no_visit << loc
  until visited[i] == loc
    no_visit << visited[i]
    i -= 1
  end
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

def benchmark(run)
  value = Benchmark.measure { run.times { find_route([2, 2], [2, 3]) } }
  avg_run_time = value / run
end

#print benchmark(20)
print find_route([2, 3], [2, 2])