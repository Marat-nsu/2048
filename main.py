import numpy as np
import random

# Heuristic weights (tune these)
WEIGHT_FREE = 4
WEIGHT_CORNER = 4
WEIGHT_SMOOTH = 8
WEIGHT_MERGES = 32
WEIGHT_MONO = 2


class Game2048:
    def __init__(self):
        self.grid = np.zeros((4, 4), dtype=int)
        self.add_new_tile()
        self.add_new_tile()

    def add_new_tile(self):
        free_pos = list(zip(*np.where(self.grid == 0)))
        if free_pos:
            i, j = random.choice(free_pos)
            self.grid[i, j] = 1 if random.random() < 0.9 else 2

    def move(self, direction):
        original = self.grid.copy()

        if direction == "left":
            for i in range(4):
                self.grid[i] = self.merge_row(self.grid[i])
        elif direction == "right":
            for i in range(4):
                self.grid[i] = self.merge_row(self.grid[i][::-1])[::-1]
        elif direction == "up":
            self.grid = self.grid.T
            for i in range(4):
                self.grid[i] = self.merge_row(self.grid[i])
            self.grid = self.grid.T
        elif direction == "down":
            self.grid = self.grid.T
            for i in range(4):
                self.grid[i] = self.merge_row(self.grid[i][::-1])[::-1]
            self.grid = self.grid.T

        return not np.array_equal(original, self.grid)

    def merge_row(self, row):
        non_zero = row[row != 0]
        merged = []
        skip = False

        for i in range(len(non_zero)):
            if skip:
                skip = False
                continue
            if i < len(non_zero) - 1 and non_zero[i] == non_zero[i + 1]:
                merged.append(non_zero[i] + 1)
                skip = True
            else:
                merged.append(non_zero[i])

        return np.array(merged + [0] * (4 - len(merged)), dtype=int)

    def evaluate_board(self):
        # Free tiles
        free = np.sum(self.grid == 0) * WEIGHT_FREE

        # Corner bonus
        max_tile = np.max(self.grid)
        corner_bonus = (
            WEIGHT_CORNER
            if max_tile
            in [self.grid[0, 0], self.grid[0, 3], self.grid[3, 0], self.grid[3, 3]]
            else 0
        )

        # Smoothness (adjacent differences)
        smoothness = 0
        for i in range(4):
            for j in range(4):
                if j < 3:
                    smoothness += abs(self.grid[i, j] - self.grid[i, j + 1])
                if i < 3:
                    smoothness += abs(self.grid[i, j] - self.grid[i + 1, j])
        smoothness *= -WEIGHT_SMOOTH

        # Merge potential
        merges = 0
        for i in range(4):
            for j in range(4):
                if j < 3 and self.grid[i, j] == self.grid[i, j + 1]:
                    merges += 1
                if i < 3 and self.grid[i, j] == self.grid[i + 1, j]:
                    merges += 1
        merges *= WEIGHT_MERGES

        # Monotonicity
        mono = 0
        for row in self.grid:
            mono += self.monotonicity_score(row) * WEIGHT_MONO
        for col in self.grid.T:
            mono += self.monotonicity_score(col) * WEIGHT_MONO
        return (
            free
            + corner_bonus
            + smoothness
            + merges
            + ((merges / WEIGHT_MERGES) + 24) * WEIGHT_MONO
        )

    def monotonicity_score(self, line):
        score = 0
        for i in range(len(line) - 1):
            if line[i] != line[i + 1]:
                score += 1
            else:
                score += 2
        return score

    def choose_move(self):
        best_score = -float("inf")
        best_move = None

        for move in ["left", "right", "up", "down"]:
            test_game = Game2048()
            test_game.grid = self.grid.copy()

            if test_game.move(move):
                score = test_game.evaluate_board()
                if score > best_score:
                    best_score = score
                    best_move = move

        return best_move if best_move else "left"  # Fallback


def run_game(_):
    game = Game2048()
    while True:
        move = game.choose_move()
        if np.max(game.grid) >= 10:
            return True
        if not game.move(move):
            return False
        game.add_new_tile()


def evaluate_moves(board):
    game = Game2048()
    game.grid = board
    evaluations = {}
    for move in ["left", "right", "up", "down"]:
        test_game = Game2048()
        test_game.grid = game.grid.copy()
        if test_game.move(move):
            evaluations[move] = test_game.evaluate_board()
    return evaluations


def main():
    print("Enter the board (16 numbers separated by spaces):")
    board = list(map(int, input().split()))
    board = np.array(board).reshape(4, 4)
    evaluations = evaluate_moves(board)
    print("Evaluations:")
    for move, evaluation in evaluations.items():
        print(f"{move}: {evaluation}")


"""
if __name__ == "__main__":
    main()
"""
# Auto-play demo
from multiprocessing import Pool

if __name__ == "__main__":
    num_games = 100

    with Pool() as pool:
        results1 = pool.map(run_game, range(num_games))

    with Pool() as pool:
        results2 = pool.map(run_game, range(num_games))

    results = results1 + results2

    win_percentage = (sum(results) / (num_games * 2)) * 100
    print(f"Win percentage over {num_games} games: {win_percentage:.2f}%")
