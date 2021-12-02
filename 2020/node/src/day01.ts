import * as fs from 'fs';
import { readFile } from './utils'

export const load_expenses = (): number[] => {
  const input: string = fs.readFileSync("../inputs/day01-input.txt", "utf8");
  const expenses: number[] = input.split("\n").map((line) => parseInt(line, 10));
  return expenses;
}

export const which_pair_is_2020 = (expenses: number[]): number[] => {
  for (let i = 0; i < expenses.length; i++) {
		const ei = expenses[i];
		for (let j = i + 1; j < expenses.length; j++) {
			const ej = expenses[j];
			if (ei + ej === 2020) {
				return [ei, ej];
			}
		}
	}
	return [0, 0];
}

function part1(): number {
  const expenses = load_expenses();
  const the_pair = which_pair_is_2020(expenses);
  return the_pair.reduce((a,b) => {return a*b});
}

function part2(): number {
  const expenses = load_expenses();
  const the_triplet = which_triplet_is_2020(expenses);
  return the_triplet.reduce((a,b) => {return a*b});
}

if (process.env.AOC_REALZ) {
  console.log("Part 1: " + part1());
  console.log("Part 2: " + part2());
}
