class Knights_Travail

  def initialize
    @visited = []
    @route = []
  end

  def choose_move(loc, dest)
    loop do
      moves = show_moves(loc)
      loc = moves[0]
      @route << loc
      return @route if is_a_cycle?(loc)
      @visited << loc
    end
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
print kt.choose_move([3, 1], [7, 7])