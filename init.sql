USE seniorbuddy_db;

-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_real_name VARCHAR(100) NOT NULL,
    user_uuid VARCHAR(36) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(16) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME NULL,
    latitude FLOAT NULL,
    longitude FLOAT NULL,
    last_update_location DATETIME NULL,
    ai_profile INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS assistant_threads (
    thread_id CHAR(36) PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    run_state VARCHAR(50) NULL,
    run_id VARCHAR(100) NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS assistant_messages (
    message_id CHAR(36) PRIMARY KEY, 
    thread_id CHAR(36),
    sender_type VARCHAR(18) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES assistant_threads(thread_id) ON DELETE SET NULL
);

-- 복약 시간 테이블
CREATE TABLE IF NOT EXISTS medication_times (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    medication_time TIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 리마인더 테이블
CREATE TABLE IF NOT EXISTS reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    mind_date DATE NOT NULL,
    mind_time TIME NOT NULL,
    type VARCHAR(16) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notification_settings (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    reminder_id INT,
    medication_id INT,
    notify_time TIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reminder_id) REFERENCES reminders(reminder_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medication_times(medication_id) ON DELETE CASCADE,
    CHECK ((reminder_id IS NOT NULL AND medication_id IS NULL) OR
           (reminder_id IS NULL AND medication_id IS NOT NULL))
);

CREATE INDEX idx_user_id_medication_times ON medication_times(user_id);
CREATE INDEX idx_user_id_reminders ON reminders(user_id);
CREATE INDEX idx_notify_time_notification_settings ON notification_settings(notify_time);
