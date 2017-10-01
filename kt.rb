class Knights_Travail

  def initialize
    @visited = []
    @no_visit = []
  end

  def find_route(loc, dest)
    until loc == dest do
      moves = show_moves(loc)
      moves.each { |m| moves.delete(m) if @no_visit.include?(m) }
      loc = lightest(moves, dest)
      loc = backtrack(loc) if is_a_cycle?(loc)
      @visited << loc
    end
    @visited.uniq!
  end

  def backtrack(loc)
    i = -2
    @no_visit << loc
    until @visited[i] == loc
      @no_visit << @visited[i]
      i -= 1
    end
    loc = @visited[i]
  end

  def lightest(moves, dest)
    all = []
    moves.each do |m|
      all << [m, (m.inject(:+) - dest.inject(:+)).abs]
    end

    best = all.min_by { |m| m[1] }
    best[0]
  end

  def is_a_cycle?(loc)
    @visited.include?(loc)
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
end

kt = Knights_Travail.new
print kt.find_route([0, 0], [7, 7])