/* 
NAME: Alex Giacobbi
COURSE: CPSC 321
ASSIGNMENT: HW 4
DESCRIPTION: 
A script to create and populate tables as specified by assignment 4
*/

-- Creating and populating the groups table
CREATE OR REPLACE TABLE groups (
    group_name VARCHAR(256) NOT NULL,
    year_founded YEAR,

    PRIMARY KEY (group_name)
);

-- Creating and populating the artists table
CREATE OR REPLACE TABLE artists (
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    birth_year YEAR,

    PRIMARY KEY (first_name, last_name)
);

CREATE OR REPLACE TABLE labels (
    label_name VARCHAR(256) NOT NULL,
    year_founded YEAR,
    label_type VARCHAR(256),

    PRIMARY KEY (label_name)    
);

CREATE OR REPLACE TABLE albums (
    album_title VARCHAR(256) NOT NULL,
    year_recorded YEAR,
    group_name VARCHAR(256) NOT NULL,
    label VARCHAR(256) NOT NULL,

    PRIMARY KEY (album_title, group_name),
    CONSTRAINT group_fk FOREIGN KEY (group_name)
        REFERENCES groups (group_name),
    CONSTRAINT label_fk FOREIGN KEY (label)
        REFERENCES labels (label_name)
);

CREATE OR REPLACE TABLE songs (
    song_title VARCHAR(256) NOT NULL,
    album_title VARCHAR(256) NOT NULL,
    group_name VARCHAR(256) NOT NULL,

    PRIMARY KEY (song_title, album_title, group_name),
    CONSTRAINT album_group_fk FOREIGN KEY (album_title, group_name)
        REFERENCES albums (album_title, group_name)
);

CREATE OR REPLACE TABLE genres (
    group_name VARCHAR(256) NOT NULL,
    genre VARCHAR(256) NOT NULL,

    CONSTRAINT genre_group_fk FOREIGN KEY (group_name)
        REFERENCES groups (group_name)
);

CREATE OR REPLACE TABLE influences (
    group_name VARCHAR(256) NOT NULL,
    influence_group VARCHAR(256) NOT NULL,

    CONSTRAINT influenced_group_fk FOREIGN KEY (group_name)
        REFERENCES groups (group_name),
    CONSTRAINT influencer_group_fk FOREIGN KEY (influence_group)
        REFERENCES groups (group_name)    
);

CREATE OR REPLACE TABLE memberOf (
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    year_in YEAR NOT NULL,
    year_out YEAR,
    group_name VARCHAR(256) NOT NULL,

    PRIMARY KEY (first_name, last_name, year_in, group_name),
    CONSTRAINT member_artist_fk FOREIGN KEY (first_name, last_name)
        REFERENCES artists (first_name, last_name),
    CONSTRAINT member_group_fk FOREIGN KEY (group_name)
        REFERENCES groups (group_name)
);

INSERT INTO groups VALUES
    ('Group A', 2017),
    ('John Apples', 1966),
    ('Music Makers', 2004),
    ('Good Choir', 1999);

INSERT INTO artists VALUES
    ('John', 'Apples', 1920),
    ('Paul', 'Note',  1993),
    ('John', 'Voce', 1944),
    ('Alli', 'Smile', 1948),
    ('Sam', 'Scales', 1942),
    ('Susan', 'Staff', 1941);

INSERT INTO labels VALUES
    ('Hill Records', 1942, 'American'),
    ('Pear Records', 1968, 'British'),
    ('Die Muzik', 1901, 'German');
    
INSERT INTO albums VALUES
    ('Our First Album', 2002, 'Group A', 'Hill Records'),
    ('Our First Album', 2012, 'John Apples', 'Pear Records'),
    ('Vocal IV', 2011, 'Good Choir', 'Hill Records'),
    ('Sleeping Songs', 2006, 'Music Makers', 'Die Muzik'),
    ('Dog Songs', 2007, 'John Apples', 'Hill Records'),
    ('Vocal II', 2010, 'Good Choir', 'Pear Records');

INSERT INTO songs VALUES
    ('Intro', 'Our First Album', 'John Apples'),
    ('Happy Song', 'Our First Album', 'John Apples'),
    ('Intro', 'Our First Album', 'Group A'),
    ('Love Song', 'Our First Album', 'Group A'),
    ('Zzzzz', 'Sleeping Songs', 'Music Makers'),
    ('Woof', 'Dog Songs', 'John Apples'),
    ('Overture', 'Vocal II', 'Good Choir'),
    ('Overture', 'Vocal IV', 'Good Choir');

INSERT INTO genres VALUES
    ('Group A', 'Rock'),
    ('Group A', 'Jazz'),
    ('John Apples', 'Pop'),
    ('Good Choir', 'Classical'),
    ('Good Choir', 'R&B'),
    ('Music Makers', 'Classical');

INSERT INTO influences VALUES
    ('Music Makers', 'John Apples'),
    ('Music Makers', 'Good Choir'),
    ('Group A', 'John Apples');

INSERT INTO memberOf VALUES
    ('John', 'Apples', 1966, 1999, 'John Apples'),
    ('John', 'Apples', 2004, 2009, 'Music Makers'),
    ('John', 'Apples', 2017, null, 'Group A'),
    ('John', 'Voce', 2005, 2008, 'Music Makers'),
    ('Alli', 'Smile', 1999, null, 'Good Choir'),
    ('Sam', 'Scales', 1999, 2004, 'Good Choir'),
    ('Susan', 'Staff', 2017, null, 'Group A'),
    ('Sam', 'Scales', 2004, null, 'Music Makers');

SELECT * FROM groups;
SELECT * FROM labels;
SELECT * FROM artists;
SELECT * FROM albums;
SELECT * FROM songs;
SELECT * FROM genres;
SELECT * FROM influences;
SELECT * FROM memberOf;