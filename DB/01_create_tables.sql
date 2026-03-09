---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 로그인 / 프로필
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- user_tbl
CREATE TABLE user_tbl (
    user_id        NUMBER        NOT NULL,
    email          VARCHAR2(255) NOT NULL,
    password       VARCHAR2(255) NOT NULL,
    nickname       VARCHAR2(30)  NOT NULL,
    email_verified NUMBER(1)     DEFAULT 0 NOT NULL,
    created_at     DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_user       PRIMARY KEY (user_id),
    CONSTRAINT uk_user_email UNIQUE (email),
    CONSTRAINT uk_user_nick  UNIQUE (nickname)
);


-- email_code_tbl
CREATE TABLE email_code_tbl (
    email_code_id  NUMBER        NOT NULL,
    email          VARCHAR2(255) NOT NULL,
    code           VARCHAR2(6)   NOT NULL,
    expires_at     DATE          NOT NULL,
    created_at     DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_email_code PRIMARY KEY (email_code_id)
);

-- profile_tbl
CREATE TABLE profile_tbl (
    user_id         NUMBER        NOT NULL,
    membership_type VARCHAR2(20)  DEFAULT 'FREE' NOT NULL,
    birth_date      DATE,
    bio             VARCHAR2(300),
    photo_url       VARCHAR2(255),
    updated_at      DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_profile PRIMARY KEY (user_id)
);


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- song
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- artists_tbl
CREATE TABLE artists_tbl (
    artist_id         NUMBER PRIMARY KEY,
    name              VARCHAR2(100),
    profile_image_url VARCHAR2(500)
);

-- albums_tbl
CREATE TABLE albums_tbl (
    album_id        NUMBER PRIMARY KEY,
    artist_id       NUMBER NOT NULL,
    title           VARCHAR2(200),
    cover_image_url VARCHAR2(500),
    release_date    DATE
);

-- genres_tbl
CREATE TABLE genres_tbl (
    genre_id NUMBER PRIMARY KEY,
    name     VARCHAR2(100)
);

-- songs_tbl
CREATE TABLE songs_tbl (
    song_id   NUMBER PRIMARY KEY,
    album_id  NUMBER NOT NULL,
    artist_id NUMBER NOT NULL,
    genre_id  NUMBER NOT NULL,
    title     VARCHAR2(200)
);

-- playlists_tbl
CREATE TABLE playlists_tbl (
    playlist_id NUMBER PRIMARY KEY,
    user_id     NUMBER NOT NULL,
    title       VARCHAR2(200)
);

-- song_likes_tbl
CREATE TABLE song_likes_tbl (
    like_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    song_id NUMBER NOT NULL
);

-- play_log_tbl
CREATE TABLE play_log_tbl (
    playlog_id NUMBER PRIMARY KEY,
    song_id    NUMBER NOT NULL,
    user_id    NUMBER NOT NULL
);

-- playlist_ele_tbl
CREATE TABLE playlist_ele_tbl (
    ele_id      NUMBER PRIMARY KEY,
    playlist_id NUMBER NOT NULL,
    song_id     NUMBER NOT NULL
);

-- song_score_tbl
CREATE TABLE song_score_tbl (
    score_id   NUMBER PRIMARY KEY,
    user_id    NUMBER NOT NULL,
    song_id    NUMBER NOT NULL,
    score      NUMBER DEFAULT 0,
    created_at DATE   DEFAULT SYSDATE
);


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 공연
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- show_tbl
CREATE TABLE show_tbl (
    show_id    VARCHAR2(20)  PRIMARY KEY,
    title      VARCHAR2(300) NOT NULL,
    start_date DATE          NOT NULL,
    end_date   DATE          NOT NULL,
    venue_name VARCHAR2(200),
    poster_url VARCHAR2(500),
    area       VARCHAR2(100),
    genre      VARCHAR2(100),
    openrun_yn CHAR(1)       DEFAULT 'N' NOT NULL,
    state      VARCHAR2(30),
    created_at DATE          DEFAULT SYSDATE NOT NULL,
    updated_at DATE          DEFAULT SYSDATE NOT NULL
);

-- showDetail_tbl
CREATE TABLE showDetail_tbl (
    show_id      VARCHAR2(20)  PRIMARY KEY,
    runtime      VARCHAR2(300),
    age_limit    VARCHAR2(300),
    ticket_price CLOB,
    cast_info    CLOB,
    styurl       VARCHAR2(500)
);

-- schedule_tbl
CREATE TABLE schedule_tbl (
    schedule_id NUMBER        PRIMARY KEY,
    start_time  NUMBER,
    end_time    NUMBER,
    show_id     VARCHAR2(20)  NOT NULL
);

-- view_tbl
CREATE TABLE view_tbl (
    view_id    NUMBER        PRIMARY KEY,
    seat_label VARCHAR2(30)  NOT NULL,
    image_url  VARCHAR2(500),
    show_id    VARCHAR2(20)  NOT NULL,
    create_at  DATE          DEFAULT SYSDATE NOT NULL
);

-- review_tbl
CREATE TABLE review_tbl (
    review_id  NUMBER        PRIMARY KEY,
    user_id    NUMBER        NOT NULL,
    show_id    VARCHAR2(20)  NOT NULL,
    rating     NUMBER(1)     NOT NULL,
    content    CLOB,
    created_at DATE          DEFAULT SYSDATE NOT NULL,
    board_num  NUMBER        NOT NULL
);

-- seat_tbl
CREATE TABLE seat_tbl (
    seat_id        NUMBER       PRIMARY KEY,
    show_id        VARCHAR2(20) NOT NULL,
    schedule_id    NUMBER       NOT NULL,
    user_id        NUMBER,
    res_seat_label VARCHAR2(50),
    seat_label     VARCHAR2(30) NOT NULL,
    seat_grade     VARCHAR2(20),
    seat_status    VARCHAR2(20) DEFAULT 'AVAILABLE' NOT NULL,
    hold_at        DATE
);

-- reservation_tbl
CREATE TABLE reservation_tbl (
    reservation_id NUMBER       PRIMARY KEY,
    user_id        NUMBER       NOT NULL,
    seat_id        NUMBER       NOT NULL,
    show_id        VARCHAR2(20) NOT NULL,
    total_price    NUMBER       DEFAULT 0 NOT NULL,
    status         VARCHAR2(20) DEFAULT 'PENDING' NOT NULL,
    payment_status VARCHAR2(20) DEFAULT 'NONE' NOT NULL,
    payment_method VARCHAR2(20),
    reserved_at    DATE         DEFAULT SYSDATE NOT NULL
);


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 결제
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- payment_order
CREATE TABLE payment_order (
    order_id       VARCHAR2(50)  PRIMARY KEY,
    reservation_id NUMBER        NOT NULL,
    user_id        NUMBER        NOT NULL,
    item_name      VARCHAR2(200),
    quantity       NUMBER        DEFAULT 1 NOT NULL,
    total_amount   NUMBER        DEFAULT 0 NOT NULL,
    tid            VARCHAR2(50),
    status         VARCHAR2(20)  DEFAULT 'READY' NOT NULL,
    created_at     DATE          DEFAULT SYSDATE NOT NULL,
    approved_at    DATE,
    fail_reason    VARCHAR2(500),
    payment_type   VARCHAR2(20)
);
