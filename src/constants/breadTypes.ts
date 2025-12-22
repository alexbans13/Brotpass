// Bread type definitions and labels

import { BreadType } from '@/lib/types';

export const BREAD_TYPES: Record<BreadType, string> = {
  wheat_bread: 'Wheat bread',
  mixed_wheat_bread: 'Mixed wheat bread',
  mixed_rye_bread: 'Mixed rye bread',
  rye_bread: 'Rye bread',
  wholegrain_bread: 'Wholegrain bread (Vollkorn)',
  multigrain: 'Multigrain (Mehrkorn)',
};

export const BREAD_TYPE_DESCRIPTIONS: Record<BreadType, string> = {
  wheat_bread: '≥ 90% wheat',
  mixed_wheat_bread: '> 50% wheat, > 10% other grain',
  mixed_rye_bread: '> 50% rye, > 10% other grain',
  rye_bread: '≥ 90% rye',
  wholegrain_bread: '≥ 90% wholegrain',
  multigrain: '≥ 3 grains, each ≥ 5%',
};

export const BREAD_TYPES_ARRAY: BreadType[] = [
  'wheat_bread',
  'mixed_wheat_bread',
  'mixed_rye_bread',
  'rye_bread',
  'wholegrain_bread',
  'multigrain',
];

