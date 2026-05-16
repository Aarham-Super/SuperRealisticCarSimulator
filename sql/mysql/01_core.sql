CREATE DATABASE IF NOT EXISTS superrealisticcar_core
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE superrealisticcar_core;

CREATE TABLE users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  avatar_url VARCHAR(500) DEFAULT NULL,
  country_code CHAR(2) DEFAULT NULL,
  date_of_birth DATE DEFAULT NULL,
  account_status ENUM('active','banned','deleted','pending') NOT NULL DEFAULT 'pending',
  last_login_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_username (username),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_profiles (
  profile_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  bio VARCHAR(500) DEFAULT NULL,
  preferred_car_id BIGINT UNSIGNED DEFAULT NULL,
  favorite_color VARCHAR(30) DEFAULT NULL,
  show_online_status TINYINT(1) NOT NULL DEFAULT 1,
  show_country TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (profile_id),
  UNIQUE KEY uq_user_profiles_user_id (user_id),
  KEY ix_user_profiles_preferred_car_id (preferred_car_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE game_settings (
  setting_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  graphics_quality ENUM('low','medium','high','ultra') NOT NULL DEFAULT 'high',
  audio_master_volume TINYINT UNSIGNED NOT NULL DEFAULT 80,
  audio_music_volume TINYINT UNSIGNED NOT NULL DEFAULT 70,
  audio_sfx_volume TINYINT UNSIGNED NOT NULL DEFAULT 80,
  control_scheme ENUM('keyboard','gamepad','wheel','touch') NOT NULL DEFAULT 'keyboard',
  language_code VARCHAR(10) NOT NULL DEFAULT 'en',
  data_sharing_enabled TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (setting_id),
  UNIQUE KEY uq_game_settings_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_sessions (
  session_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  refresh_token_hash VARCHAR(255) NOT NULL,
  device_name VARCHAR(120) DEFAULT NULL,
  ip_address VARCHAR(45) DEFAULT NULL,
  user_agent VARCHAR(500) DEFAULT NULL,
  expires_at DATETIME NOT NULL,
  revoked_at DATETIME DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (session_id),
  KEY ix_user_sessions_user_id (user_id),
  KEY ix_user_sessions_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE game_saves (
  save_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  save_slot TINYINT UNSIGNED NOT NULL DEFAULT 1,
  save_name VARCHAR(100) NOT NULL,
  current_map VARCHAR(100) NOT NULL,
  car_id BIGINT UNSIGNED DEFAULT NULL,
  level INT UNSIGNED NOT NULL DEFAULT 1,
  total_play_time_seconds INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (save_id),
  UNIQUE KEY uq_game_saves_user_slot (user_id, save_slot)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE achievements (
  achievement_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL,
  title VARCHAR(120) NOT NULL,
  description VARCHAR(255) NOT NULL,
  icon_url VARCHAR(500) DEFAULT NULL,
  points INT UNSIGNED NOT NULL DEFAULT 10,
  is_secret TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (achievement_id),
  UNIQUE KEY uq_achievements_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_achievements (
  user_achievement_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  achievement_id BIGINT UNSIGNED NOT NULL,
  unlocked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  progress_value INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (user_achievement_id),
  UNIQUE KEY uq_user_achievements (user_id, achievement_id),
  KEY ix_user_achievements_achievement_id (achievement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_friends (
  friend_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  friend_user_id BIGINT UNSIGNED NOT NULL,
  status ENUM('pending','accepted','blocked') NOT NULL DEFAULT 'pending',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (friend_id),
  UNIQUE KEY uq_user_friends_pair (user_id, friend_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE clans (
  clan_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_name VARCHAR(100) NOT NULL,
  tag VARCHAR(10) NOT NULL,
  owner_user_id BIGINT UNSIGNED NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  emblem_url VARCHAR(500) DEFAULT NULL,
  privacy ENUM('public','private','invite_only') NOT NULL DEFAULT 'public',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (clan_id),
  UNIQUE KEY uq_clans_name (clan_name),
  UNIQUE KEY uq_clans_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE clan_members (
  clan_member_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  clan_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  role ENUM('leader','officer','member') NOT NULL DEFAULT 'member',
  joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (clan_member_id),
  UNIQUE KEY uq_clan_members (clan_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE player_inventory (
  inventory_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  item_code VARCHAR(50) NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  acquired_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (inventory_id),
  UNIQUE KEY uq_player_inventory (user_id, item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE map_zones (
  zone_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  zone_code VARCHAR(50) NOT NULL,
  zone_name VARCHAR(120) NOT NULL,
  environment_type ENUM('city','forest','desert','mountain','track') NOT NULL DEFAULT 'forest',
  weather_profile VARCHAR(100) DEFAULT NULL,
  unlock_level INT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (zone_id),
  UNIQUE KEY uq_map_zones_code (zone_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE weather_states (
  weather_state_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  state_code VARCHAR(50) NOT NULL,
  state_name VARCHAR(100) NOT NULL,
  rain_strength TINYINT UNSIGNED NOT NULL DEFAULT 0,
  fog_strength TINYINT UNSIGNED NOT NULL DEFAULT 0,
  wind_strength TINYINT UNSIGNED NOT NULL DEFAULT 0,
  time_of_day ENUM('day','sunset','night','dawn') NOT NULL DEFAULT 'day',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (weather_state_id),
  UNIQUE KEY uq_weather_states_code (state_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  notification_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(120) NOT NULL,
  body VARCHAR(500) NOT NULL,
  notification_type ENUM('info','reward','warning','system') NOT NULL DEFAULT 'info',
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at DATETIME DEFAULT NULL,
  PRIMARY KEY (notification_id),
  KEY ix_notifications_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ban_records (
  ban_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  reason VARCHAR(255) NOT NULL,
  banned_by_user_id BIGINT UNSIGNED DEFAULT NULL,
  banned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME DEFAULT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (ban_id),
  UNIQUE KEY uq_ban_records_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE support_tickets (
  ticket_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  subject VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  ticket_status ENUM('open','pending','resolved','closed') NOT NULL DEFAULT 'open',
  priority ENUM('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ticket_id),
  KEY ix_support_tickets_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE audit_logs (
  audit_log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_user_id BIGINT UNSIGNED DEFAULT NULL,
  action_code VARCHAR(80) NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED DEFAULT NULL,
  details JSON DEFAULT NULL,
  ip_address VARCHAR(45) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (audit_log_id),
  KEY ix_audit_logs_actor_user_id (actor_user_id),
  KEY ix_audit_logs_entity_type (entity_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

