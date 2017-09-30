class Knights_Travail

  def initialize
    @visited = []
    @possible = []
    @route = []
  end

  def choose_move(loc, dest)
    @route << loc
    return @route if show_moves(loc).include?(dest)

    moves = show_moves(loc) # delete route move overlap
    loc = moves[rand(0..moves.length-1)]

    choose_move(loc, dest)
  end

  def all_moves(loc) #crack this and the actual search algorithm will be easy
    moves = []
    moves << loc
    @visited << loc

    #while !moves.empty?
    500.times do
      show_moves(loc).each { |m| moves << m }
      moves.uniq!
      before = moves.length
      moves.each { |e| moves.delete(e) if @visited.include?(e) }
      if !moves.empty?
        loc = moves[0]
        @visited << loc
      end
    end
    @visited.uniq!
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
print kt.all_moves([3, 1])