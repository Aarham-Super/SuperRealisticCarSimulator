PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  country_code TEXT,
  date_of_birth TEXT,
  email_verified_at TEXT,
  username_change_locked_until TEXT,
  password_changed_at TEXT,
  account_status TEXT NOT NULL DEFAULT 'pending',
  last_login_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_profiles (
  profile_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  bio TEXT,
  preferred_car_id INTEGER,
  favorite_color TEXT,
  show_online_status INTEGER NOT NULL DEFAULT 1,
  show_country INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS game_settings (
  setting_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  graphics_quality TEXT NOT NULL DEFAULT 'high',
  audio_master_volume INTEGER NOT NULL DEFAULT 80,
  audio_music_volume INTEGER NOT NULL DEFAULT 70,
  audio_sfx_volume INTEGER NOT NULL DEFAULT 80,
  control_scheme TEXT NOT NULL DEFAULT 'keyboard',
  language_code TEXT NOT NULL DEFAULT 'en',
  data_sharing_enabled INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_sessions (
  session_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  refresh_token_hash TEXT NOT NULL,
  device_name TEXT,
  ip_address TEXT,
  user_agent TEXT,
  expires_at TEXT NOT NULL,
  revoked_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS game_saves (
  save_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  save_slot INTEGER NOT NULL DEFAULT 1,
  save_name TEXT NOT NULL,
  current_map TEXT NOT NULL,
  car_id INTEGER,
  level INTEGER NOT NULL DEFAULT 1,
  total_play_time_seconds INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id, save_slot),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS achievements (
  achievement_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_url TEXT,
  points INTEGER NOT NULL DEFAULT 10,
  is_secret INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_achievements (
  user_achievement_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  achievement_id INTEGER NOT NULL,
  unlocked_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  progress_value INTEGER NOT NULL DEFAULT 0,
  UNIQUE (user_id, achievement_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_friends (
  friend_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  friend_user_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id, friend_user_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (friend_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS clans (
  clan_id INTEGER PRIMARY KEY AUTOINCREMENT,
  clan_name TEXT NOT NULL UNIQUE,
  tag TEXT NOT NULL UNIQUE,
  owner_user_id INTEGER NOT NULL,
  description TEXT,
  emblem_url TEXT,
  privacy TEXT NOT NULL DEFAULT 'public',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS clan_members (
  clan_member_id INTEGER PRIMARY KEY AUTOINCREMENT,
  clan_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  role TEXT NOT NULL DEFAULT 'member',
  joined_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (clan_id, user_id),
  FOREIGN KEY (clan_id) REFERENCES clans(clan_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS player_inventory (
  inventory_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  item_code TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  acquired_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id, item_code),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS map_zones (
  zone_id INTEGER PRIMARY KEY AUTOINCREMENT,
  zone_code TEXT NOT NULL UNIQUE,
  zone_name TEXT NOT NULL,
  environment_type TEXT NOT NULL DEFAULT 'forest',
  weather_profile TEXT,
  unlock_level INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS weather_states (
  weather_state_id INTEGER PRIMARY KEY AUTOINCREMENT,
  state_code TEXT NOT NULL UNIQUE,
  state_name TEXT NOT NULL,
  rain_strength INTEGER NOT NULL DEFAULT 0,
  fog_strength INTEGER NOT NULL DEFAULT 0,
  wind_strength INTEGER NOT NULL DEFAULT 0,
  time_of_day TEXT NOT NULL DEFAULT 'day',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notifications (
  notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  notification_type TEXT NOT NULL DEFAULT 'info',
  is_read INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ban_records (
  ban_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  reason TEXT NOT NULL,
  banned_by_user_id INTEGER,
  banned_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS support_tickets (
  ticket_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  ticket_status TEXT NOT NULL DEFAULT 'open',
  priority TEXT NOT NULL DEFAULT 'normal',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS audit_logs (
  audit_log_id INTEGER PRIMARY KEY AUTOINCREMENT,
  actor_user_id INTEGER,
  action_code TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id INTEGER,
  details TEXT,
  ip_address TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cars (
  car_id INTEGER PRIMARY KEY AUTOINCREMENT,
  car_code TEXT NOT NULL UNIQUE,
  car_name TEXT NOT NULL,
  brand_name TEXT NOT NULL,
  model_year INTEGER NOT NULL,
  drivetrain TEXT NOT NULL DEFAULT 'rwd',
  rarity TEXT NOT NULL DEFAULT 'common',
  default_unlocked INTEGER NOT NULL DEFAULT 0,
  coin_price INTEGER NOT NULL DEFAULT 0,
  cash_price INTEGER NOT NULL DEFAULT 0,
  requires_coin_and_cash INTEGER NOT NULL DEFAULT 0,
  top_speed_kph INTEGER NOT NULL DEFAULT 0,
  horsepower INTEGER NOT NULL DEFAULT 0,
  acceleration_rating INTEGER NOT NULL DEFAULT 0,
  handling_rating INTEGER NOT NULL DEFAULT 0,
  braking_rating INTEGER NOT NULL DEFAULT 0,
  image_url TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_garage (
  garage_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  car_id INTEGER NOT NULL,
  acquired_via TEXT NOT NULL DEFAULT 'default',
  purchase_coin_cost INTEGER NOT NULL DEFAULT 0,
  purchase_cash_cost INTEGER NOT NULL DEFAULT 0,
  is_owned INTEGER NOT NULL DEFAULT 1,
  is_equipped INTEGER NOT NULL DEFAULT 0,
  acquired_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id, car_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS car_purchase_history (
  purchase_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  car_id INTEGER NOT NULL,
  purchase_currency TEXT NOT NULL DEFAULT 'free',
  coin_spent INTEGER NOT NULL DEFAULT 0,
  cash_spent INTEGER NOT NULL DEFAULT 0,
  purchased_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS username_change_history (
  change_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  old_username TEXT NOT NULL,
  new_username TEXT NOT NULL,
  changed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  next_allowed_change_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS account_backup_codes (
  code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  code_hash TEXT NOT NULL,
  code_label TEXT,
  is_used INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  used_at TEXT,
  UNIQUE (user_id, code_hash),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
  reset_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token_hash TEXT NOT NULL,
  requested_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  used_at TEXT,
  ip_address TEXT,
  UNIQUE (user_id, token_hash),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS email_verification_tokens (
  verification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token_hash TEXT NOT NULL,
  requested_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  verified_at TEXT,
  UNIQUE (user_id, token_hash),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT OR IGNORE INTO cars (
  car_code, car_name, brand_name, model_year, drivetrain, rarity, default_unlocked,
  coin_price, cash_price, requires_coin_and_cash, top_speed_kph, horsepower,
  acceleration_rating, handling_rating, braking_rating, image_url
) VALUES
('starter-vortex', 'Vortex GT', 'Aarham Motors', 2024, 'rwd', 'common', 1, 0, 0, 0, 220, 310, 62, 58, 60, NULL),
('starter-drift', 'Driftline S', 'Aarham Motors', 2024, 'rwd', 'common', 1, 0, 0, 0, 210, 280, 60, 61, 58, NULL),
('forest-sprint', 'Forest Sprint', 'Aarham Motors', 2025, 'awd', 'rare', 0, 1200, 0, 0, 245, 380, 73, 67, 69, NULL),
('midnight-gt', 'Midnight GT', 'Aarham Motors', 2025, 'rwd', 'rare', 0, 1800, 0, 0, 255, 420, 76, 66, 64, NULL),
('eclipse-rs', 'Eclipse RS', 'Aarham Motors', 2025, 'awd', 'epic', 0, 2200, 15, 1, 270, 520, 82, 72, 70, NULL),
('thunder-x', 'Thunder X', 'Aarham Motors', 2026, 'awd', 'epic', 0, 2600, 20, 1, 285, 610, 85, 70, 74, NULL),
('phoenix-r', 'Phoenix R', 'Aarham Motors', 2026, 'rwd', 'legendary', 0, 0, 35, 0, 315, 760, 92, 74, 78, NULL),
('aurora-t', 'Aurora T', 'Aarham Motors', 2026, '4wd', 'legendary', 0, 3200, 45, 1, 330, 880, 95, 78, 81, NULL),
('ridge-7', 'Ridge 7', 'Aarham Motors', 2023, 'awd', 'common', 1, 0, 0, 0, 205, 240, 55, 57, 56, NULL),
('shadow-9', 'Shadow 9', 'Aarham Motors', 2024, 'rwd', 'rare', 0, 1400, 10, 1, 250, 390, 71, 63, 65, NULL),
('storm-sv', 'Storm SV', 'Aarham Motors', 2025, 'awd', 'epic', 0, 2800, 25, 1, 295, 640, 88, 75, 76, NULL),
('nova-z', 'Nova Z', 'Aarham Motors', 2026, 'rwd', 'legendary', 0, 4000, 50, 1, 350, 950, 98, 80, 84, NULL);

CREATE TABLE IF NOT EXISTS database_health (
  health_id INTEGER PRIMARY KEY AUTOINCREMENT,
  database_role TEXT NOT NULL,
  database_engine TEXT NOT NULL,
  is_online INTEGER NOT NULL DEFAULT 1,
  last_checked_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  failover_reason TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS backup_metadata (
  backup_id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_database TEXT NOT NULL,
  backup_path TEXT NOT NULL,
  backup_status TEXT NOT NULL DEFAULT 'ready',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  restored_at TEXT
);

CREATE TABLE IF NOT EXISTS sync_queue (
  sync_queue_id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL,
  entity_id INTEGER NOT NULL,
  operation_type TEXT NOT NULL,
  payload TEXT NOT NULL,
  sync_status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processed_at TEXT
);

CREATE TABLE IF NOT EXISTS feature_flags (
  flag_id INTEGER PRIMARY KEY AUTOINCREMENT,
  flag_key TEXT NOT NULL UNIQUE,
  flag_value TEXT NOT NULL,
  description TEXT,
  enabled INTEGER NOT NULL DEFAULT 1,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
