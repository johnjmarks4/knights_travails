def choose_move(loc, dest)
  loc = lightest(loc, dest)
  choose_move(loc, dest)
end

def lightest(loc, dest)
  moves = []

  show_moves(loc).each do |loc|
    moves << [loc, (dest.inject(:+) - loc.inject(:+)).abs]
  end

  lowest_weight = moves.min_by { |m| m[1] }
  lowest_weight[0]
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

print lightest([0, 0], [4, 3])