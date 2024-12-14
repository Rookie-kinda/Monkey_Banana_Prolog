% - Monkey position (MonkeyPos): on_floor or on_chair
% - Holding a stick (HasStick): yes or no
% - Has a Banana (HasBanana): yes or no
% - Chair position (ChairPos): under_banana, corner, or window
% - Monkey position relative to the chair (MonkeyPosRelChair): corner, window, under_banana
% state(MonkeyPos, HasStick, ChairPos, MonkeyPosRelChair, HasBanana).

% Goal state:
% state(on_chair, yes, under_banana, under_banana, yes).

% Move the monkey to the chair or floor (Given that the monkey is near the chair)
climb_up_chair(state(on_floor, HasStick, ChairPos, MonkeyPosRelChair, HasBanana), climb_up(monkey, chair),
     state(on_chair, HasStick, ChairPos, MonkeyPosRelChair, HasBanana)):-
     MonkeyPosRelChair == ChairPos.
climb_down_chair(state(on_chair, HasStick, ChairPos, MonkeyPosRelChair, HasBanana), climb_down(monkey, floor),
     state(on_floor, HasStick, ChairPos, MonkeyPosRelChair, HasBanana)):-
     MonkeyPosRelChair == ChairPos.

% Move the monkey to the chair's position
move_to_chair(state(MonkeyPos, HasStick, ChairPos, MonkeyPosRelChair, HasBanana), move(monkey, ChairPos),
              state(MonkeyPos, HasStick, ChairPos, ChairPos, HasBanana)) :-
    MonkeyPosRelChair \= ChairPos,
    MonkeyPos == 'on_floor'.

% Grasp the stick (only on the floor and without the stick)
grasp(state(on_floor, no, ChairPos, MonkeyPosRelChair, HasBanana), grasp(stick),
      state(on_floor, yes, ChairPos, MonkeyPosRelChair, HasBanana)).

% Release the stick (only if holding it)
release(state(MonkeyPos, yes, ChairPos, MonkeyPosRelChair, HasBanana), release(stick),
        state(MonkeyPos, no, ChairPos, MonkeyPosRelChair, HasBanana)).

% Hit the banana with the stick (only on the chair and holding the stick)
hit(state(on_chair, yes, under_banana, MonkeyPosRelChair, no), hit(banana),
    state(on_chair, yes, under_banana, MonkeyPosRelChair, yes)).

% Move the chair to be under the banana (only if the monkey is near the chair and on the floor)
move_chair(state(MonkeyPos, HasStick, ChairPos, ChairPos, HasBanana), move(chair, under_banana),
           state(MonkeyPos, HasStick, under_banana, under_banana, HasBanana)):-
           MonkeyPos == on_floor.

% Search for a solution using depth-first search
search(State, Goal, _, []) :-
    State = Goal, writeln('Reached the goal');
    State = state(on_chair, _, MonkeyPosRelChair, MonkeyPosRelChair, yes), writeln('Reached the goal');
    State = state(on_floor, _, _, _, yes), writeln('Reached the goal').

search(State, Goal, Visited, [Action | Actions]) :-
    action(State, Action, NewState),
    \+ member(NewState, Visited), % Avoid revisiting states
    search(NewState, Goal, [NewState | Visited], Actions).

% Generic action rule
action(State, Action, NewState) :-
    climb_up_chair(State, Action, NewState);
    climb_down_chair(State, Action, NewState);
    move_to_chair(State, Action, NewState);
    grasp(State, Action, NewState);
    move_chair(State, Action, NewState);
    release(State, Action, NewState);
    hit(State, Action, NewState).


% Start the search
% If the monkey already has the banana, return an empty Actions list and True.

% If the monkey doesn't have the banana, start searching for it.
solve(InitialState) :-
    search(InitialState, state(on_chair, yes, under_banana, under_banana, yes), [InitialState], Actions),
    writeln(Actions).


% Failure Queries Criteria:
% 1- The Monkey is on_floor when far from the chair

% If the monkey already has a banana, then it returns "Reached the goal" and an empty Actions list (Unless the state breaks the logic, like if the monkey's on chair but far from it)

% -----------------------------Example Queries------------------------------|
% 1- solve(state(on_floor, no, window, under_banana, no)). --> True.        |
% 2- solve(state(on_floor, no, window, under_banana, yes)). --> True.       |
% 3- solve(state(on_chair, no, window, window, no)). --> True.              |
% 4- solve(state(on_floor, no, window, window, no)). --> True.              |
% 5- solve(state(on_floor, no, corner, window, no)). --> True.              |
% 6- solve(state(on_floor, yes, under_banana, under_banana, yes)). --> True.|
% 7- solve(state(on_chair, no, window, under_banana, yes)). --> False.      |
% 8- solve(state(on_chair, yes, corner, window, no)). --> False.            |
% 9- solve(state(on_chair, yes, under_banana, corner, yes)). --> False.     |
% 10 - solve(state(on_chair, no, under_banana, window, no)). --> False.     |
