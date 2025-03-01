#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
#include <conio.h>
#else
#include <termios.h>
#include <unistd.h>
#endif

#define CLEAR_SCREEN() system(CLEAR)
#ifdef _WIN32
#define CLEAR "cls"
#else
#define CLEAR "clear"
#endif

int grid[4][4];

void set_unbuffered_input()
{
#ifndef _WIN32
	struct termios term;
	tcgetattr(STDIN_FILENO, &term);
	term.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(STDIN_FILENO, TCSANOW, &term);
#endif
}

void restore_input()
{
#ifndef _WIN32
	struct termios term;
	tcgetattr(STDIN_FILENO, &term);
	term.c_lflag |= (ICANON | ECHO);
	tcsetattr(STDIN_FILENO, TCSANOW, &term);
#endif
}

void transpose(int grid[4][4])
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = i + 1; j < 4; j++)
		{
			int temp = grid[i][j];
			grid[i][j] = grid[j][i];
			grid[j][i] = temp;
		}
	}
}

void reverse_rows(int grid[4][4])
{
	for (int i = 0; i < 4; i++)
	{
		int temp = grid[i][0];
		grid[i][0] = grid[i][3];
		grid[i][3] = temp;
		temp = grid[i][1];
		grid[i][1] = grid[i][2];
		grid[i][2] = temp;
	}
}

void slide_and_merge(int row[4])
{
	int temp[4] = {0};
	int pos = 0;
	int prev = -1;

	for (int i = 0; i < 4; i++)
	{
		if (!row[i])
			continue;

		if (prev == -1)
		{
			prev = row[i];
		}
		else
		{
			if (row[i] == prev)
			{
				temp[pos++] = prev * 2;
				prev = -1;
			}
			else
			{
				temp[pos++] = prev;
				prev = row[i];
			}
		}
	}
	if (prev != -1)
		temp[pos++] = prev;

	memcpy(row, temp, sizeof(temp));
}

int process_move(int grid[4][4], char dir)
{
	int original[4][4];
	memcpy(original, grid, sizeof(original));

	switch (dir)
	{
	case 'a':
		break;
	case 'd':
		reverse_rows(grid);
		break;
	case 'w':
		transpose(grid);
		break;
	case 's':
		transpose(grid);
		reverse_rows(grid);
		break;
	default:
		return 0;
	}

	for (int i = 0; i < 4; i++)
	{
		slide_and_merge(grid[i]);
	}

	switch (dir)
	{
	case 'd':
		reverse_rows(grid);
		break;
	case 'w':
		transpose(grid);
		break;
	case 's':
		reverse_rows(grid);
		transpose(grid);
		break;
	case 'a':
		break;
	}

	return memcmp(original, grid, sizeof(original)) != 0;
}

void add_new_tile()
{
	int empty[16][2], count = 0;

	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			if (!grid[i][j])
			{
				empty[count][0] = i;
				empty[count][1] = j;
				count++;
			}
		}
	}

	if (count)
	{
		int idx = rand() % count;
		grid[empty[idx][0]][empty[idx][1]] = (rand() % 10) ? 2 : 4;
	}
}

int is_game_over()
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			if (!grid[i][j])
				return 0;
			if (i < 3 && grid[i][j] == grid[i + 1][j])
				return 0;
			if (j < 3 && grid[i][j] == grid[i][j + 1])
				return 0;
		}
	}
	return 1;
}

void print_grid()
{
	CLEAR_SCREEN();
	printf("-----------------------------\n");
	for (int i = 0; i < 4; i++)
	{
		printf("|");
		for (int j = 0; j < 4; j++)
		{
			if (grid[i][j])
				printf("%6d |", grid[i][j]);
			else
				printf("      |");
		}
		printf("\n-----------------------------\n");
	}
}

int main()
{
	srand(time(NULL));
	memset(grid, 0, sizeof(grid));
	add_new_tile();
	add_new_tile();
	set_unbuffered_input();

	while (1)
	{
		print_grid();
		if (is_game_over())
		{
			printf("Game Over!\n");
			break;
		}

		char c =
#ifdef _WIN32
			_getch();
#else
			getchar();
#endif
		if (c == 'q')
			break;
		if (strchr("wasd", c))
		{
			if (process_move(grid, c))
			{
				add_new_tile();
			}
		}
	}

	restore_input();
	return 0;
}