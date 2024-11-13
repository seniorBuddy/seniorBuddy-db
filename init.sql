USE seniorbuddy_db;

-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_real_name VARCHAR(100) NOT NULL,
    user_uuid VARCHAR(36) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(16) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME NULL,
    latitude FLOAT NULL,
    longitude FLOAT NULL,
    last_update_location DATETIME NULL,
    ai_profile INT DEFAULT 1,
    fcm_token VARCHAR(255),
    CONSTRAINT chk_contact CHECK (phone_number IS NOT NULL OR email IS NOT NULL)
);

CREATE TABLE scheduled_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    scheduled_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_schedule (
    user_id INT PRIMARY KEY,
    breakfast_time TIME NULL,
    lunch_time TIME NULL,
    dinner_time TIME NULL,
    bedtime_time TIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),

    CONSTRAINT fk_user_id FOREIGN KEY (user_id) 
    REFERENCES users(user_id) 
    ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
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
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    thread_id CHAR(36),
    sender_type VARCHAR(18) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES assistant_threads(thread_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS medication_reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    dose_morning BOOLEAN NOT NULL,           -- 아침 복용 여부
    dose_breakfast_before BOOLEAN NOT NULL,  -- 아침 식사 전 복용 여부
    dose_breakfast_after BOOLEAN NOT NULL,   -- 아침 식사 후 복용 여부
    dose_lunch_before BOOLEAN NOT NULL,      -- 점심 식사 전 복용 여부
    dose_lunch_after BOOLEAN NOT NULL,       -- 점심 식사 후 복용 여부
    dose_dinner_before BOOLEAN NOT NULL,     -- 저녁 식사 전 복용 여부
    dose_dinner_after BOOLEAN NOT NULL,      -- 저녁 식사 후 복용 여부
    dose_bedtime BOOLEAN NOT NULL,           -- 취침 전 복용 여부
    additional_info TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hospital_reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    start_date DATE NOT NULL,
    reminder_time TIME NOT NULL,
    additional_info TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_id_medication_reminders ON medication_reminders(user_id);
CREATE INDEX idx_user_id_hospital_reminders ON hospital_reminders(user_id);

SET time_zone = '+09:00';
