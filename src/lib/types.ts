// Core TypeScript types for Brotpass

export type BreadType =
  | 'wheat_bread'
  | 'mixed_wheat_bread'
  | 'mixed_rye_bread'
  | 'rye_bread'
  | 'wholegrain_bread'
  | 'multigrain';

export type BadgeCategory =
  | 'volume'
  | 'bread_style'
  | 'region'
  | 'bakery_hopping';

export interface User {
  id: string;
  email: string;
  username: string;
  avatar?: string;
  bio?: string;
  location?: string;
  check_ins_count: number;
  breads_tried_count: number;
  avg_rating?: number;
  created_at: string;
  updated_at: string;
}

export interface Bakery {
  id: string;
  name: string;
  google_maps_place_id?: string;
  address?: string;
  country?: string;
  region?: string;
  is_chain: boolean;
  created_at: string;
  updated_at: string;
}

export interface Bread {
  id: string;
  name: string;
  bread_type: BreadType;
  country?: string;
  region?: string;
  description?: string;
  created_by?: string;
  created_at: string;
  updated_at: string;
  // Joined data
  bakeries?: Bakery[];
}

export interface CheckIn {
  id: string;
  user_id: string;
  bread_id: string;
  rating?: number; // 1-5 with 0.25 increments
  notes?: string;
  price?: number;
  is_public: boolean;
  created_at: string;
  // Joined data
  user?: User;
  bread?: Bread;
  photos?: CheckInPhoto[];
}

export interface CheckInPhoto {
  id: string;
  check_in_id: string;
  photo_url: string;
  display_order: number; // 1-3
  created_at: string;
}

export interface Badge {
  id: string;
  name: string;
  description?: string;
  category: BadgeCategory;
  level: number;
  max_level: number;
  progress_requirement: number;
  icon_name?: string;
  created_at: string;
}

export interface UserBadge {
  id: string;
  user_id: string;
  badge_id: string;
  current_progress: number;
  is_unlocked: boolean;
  unlocked_at?: string;
  created_at: string;
  updated_at: string;
  // Joined data
  badge?: Badge;
}

