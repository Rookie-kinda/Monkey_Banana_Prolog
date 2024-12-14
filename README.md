# Monkey and Banana Problem

The **Monkey and Banana Problem** is a classic artificial intelligence problem that demonstrates state-space search. The objective is to model the problem in Prolog and solve it using logical rules and search techniques.

---

## Problem Description

A monkey is in a room where:
1. A banana is hanging from the ceiling.
2. A chair and a stick are available as tools to help the monkey.

The monkey can:
- Move to different locations in the room.
- Pick up and use the stick.
- Climb on and off the chair.
- Push the chair to different locations.

### Goal State
- The monkey is on the chair, holding the stick, under the banana, and has the banana.

---

## Implementation in Prolog

The problem is modeled as a **state-space search problem**, where each state describes the environment and the monkey’s actions transition between states.

### State Representation
A state is represented as:

```
state(MonkeyPos, HasStick, ChairPos, MonkeyPosRelChair, HasBanana)
```

Where:
- `MonkeyPos`: Position of the monkey (`on_floor` or `on_chair`).
- `HasStick`: Whether the monkey is holding the stick (`yes` or `no`).
- `ChairPos`: Position of the chair (`under_banana`, `corner`, or `window`).
- `MonkeyPosRelChair`: Monkey’s position relative to the chair (`under_banana`, `corner`, or `window`).
- `HasBanana`: Whether the monkey has the banana (`yes` or `no`).

### Actions
The monkey can perform the following actions:
1. **Climb Up/Down the Chair**: The monkey can climb onto or off the chair.
2. **Move to Chair**: The monkey can move to the chair if it is not already near it.
3. **Push the Chair**: The monkey can push the chair to position it under the banana.
4. **Grasp the Stick**: The monkey can pick up the stick.
5. **Release the Stick**: The monkey can drop the stick.
6. **Hit the Banana**: The monkey can hit the banana with the stick to retrieve it.

### Rules
Each action is represented as a rule that defines how a state transitions to another state. For example:

- **Climb Up the Chair**:
```prolog
climb_up_chair(state(on_floor, HasStick, ChairPos, MonkeyPosRelChair, HasBanana), climb_up(monkey, chair),
    state(on_chair, HasStick, ChairPos, MonkeyPosRelChair, HasBanana)) :-
    MonkeyPosRelChair == ChairPos.
```

- **Move to Chair**:
```prolog
move_to_chair(state(MonkeyPos, HasStick, ChairPos, MonkeyPosRelChair, HasBanana), move(monkey, ChairPos),
              state(MonkeyPos, HasStick, ChairPos, ChairPos, HasBanana)) :-
    MonkeyPosRelChair \= ChairPos,
    MonkeyPos == on_floor.
```

### Search Algorithm
A depth-first search algorithm is used to explore all possible actions to reach the goal state.

- **Base Case**:
```prolog
search(State, Goal, _, []) :-
    State = Goal, writeln('Reached the goal');
    State = state(on_chair, _, MonkeyPosRelChair, MonkeyPosRelChair, yes), writeln('Reached the goal');
    State = state(on_floor, _, _, _, yes), writeln('Reached the goal').
```

- **Recursive Case**:
```prolog
search(State, Goal, Visited, [Action | Actions]) :-
    action(State, Action, NewState),
    \+ member(NewState, Visited),
    search(NewState, Goal, [NewState | Visited], Actions).
```

### Complete List of Actions
All possible actions are combined into a single rule:
```prolog
action(State, Action, NewState) :-
    climb_up_chair(State, Action, NewState);
    climb_down_chair(State, Action, NewState);
    move_to_chair(State, Action, NewState);
    grasp(State, Action, NewState);
    release(State, Action, NewState);
    move_chair(State, Action, NewState);
    hit(State, Action, NewState).
```

### Solving the Problem
To solve the problem, the `solve/1` predicate initiates the search:

```prolog
solve(InitialState) :-
    search(InitialState, state(on_chair, yes, under_banana, under_banana, yes), [InitialState], Actions),
    writeln(Actions).
```

---

## Example Queries

Below are example queries to test the program:

1. **Solve from the initial state**:
```prolog
solve(state(on_floor, no, corner, corner, no)).
```

2. **Monkey already has the stick**:
```prolog
solve(state(on_floor, yes, window, under_banana, no)).
```

3. **Invalid state**:
```prolog
solve(state(on_chair, no, under_banana, window, no)).
```

---

## How to Run the Program

1. Install Prolog (e.g., SWI-Prolog).
2. Save the code to a file named `monkey_banana.pl`.
3. Load the program (consult)
4. Execute queries to test the program.

---

## Files

1. `monkey_banana.pl`: Prolog implementation of the Monkey and Banana Problem.
2. `README.md`: Documentation for the problem and code.

---

## Authors
This project was made by Marwan Mohammed, Omar Ibrahim, and Mahmoud Taifour.

