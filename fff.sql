-- 1. ПОЛЬЗОВАТЕЛИ И АККАУНТЫ
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Channels (
    channel_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    channel_name TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Subscriptions (
    subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscriber_id INTEGER NOT NULL,
    channel_id INTEGER NOT NULL,
    subscribed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscriber_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id)
);

CREATE TABLE Membership_Tiers (
    tier_id INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id INTEGER NOT NULL,
    tier_name TEXT NOT NULL,
    price REAL NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id)
);

CREATE TABLE Channel_Memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    channel_id INTEGER NOT NULL,
    tier_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id),
    FOREIGN KEY (tier_id) REFERENCES Membership_Tiers(tier_id)
);

-- 2. КОНТЕНТ (ВИДЕО И МЕТАДАННЫЕ)
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL
);

CREATE TABLE Privacy_Statuses (
    privacy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_name TEXT NOT NULL -- public, private, unlisted
);

CREATE TABLE Videos (
    video_id INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id INTEGER NOT NULL,
    category_id INTEGER,
    privacy_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    upload_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (privacy_id) REFERENCES Privacy_Statuses(privacy_id)
);

CREATE TABLE Playlists (
    playlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id INTEGER NOT NULL,
    privacy_id INTEGER,
    title TEXT NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id),
    FOREIGN KEY (privacy_id) REFERENCES Privacy_Statuses(privacy_id)
);

CREATE TABLE Playlist_Videos (
    playlist_video_id INTEGER PRIMARY KEY AUTOINCREMENT,
    playlist_id INTEGER NOT NULL,
    video_id INTEGER NOT NULL,
    position INTEGER,
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

CREATE TABLE Video_Stats (
    video_id INTEGER PRIMARY KEY,
    views_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

-- 3. ВЗАИМОДЕЙСТВИЕ (КОММЕНТАРИИ, ЛАЙКИ)
CREATE TABLE Comments (
    comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    video_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_comment_id INTEGER,
    text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES Comments(comment_id)
);

CREATE TABLE Video_Likes (
    like_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    video_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

CREATE TABLE Comment_Likes (
    like_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    comment_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (comment_id) REFERENCES Comments(comment_id)
);

CREATE TABLE Watch_History (
    history_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    video_id INTEGER NOT NULL,
    watched_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

-- 4. РЕКЛАМА И УВЕДОМЛЕНИЯ
CREATE TABLE Notifications (
    notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    video_id INTEGER,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

CREATE TABLE Advertisers (
    advertiser_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name TEXT NOT NULL
);

CREATE TABLE Advertisements (
    ad_id INTEGER PRIMARY KEY AUTOINCREMENT,
    advertiser_id INTEGER NOT NULL,
    video_id INTEGER,
    ad_content TEXT,
    FOREIGN KEY (advertiser_id) REFERENCES Advertisers(advertiser_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);

-- 5. ТЕГИ, СООБЩЕСТВО И ЖАЛОБЫ
CREATE TABLE Tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT NOT NULL UNIQUE
);

CREATE TABLE Video_Tags (
    video_tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    video_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);

CREATE TABLE Community_Posts (
    post_id INTEGER PRIMARY KEY AUTOINCREMENT,
    channel_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (channel_id) REFERENCES Channels(channel_id)
);

CREATE TABLE Reports (
    report_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    video_id INTEGER NOT NULL,
    reason TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (video_id) REFERENCES Videos(video_id)
);
