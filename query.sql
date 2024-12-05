-- Sprint Challenge: SQL - Online Chat System Assignment

-- CREATE TABLE STATEMENTS

-- Table: organization
CREATE TABLE organization (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

-- Table: channel
CREATE TABLE channel (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    organization_id INTEGER NOT NULL,
    FOREIGN KEY (organization_id) REFERENCES organization (id) ON DELETE CASCADE
);

-- Table: user
CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    organization_id INTEGER NOT NULL,
    FOREIGN KEY (organization_id) REFERENCES organization (id) ON DELETE CASCADE
);

-- Table: message
CREATE TABLE message (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_time TEXT DEFAULT (datetime('now')),
    content TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    channel_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES channel (id) ON DELETE CASCADE
);

-- Join Table: user_channel
CREATE TABLE user_channel (
    user_id INTEGER NOT NULL,
    channel_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, channel_id),
    FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES channel (id) ON DELETE CASCADE
);

-- INSERT QUERIES

-- Insert an organization
INSERT INTO organization (name) VALUES ('Lambda School');

-- Insert users
INSERT INTO user (name, organization_id) VALUES ('Alice', 1);
INSERT INTO user (name, organization_id) VALUES ('Bob', 1);
INSERT INTO user (name, organization_id) VALUES ('Chris', 1);

-- Insert channels
INSERT INTO channel (name, organization_id) VALUES ('#general', 1);
INSERT INTO channel (name, organization_id) VALUES ('#random', 1);

-- Add user-channel relationships
INSERT INTO user_channel (user_id, channel_id) VALUES (1, 1); -- Alice in #general
INSERT INTO user_channel (user_id, channel_id) VALUES (1, 2); -- Alice in #random
INSERT INTO user_channel (user_id, channel_id) VALUES (2, 1); -- Bob in #general
INSERT INTO user_channel (user_id, channel_id) VALUES (3, 2); -- Chris in #random

-- Insert messages
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Hello from Alice in #general', 1, 1);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Hi everyone!', 1, 2);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Bob here!', 2, 1);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Chris in #random', 3, 2);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Alice again!', 1, 2);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Random message!', 3, 2);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Another one from Bob', 2, 1);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Final message', 3, 2);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'Wrapping up here!', 1, 1);
INSERT INTO message (post_time, content, user_id, channel_id) VALUES (datetime('now'), 'See you all later!', 2, 1);

-- SELECT QUERIES

-- List all organization names
SELECT name FROM organization;

-- List all channel names
SELECT name FROM channel;

-- List all channels in a specific organization by organization name
SELECT channel.name 
FROM channel 
JOIN organization ON channel.organization_id = organization.id 
WHERE organization.name = 'Lambda School';

-- List all messages in a specific channel by channel name #general in order of post_time, descending
SELECT message.content, message.post_time 
FROM message 
JOIN channel ON message.channel_id = channel.id 
WHERE channel.name = '#general' 
ORDER BY message.post_time DESC;

-- List all channels to which user Alice belongs
SELECT channel.name 
FROM channel 
JOIN user_channel ON channel.id = user_channel.channel_id 
JOIN user ON user_channel.user_id = user.id 
WHERE user.name = 'Alice';

-- List all users that belong to channel #general
SELECT user.name 
FROM user 
JOIN user_channel ON user.id = user_channel.user_id 
JOIN channel ON user_channel.channel_id = channel.id 
WHERE channel.name = '#general';

-- List all messages in all channels by user Alice
SELECT message.content, channel.name AS channel_name 
FROM message 
JOIN user ON message.user_id = user.id 
JOIN channel ON message.channel_id = channel.id 
WHERE user.name = 'Alice';

-- List all messages in #random by user Bob
SELECT message.content, message.post_time 
FROM message 
JOIN user ON message.user_id = user.id 
JOIN channel ON message.channel_id = channel.id 
WHERE user.name = 'Bob' AND channel.name = '#random';

-- List the count of messages across all channels per user
SELECT user.name AS "User Name", COUNT(message.id) AS "Message Count" 
FROM user 
LEFT JOIN message ON user.id = message.user_id 
GROUP BY user.name 
ORDER BY user.name DESC;

-- [Stretch!] List the count of messages per user per channel
SELECT user.name AS "User", channel.name AS "Channel", COUNT(message.id) AS "Message Count" 
FROM user 
JOIN message ON user.id = message.user_id 
JOIN channel ON message.channel_id = channel.id 
GROUP BY user.name, channel.name 
ORDER BY user.name, channel.name;

-- SQL Keywords or Concept to Automatically Delete All Messages by a User
-- ON DELETE CASCADE (used in the FOREIGN KEY constraints in the message table)
