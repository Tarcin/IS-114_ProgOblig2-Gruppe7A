include tables

rod = circle(5, "solid", "black")
red-c = circle(20,"solid","red")
green-c = circle(30,"solid","green")
blue-c = circle(40,"solid","blue")
orange-c = circle(50,"solid","orange")
box = put-image(text("1",14,"slate-grey"), 100, 10,
  put-image(text("2",14,"slate-grey"), 200, 10,
    put-image(text("3",14,"slate-grey"), 300, 10, empty-scene(400, 150))))

var l-rod = rod
var m-rod = rod
var r-rod = rod
var move-history = table: move :: Number, from-rod :: Number, to-rod :: Number
end
  
var hanoi = [list: 1, 1, 1, 1]
circle-list = [list: red-c, green-c, blue-c, orange-c]

#|Function that simply starts a new game by resetting the hanoi list and the move-history table, 
  and returns the move-history from the previous session|#
fun new-game(): 
  block:
    temp = move-history
    hanoi := [list: 1, 1, 1, 1]
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
        hanoi := hanoi.set(first-rod1, destination)
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
      hanoi := hanoi.set(find-first(last-move["to-rod"], 0), last-move["from-rod"])
      temp = move-history.all-rows()
      move-history := move-history.empty()
      for each(elem from temp):
        if elem == last-move:
          0
        else:
          move-history := move-history.add-row(elem)
        end
      end
    end
    end
end

#|Function used to simply find the index of the first entry in the hanoi array that 
  matches the given identifier for the rods 1-3|#
fun find-first(pos :: Number, index :: Number):
  if hanoi.get(index) == pos:
    index
  else if index >= 3:
    4
  else:
    find-first(pos, index + 1)
  end
end

#Function that recursively goes through the hanoi array to generate the rod images
fun build-rods(index :: Number):
  temp = hanoi.get(index)
  block:  
    if temp == 1:
      l-rod := overlay(l-rod, circle-list.get(index))
    else if temp == 2:
      m-rod := overlay(m-rod, circle-list.get(index))
    else: 
      r-rod := overlay(r-rod, circle-list.get(index))
    end
  if index < 3: 
    build-rods(index + 1)
  else:
    #this block doesn't make much sense, consider revamping the function
    "returning..."
  end
  end
end

#|Function that calls build-rods(), then assembles and prints the picture of the 
  current position in the hanoi game, and resets the variables for each rod|#
fun hanoi-state():
  block:
    build-rods(0)
    step-1 = put-image(l-rod, 100, 75, box)
    step-2 = put-image(m-rod, 200, 75, step-1)
    step-3 = put-image(r-rod, 300, 75, step-2)
    l-rod := rod
    m-rod := rod
    r-rod := rod
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
