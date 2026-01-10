UPDATE kitegames
SET event_ts = LEFT(event_ts, LEN(event_ts) - 4)

ALTER TABLE kitegames
ALTER COLUMN event_ts datetime2(7)

SELECT * FROM kitegames