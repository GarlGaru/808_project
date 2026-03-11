---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 로그인 / 프로필
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- profile_tbl
ALTER TABLE profile_tbl ADD CONSTRAINT fk_profile_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id) ON DELETE CASCADE;


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- song
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- albums_tbl
ALTER TABLE albums_tbl ADD CONSTRAINT fk_album_artist
    FOREIGN KEY (artist_id) REFERENCES artists_tbl(artist_id);

-- songs_tbl
ALTER TABLE songs_tbl ADD CONSTRAINT fk_song_album
    FOREIGN KEY (album_id) REFERENCES albums_tbl(album_id);

ALTER TABLE songs_tbl ADD CONSTRAINT fk_song_artist
    FOREIGN KEY (artist_id) REFERENCES artists_tbl(artist_id);

ALTER TABLE songs_tbl ADD CONSTRAINT fk_song_genre
    FOREIGN KEY (genre_id) REFERENCES genres_tbl(genre_id);

-- playlists_tbl
ALTER TABLE playlists_tbl ADD CONSTRAINT fk_playlist_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

-- song_likes_tbl
ALTER TABLE song_likes_tbl ADD CONSTRAINT fk_like_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

ALTER TABLE song_likes_tbl ADD CONSTRAINT fk_like_song
    FOREIGN KEY (song_id) REFERENCES songs_tbl(song_id);

ALTER TABLE song_likes_tbl ADD CONSTRAINT uk_user_song_like
    UNIQUE (user_id, song_id);

-- play_log_tbl
ALTER TABLE play_log_tbl ADD CONSTRAINT fk_playlog_song
    FOREIGN KEY (song_id) REFERENCES songs_tbl(song_id);

ALTER TABLE play_log_tbl ADD CONSTRAINT fk_playlog_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

-- playlist_ele_tbl
ALTER TABLE playlist_ele_tbl ADD CONSTRAINT fk_ele_playlist
    FOREIGN KEY (playlist_id) REFERENCES playlists_tbl(playlist_id);

ALTER TABLE playlist_ele_tbl ADD CONSTRAINT fk_ele_song
    FOREIGN KEY (song_id) REFERENCES songs_tbl(song_id);

ALTER TABLE playlist_ele_tbl ADD CONSTRAINT uk_playlist_song
    UNIQUE (playlist_id, song_id);

-- song_score_tbl
ALTER TABLE song_score_tbl ADD CONSTRAINT fk_score_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

ALTER TABLE song_score_tbl ADD CONSTRAINT fk_score_song
    FOREIGN KEY (song_id) REFERENCES songs_tbl(song_id);


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 공연
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- showDetail_tbl
ALTER TABLE showDetail_tbl ADD CONSTRAINT fk_detail_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id) ON DELETE CASCADE;

-- schedule_tbl
ALTER TABLE schedule_tbl ADD CONSTRAINT fk_schedule_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id);

-- view_tbl
ALTER TABLE view_tbl ADD CONSTRAINT fk_view_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id);

-- review_tbl
ALTER TABLE review_tbl ADD CONSTRAINT fk_review_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id);

ALTER TABLE review_tbl ADD CONSTRAINT fk_review_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

ALTER TABLE review_tbl ADD CONSTRAINT ck_review_rating
    CHECK (rating BETWEEN 1 AND 5);

ALTER TABLE review_tbl ADD CONSTRAINT uq_review_one
    UNIQUE (user_id, show_id);

-- seat_tbl
ALTER TABLE seat_tbl ADD CONSTRAINT fk_seat_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id);

ALTER TABLE seat_tbl ADD CONSTRAINT fk_seat_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

ALTER TABLE seat_tbl ADD CONSTRAINT fk_seat_schedule
    FOREIGN KEY (schedule_id) REFERENCES schedule_tbl(schedule_id);

ALTER TABLE seat_tbl ADD CONSTRAINT uq_rs_seat_unique
    UNIQUE (show_id, schedule_id, seat_label);

-- reservation_tbl
ALTER TABLE reservation_tbl ADD CONSTRAINT fk_reservation_show
    FOREIGN KEY (show_id) REFERENCES show_tbl(show_id);

ALTER TABLE reservation_tbl ADD CONSTRAINT fk_reservation_user
    FOREIGN KEY (user_id) REFERENCES user_tbl(user_id);

ALTER TABLE reservation_tbl ADD CONSTRAINT fk_reservation_seat
    FOREIGN KEY (seat_id) REFERENCES seat_tbl(seat_id);

ALTER TABLE reservation_tbl ADD CONSTRAINT ck_reservation_status
    CHECK (status IN ('PENDING','CONFIRMED','CANCEL'));

ALTER TABLE reservation_tbl ADD CONSTRAINT ck_reservation_payment_status
    CHECK (payment_status IN ('NONE','PENDING','PAID','REFUND'));


---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 결제
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- payment_order
ALTER TABLE payment_order ADD CONSTRAINT ck_pay_status
    CHECK (status IN ('READY','APPROVED','CANCEL','FAIL'));

ALTER TABLE payment_order ADD CONSTRAINT ck_payment_type
    CHECK (payment_type IN ('TICKET','SUBSCRIBE'));
