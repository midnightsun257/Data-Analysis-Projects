-- 1. the 5 oldest users 
SELECT * FROM users
    ORDER BY created_at
    LIMIT 5;
    
-- 2. what days of the week do most users register on?
SELECT
	id,
    username,
    created_at,
    DAYNAME(created_at) AS day_of_the_week,
    COUNT(*) AS total_count
FROM users
    GROUP by day_of_the_week
    ORDER by total_count DESC;
    
-- 3. users who've never made a post?
SELECT
	users.id,
    username,
    users.created_at as user_joining_date
FROM users
    LEFT JOIN photos
        ON users.id = photos.user_id
    WHERE photos.user_id IS NULL;
    
-- 4. Most likes on a single photo?
SELECT 
	users.username,
    photos.id,
    photos.image_url,
    COUNT(*) AS Total_Likes
FROM likes
	JOIN photos ON photos.id = likes.photo_id
	JOIN users ON users.id = likes.user_id
	GROUP BY photos.id
	ORDER BY Total_Likes DESC
	LIMIT 1;
    
-- 5. How many times does the average user post?
SELECT (SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users)
	AS avg_user_post;
    
-- 6. rank users by number of posts in desc order
SELECT 
	users.username,
    COUNT(photos.image_url)
FROM users
	JOIN photos ON users.id = photos.user_id
	GROUP BY users.id
	ORDER BY COUNT(photos.image_url) DESC;
    
-- 7. Total posts by users
SELECT 
	SUM(user_posts.total_posts_per_user)
FROM 
	(SELECT users.username,
			COUNT(photos.image_url) AS total_posts_per_user
	FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;

-- 8. total num of users who've posted atleast once
SELECT 
	COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
	JOIN photos ON users.id = photos.user_id;
    
-- 9. top 5 most commonly used hashtags
SELECT 
	tag_name, 
    COUNT(tag_name) AS total
FROM tags
	JOIN photo_tags ON tags.id = photo_tags.tag_id
	GROUP BY tags.id
	ORDER BY total DESC;

/* 10. tackling the bots problem: have liked every single 
photo on the site*/
SELECT 
	users.id,username, 
	COUNT(users.id) As total_likes_by_user
FROM users
	JOIN likes ON users.id = likes.user_id
	GROUP BY users.id
	HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);

-- 11. Users who've never commented on a photo
SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL;
    
    