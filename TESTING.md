# Number Guessing Game Tests

## Syntax and repository checks

- [ ] `bash -n number_guess.sh` completes without errors.
- [ ] `git diff --check` reports no whitespace errors.
- [ ] The project finishes on the `main` branch.

## Game behavior

- [ ] A new username receives the first-time welcome message.
- [ ] An existing username receives the correct game count and best score.
- [ ] A guess higher than the secret number prints the lower hint.
- [ ] A guess lower than the secret number prints the higher hint.
- [ ] A non-integer guess prints the integer-validation message.
- [ ] The correct guess prints the final result with the number of tries.

## Database behavior

- [ ] Completed games increment `games_played`.
- [ ] `best_game` stores the fewest guesses needed to win.
- [ ] Usernames can contain up to 22 characters.
- [ ] Apostrophes in usernames do not break SQL queries.
