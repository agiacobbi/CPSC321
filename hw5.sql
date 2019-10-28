SELECT album_title FROM albums 
WHERE year_recorded = 2007;
SELECT label_name FROM labels 
WHERE year_founded = 1968 
AND label_type = "British";
SELECT label_name FROM labels
WHERE (label_type = "British" OR label_type = "American")
AND (year_founded >= 1980 AND year_founded < 1990);

SELECT first_name, last_name FROM memberOf
WHERE group_name = "Music Makers";

SELECT DISTINCT m1.first_name, m1.last_name FROM memberOf m1, memberOf m2 
WHERE m1.first_name = m2.first_name 
AND m1.last_name = m2.last_name 
AND m1.group_name != m2.group_name;

SELECT DISTINCT g1.group_name, gr.year_founded FROM genres g1, genres g2, genres g3, groups gr 
WHERE g1.group_name = g2.group_name 
AND g1.group_name = g3.group_name 
AND g1.group_name = gr.group_name 
AND g2.group_name = g3.group_name 
AND g2.group_name = gr.group_name 
AND g3.group_name = gr.group_name 
AND g1.genre != g2.genre 
AND g1.genre != g3.genre 
AND g2.genre != g3.genre;
SELECT group_name FROM influences
WHERE influence_group = "John Apples";

SELECT al.album_title FROM albums al 
JOIN artists ar ON al.group_name = CONCAT(ar.first_name, " ", ar.last_name) 
WHERE al.year_recorded >= 2005 
AND al.year_recorded <= 2010;

SELECT DISTINCT m1.first_name, m1.last_name, m1.group_name FROM memberOf m1, genres g1, genres g2 
WHERE m1.group_name = g1.group_name 
AND m1.group_name = g2.group_name 
AND g1.genre != g2.genre
AND (year_out > 2000 OR year_out IS NULL)
AND year_in < 2010;

SELECT DISTINCT s1.song_title, s1.group_name, s2.group_name FROM songs s1, songs s2, influences i 
WHERE s1.song_title = s2.song_title 
AND s1.group_name != s2.group_name
AND s1.group_name = i.group_name
AND s2.group_name = i.influence_group;


SELECT label_name, album_title, group_name FROM labels 
JOIN albums 
ON labels.label_name = albums.label 
WHERE year_founded < 1970 
AND label_type != "German";
