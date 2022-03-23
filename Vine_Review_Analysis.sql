-- recreate vine table
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);

-- import vine table.csv and confirm data exists
select * from vine_table;

-- 1. Filter for rows where total_votes >= 20
select *
into step1
from vine_table
where total_votes >= 20;

-- 2. Filter for rows where helpful_votes/total_votes >= 0.5
select * 
into step2
from step1
where cast(helpful_votes as float)/cast(total_votes as float) >= 0.5;

-- 3. Filter for rows where vine = 'Y'
select *
into step3
from step2
where vine = 'Y';

-- 4. Filter for rows where vine = 'N'
select *
into step4
from step2
where vine = 'N';

-- 5. Determine total reviews, 5-star reviews, percentage of 5-star reviews (of total reviews) by vine value
select COUNT(total_votes) as Total_Reviews,
COUNT(case when star_rating = 5 then 1 else null end) as FiveStar_Ratings,
CAST(CAST(COUNT(case when star_rating = 5 and vine = 'N' then 1 else null end) AS DECIMAL(5,2)) / CAST(COUNT(total_votes) AS DECIMAL(8,2))*100 as numeric(5,2)) as FiveStar_N_Percent,
CAST(CAST(COUNT(case when star_rating = 5 and vine = 'Y' then 1 else null end) AS DECIMAL(5,2)) / CAST(COUNT(total_votes) AS DECIMAL(8,2))*100 as numeric(5,2)) as FiveStar_Y_Percent
into vine_summary
from step2;

