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

#fix this
def find_shortcuts(visited)
  shortcuts = []
  visited.each do |v|
    show_moves(v).each do |m|
      if !(show_moves(m) & visited[visited.index(v)..-1]).empty? #distance saved shouldn't be hardcoded
        shortcut_start = visited.index(v)
        shortcut_end = visited.index((show_moves(m) & visited[visited.index(v)..-1])[0])
        shortcuts << [v, m, visited[shortcut_start..shortcut_end].length]
        best = shortcuts.max_by { |s| s[2] }
        visited[shortcut_start..shortcut_end] = [m]
        break
      end
    end
  end
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

print find_route([0, 0], [7, 7])