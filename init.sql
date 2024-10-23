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
    CONSTRAINT chk_contact CHECK (phone_number IS NOT NULL OR email IS NOT NULL)
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

CREATE TABLE IF NOT EXISTS reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                    -- 유저 id 자동 할당하게됨.
    content TEXT NOT NULL,                   -- 알람 내용 (혹은 제목)
    reminder_type VARCHAR(16) NOT NULL,      -- 예: 'medication', 'hospital', 'other' 등..
    start_date DATE NOT NULL,                -- 알람일자 ( 반복 시작일 )
    end_date DATE,                           -- 반복 종료일
    reminder_time TIME NOT NULL,             -- 알람시간
    repeat_day JSON,                 -- LIST 혹은 JSON으로 요일 배열 (예: '["1", "3", "5"]')
    additional_info TEXT,                    -- 추가정보
    notify BOOLEAN NOT NULL DEFAULT TRUE,    -- 알람여부
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 사용자 ID별로 빠른 조회를 위한 인덱스 생성
CREATE INDEX idx_user_id_reminders ON reminders(user_id);

SET time_zone = '+09:00';
