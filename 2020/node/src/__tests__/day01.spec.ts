import { which_pair_is_2020 } from '../day01';

const example_expenses: number[] = [1721, 979, 366, 299, 675, 1456]

test('which_pair_is_2020', () => {
  expect(which_pair_is_2020(example_expenses)).toEqual([1721, 299]);
});