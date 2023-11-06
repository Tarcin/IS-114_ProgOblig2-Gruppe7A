include tables

rod = circle(5, "solid", "black")
red-c = circle(20,"solid","red")
green-c = circle(30,"solid","green")
blue-c = circle(40,"solid","blue")
orange-c = circle(50,"solid","orange")
box = put-image(text("1",14,"slate-grey"), 100, 10,
  put-image(text("2",14,"slate-grey"), 200, 10,
    put-image(text("3",14,"slate-grey"), 300, 10, empty-scene(400, 150))))

var move-history = table: move :: Number, from-rod :: Number, to-rod :: Number
end
  
hanoi = array-of(1, 4)
circle-list = [list: red-c, green-c, blue-c, orange-c]

#|Function that simply starts a new game by resetting the hanoi list and the move-history table, 
  and returns the move-history from the previous session|#
fun new-game(): 
  block:
    temp = move-history
    for each(i from range(0, 4)):
      hanoi.set-now(i, 1)
    end
    move-history := move-history.empty()
    print("Moves from last game:")
    temp
  end
end

#|function that takes 1-3 as valid inputs for the rods numbered 1, 2, 3 and moves the top circle from the location rod to the
  destination rod, as long as it's a legal move or there actually is a circle to be moved|#
fun move(location :: Number, destination :: Number):
  if (num-max(location, destination) > 3) or (num-min(location, destination) < 1):
    "Not a valid rod location, use 1-3"
  else:
    first-rod1 = find-first(location, 0)
    first-rod2 = find-first(destination, 0)
    if first-rod1 == 4:
      "No circle to move from location"
    else if first-rod1 < first-rod2:
      block:
        hanoi.set-now(first-rod1, destination)
        move-history := move-history.add-row(move-history.row(move-history.length() + 1, location, destination))
        hanoi-state()
      end
    else:
      "Illegal move"
    end
  end
end

#|Function that regrets the last move. Accomplished by updating the hanoi list to reflect the old state, 
  and removing the last row of the move-history|#
fun regret(): 
  if move-history.length() < 1:
      "no more moves to regret..."
    else:
    block:
      last-move = move-history.row-n(move-history.length() - 1)
      hanoi.set-now(find-first(last-move["to-rod"], 0), last-move["from-rod"])
      temp = remove(move-history.all-rows(), last-move)
      move-history := move-history.empty()
      for each(elem from temp):
          move-history := move-history.add-row(elem)
      end
      print("Move history after regret:")
      move-history
    end
  end
end

#|Function used to simply find the index of the first entry in the hanoi array that 
  matches the given identifier for the rods 1-3|#
fun find-first(pos :: Number, index :: Number):
  if (index > 3) or (hanoi.get-now(index) == pos):
    index
  else:
    find-first(pos, index + 1)
  end
end

#Function that recursively goes through the hanoi array to generate the rod images
fun build-rod(index :: Number, pos :: Number):
  ask:
    |index > 3 then: empty-image
    |hanoi.get-now(index) == pos then: overlay(circle-list.get(index), build-rod(index + 1, pos))
    |otherwise: build-rod(index + 1, pos)
  end
end

#|Function that calls build-rod(), then assembles and prints the picture of the 
  current position in the hanoi game, and resets the variables for each rod|#
fun hanoi-state():
  block:
    step-1 = put-image(overlay(rod, build-rod(0, 1)), 100, 75, box)
    step-2 = put-image(overlay(rod, build-rod(0, 2)), 200, 75, step-1)
    step-3 = put-image(overlay(rod, build-rod(0, 3)), 300, 75, step-2)
    step-3
  end
end

#Generates an image for the Hanoi Game Menu
fun hanoi-menu():
  above(text("Hanoi Game Menu", 24, "black"),
    above(text("new-game() will start the game with a fresh board", 16, "black"),
      above(text("move(location, destination) moves a plate from one rod to another. Rods are numbered 1-3 left to right", 16, "black"),
        above(text("regret() lets you take back a move", 16, "black"),
          above(text("hanoi-state() will show the board in its current state", 16, "black"),
            text("hanoi-menu() will repeat these instructions", 16, "black"))))))
end

hanoi-menu()
